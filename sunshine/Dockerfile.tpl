###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

RUN apk add --no-cache git && \
    git clone https://github.com/CycloneDX/Sunshine.git /app && \
    cd /app && \
    git checkout "${GIT_COMMIT}" && \
    rm -rf .git

WORKDIR /app

ENTRYPOINT [ "/usr/local/bin/python3" ]

CMD  [ "-m", "http.server", "8000" ]

LABEL org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
