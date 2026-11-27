# Copyright 2026 Ronny Trommer <ronny@no42.org>
# SPDX-License-Identifier: MIT
###
# Do not edit the generated Dockerfile
###

###
# Build stage: compile Asterisk from the release tarball. Only the installed
# tree in /out and the list of runtime packages leave this stage.
###
# hadolint ignore=DL3006
FROM "${BASE_IMAGE}" AS build

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
                                               libcurl4-openssl-dev \
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
RUN ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --libdir=/usr/lib \
                --with-pjproject-bundled && \
    make menuselect.makeopts && \
    menuselect/menuselect --disable BUILD_NATIVE menuselect.makeopts && \
    make -j "$(nproc)" && \
    make install DESTDIR=/out && \
    rm -rf /out/usr/include /out/var/run

# Resolve the shared libraries of everything in /out to the Debian packages
# that own them. The runtime stage installs exactly that list, so no package
# name is hardcoded here.
RUN { find /out -type f \( -perm -u+x -o -name '*.so' \) -exec ldd {} + 2>/dev/null || true; } | \
    awk '$2 == "=>" && $3 ~ /^\// { print $3 }' | sort -u | \
    xargs -r readlink -f | \
    { xargs -r dpkg -S 2>/dev/null || true; } | \
    cut -d: -f1 | sort -u > /out/runtime-packages.txt && \
    test -s /out/runtime-packages.txt && \
    cat /out/runtime-packages.txt

###
# Runtime image
###
# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

SHELL ["/bin/bash", "-exo", "pipefail", "-c"]

COPY --from=build /out/runtime-packages.txt /tmp/runtime-packages.txt

# hadolint ignore=DL3008
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive xargs -r apt-get -y install --no-install-recommends ca-certificates < /tmp/runtime-packages.txt && \
    rm -rf /var/lib/apt/lists/* /tmp/runtime-packages.txt && \
    groupadd --system --gid 10001 asterisk && \
    useradd --system --uid 10001 --gid asterisk --home-dir /var/lib/asterisk --shell /usr/sbin/nologin asterisk

COPY --from=build /out/usr/ /usr/
COPY --from=build --chown=asterisk:asterisk /out/var/lib/asterisk/ /var/lib/asterisk/
COPY --from=build --chown=asterisk:asterisk /out/var/spool/asterisk/ /var/spool/asterisk/
COPY --from=build --chown=asterisk:asterisk /out/var/log/asterisk/ /var/log/asterisk/
COPY --from=build --chown=asterisk:asterisk /out/var/cache/asterisk/ /var/cache/asterisk/
COPY --chown=asterisk:asterisk config/ /etc/asterisk/

# The build fails here if the binary or a module misses a shared library.
RUN mkdir -p /run/asterisk && \
    chown asterisk:asterisk /run/asterisk /etc/asterisk && \
    ldconfig && \
    asterisk -V && \
    if ldd /usr/sbin/asterisk /usr/lib/asterisk/modules/*.so | grep "not found"; then exit 1; fi

USER 10001

WORKDIR /var/lib/asterisk

ENTRYPOINT [ "/usr/sbin/asterisk" ]

# Stay in the foreground and log to stdout
CMD [ "-f" ]

### Runtime information and not relevant at build time

# SIP signalling. RTP uses the UDP range set in rtp.conf.
EXPOSE 5060/udp 5060/tcp

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.description="Asterisk PBX built from source on Debian, configured by files in /etc/asterisk" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
