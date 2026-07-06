# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

ARG TARGETARCH
# Upstream names the amd64 asset "x86_64" and the arm64 one "arm64_arm7_raspberry_pi".
# hadolint ignore=DL3018
RUN case "$TARGETARCH" in \
      amd64) A=x86_64 ;; \
      arm64) A=arm64_arm7_raspberry_pi ;; \
      *) echo "unsupported TARGETARCH=$TARGETARCH" >&2; exit 1 ;; \
    esac && \
    apk add --no-cache --virtual .fetch curl && \
    curl -fsSLo /tmp/retro-aim-server.tar.gz "https://github.com/mk6i/retro-aim-server/releases/download/v${RETRO_AIM_SERVER_VERSION}/retro_aim_server.${RETRO_AIM_SERVER_VERSION}.linux.${A}.tar.gz" && \
    apk del .fetch && \
    tar xzf /tmp/retro-aim-server.tar.gz --strip-component=1 -C /usr/bin && \
    rm -rf /tmp/retro-aim-server.tar.gz && \
    adduser -S raims

USER raims

ENTRYPOINT [ "/usr/bin/retro_aim_server" ]

CMD [ "--help" ]

### Runtime information and not relevant at build time

EXPOSE 8080/tcp \
       5190/tcp \
       5191/tcp \
       5192/tcp \
       5193/tcp \
       5194/tcp \
       5195/tcp \
       5196/tcp \
       5197/tcp

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
