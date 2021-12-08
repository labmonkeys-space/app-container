###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Set some defaults for Postfix mail server
ENV MAILDOMAIN="example.org"
ENV MESSAGE_SIZE_LIMIT="52428800"

ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \
    apt-get update && \
    apt-get -y install --no-install-recommends inetutils-syslogd="${INETUTILS_SYSLOGD_VERSION}" \
                                               postfix="${POSTFIX_VERSION}" \
                                               dovecot-imapd="${DOVECOT_IMAPD_VERSION}" \
                                               whois="${WHOIS_VERSION}" && \
    rm -rf /var/lib/apt/lists/* && \
    rm /tmp/*.tar.gz

COPY container-fs/etc/s6/services /etc/s6/services
COPY container-fs/etc/cont-init.d /etc/cont-init.d
COPY container-fs/etc/syslog.conf /etc/syslog.conf
COPY --chown=root:dovecot container-fs/etc/dovecot/conf.d /etc/dovecot/conf.d

VOLUME ["/var/mail","/home"]

ENTRYPOINT ["/init"]

CMD ["/usr/lib/postfix/sbin/master", "-d"]

### Runtime information and not relevant at build time

EXPOSE 25 143

LABEL org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
