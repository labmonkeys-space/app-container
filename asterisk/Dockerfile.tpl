# Copyright 2026 Ronny Trommer <ronny@no42.org>
# SPDX-License-Identifier: MIT
###
# Do not edit the generated Dockerfile
###

###
# Runtime base: distroless Debian. No shell and no package manager, so the
# build stage below prepares everything the final image gets.
###
# hadolint ignore=DL3006
FROM "${BASE_IMAGE}" AS runtime-base

###
# Build stage: compile Asterisk from the release tarball and assemble the tree
# in /out that the final image copies.
###
# hadolint ignore=DL3006
FROM "${BASE_IMAGE_BUILD}" AS build

# Change default shell for RUN from Dash to Bash
SHELL ["/bin/bash", "-exo", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get -y install --no-install-recommends build-essential \
                                               bzip2 \
                                               ca-certificates \
                                               patch \
                                               pkg-config \
                                               wget \
                                               libcap-dev \
                                               libedit-dev \
                                               libgsm1-dev \
                                               libjansson-dev \
                                               libspeex-dev \
                                               libspeexdsp-dev \
                                               libsqlite3-dev \
                                               libsrtp2-dev \
                                               libssl-dev \
                                               libunbound-dev \
                                               liburiparser-dev \
                                               libxml2-dev \
                                               libxslt1-dev \
                                               uuid-dev \
                                               zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/asterisk

RUN wget -q -O /tmp/asterisk.tar.gz "https://github.com/asterisk/asterisk/releases/download/${ASTERISK_VERSION}/asterisk-${ASTERISK_VERSION}.tar.gz" && \
    echo "${ASTERISK_SHA256}  /tmp/asterisk.tar.gz" | sha256sum -c - && \
    tar -xzf /tmp/asterisk.tar.gz --strip-components=1 && \
    rm /tmp/asterisk.tar.gz

# BUILD_NATIVE is on by default and ties the binaries to the CPU of the build
# host. pjproject is fetched by configure, the default sounds by make install.
# libcurl is left out on purpose: its modules are not needed for a SIP trunk,
# and it would pull about twenty more libraries into the runtime.
RUN ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --libdir=/usr/lib \
                --with-pjproject-bundled && \
    make menuselect.makeopts && \
    menuselect/menuselect --disable BUILD_NATIVE menuselect.makeopts && \
    make -j "$(nproc)" && \
    make install DESTDIR=/out && \
    rm -rf /out/usr/include /out/var/run

# The runtime base, to see which packages it already has and to test the
# assembled tree in it.
COPY --from=runtime-base / /rootfs/

# Resolve the shared libraries of everything in /out to the Debian packages
# that own them, so no package name is hardcoded here.
RUN { find /out -type f \( -perm -u+x -o -name '*.so' \) -exec ldd {} + 2>/dev/null || true; } | \
    awk '$2 == "=>" && $3 ~ /^\// { print $3 }' | sort -u | \
    xargs -r readlink -f | \
    { xargs -r dpkg -S 2>/dev/null || true; } | \
    cut -d: -f1 | sort -u > /tmp/needed-packages.txt && \
    test -s /tmp/needed-packages.txt && \
    test -d /rootfs/var/lib/dpkg/status.d && \
    mkdir -p /tmp/debs /out/var/lib/dpkg/status.d && \
    apt-get update

WORKDIR /tmp/debs

# Unpack every needed package the runtime base does not have into /out, in the
# version the build linked against. Each gets a package record where
# distroless keeps its own, so image scanners see it. This loop is its own
# RUN, because inside an && list the shell would ignore a failing step.
RUN while read -r pkg; do \
      if [ -e "/rootfs/var/lib/dpkg/status.d/$pkg" ]; then echo "in the runtime base: $pkg"; continue; fi; \
      version="$(dpkg-query -W -f '${Version}' "$pkg")"; \
      apt-get download "$pkg=$version" || apt-get download "$pkg"; \
      dpkg-deb -x "$pkg"_*.deb /out; \
      dpkg-deb --field "$pkg"_*.deb > "/out/var/lib/dpkg/status.d/$pkg"; \
      echo "unpacked: $pkg $version"; \
    done < /tmp/needed-packages.txt

# Debian packages may still ship files below /lib and friends. The runtime
# base has those as links into /usr, and a directory cannot be copied over a
# link.
RUN for d in bin sbin lib lib64; do \
      if [ -d "/out/$d" ] && [ ! -L "/out/$d" ]; then \
        mkdir -p "/out/usr/$d"; cp -a "/out/$d/." "/out/usr/$d/"; rm -rf "/out/$d"; \
      fi; \
    done

WORKDIR /usr/src/asterisk

COPY config/ /out/etc/asterisk/

# 65532 is the nonroot user of the distroless images.
RUN mkdir -p /out/run/asterisk && \
    chown -R 65532:65532 /out/etc/asterisk /out/run/asterisk /out/var/lib/asterisk \
                         /out/var/spool/asterisk /out/var/log/asterisk /out/var/cache/asterisk && \
    rm -rf /var/lib/apt/lists/* /tmp/debs

# Put /out into the copy of the runtime base and ask its own loader what the
# binary and every module resolve to. The build fails here if one of them
# misses a shared library in the final image.
RUN cp -a /out/. /rootfs/ && \
    loader="$(ldd /bin/true | awk '/ld-linux/ { print $1 }')" && \
    chroot /rootfs /usr/sbin/asterisk -V && \
    listing="$(for f in /rootfs/usr/sbin/asterisk /rootfs/usr/lib/asterisk/modules/*.so; do chroot /rootfs "$loader" --list "${f#/rootfs}" 2>&1 || true; done)" && \
    grep -q 'libc\.so' <<<"$listing" && \
    if grep 'not found' <<<"$listing"; then exit 1; fi

###
# Runtime image
###
FROM runtime-base

COPY --from=build /out/usr/ /usr/
COPY --from=build /out/var/ /var/
COPY --from=build /out/etc/ /etc/
COPY --from=build /out/run/ /run/

# Exec form, since there is no shell. Runs as the nonroot user.
RUN ["/usr/sbin/asterisk", "-V"]

USER 65532

WORKDIR /var/lib/asterisk

ENTRYPOINT [ "/usr/sbin/asterisk" ]

# Stay in the foreground and log to stdout
CMD [ "-f" ]

### Runtime information and not relevant at build time

# SIP signalling. RTP uses the UDP range set in rtp.conf.
EXPOSE 5060/udp 5060/tcp

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.description="Asterisk PBX built from source, distroless Debian runtime, configured by files in /etc/asterisk" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
