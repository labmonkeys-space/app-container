###
# Do not edit the generated Dockerfile
###

FROM "${BASE_IMAGE}"

ADD https://github.com/amborle/featmap/releases/download/v${FEATMAP_VERSION}/featmap-${FEATMAP_VERSION}-linux-amd64 /opt/featmap/featmap

RUN useradd --system featmap && \
    chmod +rx /opt/featmap/featmap && \
    chown -R featmap /opt/featmap

USER featmap

WORKDIR /opt/featmap

ENTRYPOINT [ "/opt/featmap/featmap" ]

### Runtime information and not relevant at build time

EXPOSE 5000/tcp

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.description="Featmap is a user story mapping tool for product people to build, plan and communicate product backlogs." \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT" \
      io.artifacthub.package.readme-url="https://github.com/labmonkeys-space/app-container/blob/main/featmap/README.md"
