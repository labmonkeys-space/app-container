###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE_BUILD}" as alpine

RUN apk add --no-cache bash="${BASH_VERSION}" shellcheck="${SHELLCHECK_VERSION}"

ENTRYPOINT [ "/bin/bash" ]

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
