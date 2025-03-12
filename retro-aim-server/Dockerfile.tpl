# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

ADD "https://github.com/mk6i/retro-aim-server/releases/download/v${RETRO_AIM_SERVER_VERSION}/retro_aim_server.${RETRO_AIM_SERVER_VERSION}.linux.x86_64.tar.gz" /tmp/retro-aim-server.tar.gz

RUN tar xzf /tmp/retro-aim-server.tar.gz --strip-component=1 -C /usr/bin && \
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
