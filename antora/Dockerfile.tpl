###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

RUN apk --no-cache add bash="${BASH_VERSION}" \
                       make="${MAKE_VERSION}" \
                       git="${GIT_VERSION}" \
                       openssh-client="${OPENSSH_CLIENT_VERSION}" && \
    yarn global add --ignore-optional --silent "@antora/lunr-extension@${LUNR_EXTENSION_VERSION}"

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT" \
      io.artifacthub.package.readme-url="https://github.com/labmonkeys-space/app-container/blob/main/antora/README.md"
