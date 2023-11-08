###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

RUN apk --no-cache add bash="${BASH_VERSION}" git="${GIT_VERSION}" github-cli="${GITHUB_CLI_VERSION}"

COPY init.sh /init.sh

CMD [ "/usr/bin/git", "--help" ]

### Runtime information and not relevant at build time

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
