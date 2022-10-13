###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

RUN apk --no-cache add quagga="${QUAGGA_VERSION}" iproute2 && \
    mkdir -p /etc/quagga

ENTRYPOINT ["/usr/sbin/zebra"]

CMD ["--config_file", "/dev/null", "--socket", "/zebra/zserv.api", "--user", "root"]

### Runtime information and not relevant at build time
VOLUME ["/zebra"]

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
