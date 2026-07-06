###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

ARG TARGETARCH

# Change default shell for RUN from Dash to Bash
SHELL ["/bin/bash", "-exo", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

# Set some defaults for Postfix mail server
ENV MAILDOMAIN="example.org"
ENV MESSAGE_SIZE_LIMIT="52428800"

# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get -y install --no-install-recommends xz-utils \
                                               ca-certificates \
                                               curl \
                                               inetutils-syslogd \
                                               postfix \
                                               dovecot-imapd \
                                               whois && \
    case "$TARGETARCH" in \
      amd64) S6ARCH=x86_64 ;; \
      arm64) S6ARCH=aarch64 ;; \
      *) echo "unsupported TARGETARCH=$TARGETARCH" >&2; exit 1 ;; \
    esac && \
    curl -fsSLo /tmp/s6-overlay.tar.xz "https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-${S6ARCH}.tar.xz" && \
    tar -xf /tmp/s6-overlay.tar.xz -C / && \
    rm -rf /var/lib/apt/lists/* && \
    rm /tmp/*.tar.xz

COPY container-fs/etc/s6/services /etc/s6/services
COPY container-fs/etc/cont-init.d /etc/cont-init.d
COPY container-fs/etc/syslog.conf /etc/syslog.conf
COPY --chown=root:dovecot container-fs/etc/dovecot/conf.d /etc/dovecot/conf.d

VOLUME ["/var/mail","/home"]

ENTRYPOINT ["/init"]

CMD ["/usr/lib/postfix/sbin/master", "-d"]

### Runtime information and not relevant at build time

EXPOSE 25 143

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
