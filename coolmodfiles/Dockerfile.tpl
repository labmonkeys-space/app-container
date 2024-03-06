###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

RUN apk --no-cache add git && \
    addgroup coolmod && \
    adduser --system coolmod coolmod
    
USER coolmod

RUN git clone https://github.com/orhun/CoolModFiles /home/coolmod/coolmodfiles

WORKDIR /home/coolmod/coolmodfiles

RUN git checkout ${GIT_COMMIT} && \
    yarn && \
    yarn build

ENTRYPOINT ["/usr/local/bin/yarn"]

CMD ["start"]

### Runtime information and not relevant at build time
ENV DOMAIN=localhost

EXPOSE 3000/tcp

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.description="CoolModFiles is a web player for files from modarchive.org" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT" \
      io.artifacthub.package.readme-url="https://github.com/labmonkeys-space/app-container/blob/main/coolmodfiles/README.md"
