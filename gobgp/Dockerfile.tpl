###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

ADD "https://github.com/osrg/gobgp/releases/download/v${GOBGP_VERSION}/gobgp_${GOBGP_VERSION}_linux_amd64.tar.gz" /tmp/gobgp.tar.gz

RUN tar xzf /tmp/gobgp.tar.gz -C /usr/bin && \
    rm -rf /tmp/gobgp.tar.gz

ENTRYPOINT [ "/usr/bin/gobgpd" ]

CMD [ "--help" ]

### Runtime information and not relevant at build time

EXPOSE 179/tcp

LABEL org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"

