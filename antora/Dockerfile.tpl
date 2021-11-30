###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

RUN apk --no-cache add bash="${BASH_VERSION}" \
                       make="${MAKE_VERSION}" \
                       git="${GIT_VERSION}" \
                       openssh-client="${OPENSSH_CLIENT_VERSION}" && \
    npm i -g gitlab:antora/xref-validator && \
    npm i -g antora-lunr

LABEL org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
