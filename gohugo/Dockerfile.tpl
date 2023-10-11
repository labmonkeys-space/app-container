###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

ADD "https://github.com/gohugoio/hugo/releases/download/v${GOHUGO_VERSION}/hugo_${GOHUGO_VERSION}_linux-amd64.tar.gz" /tmp/gohugo.tar.gz

RUN tar xzf /tmp/gohugo.tar.gz -C /usr/bin && \
    rm -rf /tmp/gohugo.tar.gz && \
    apk add --no-cache ruby=${RUBY_VERSION} bash npm=${NPM_VERSION} git && \
    gem install asciidoctor -v ${ASCIIDOCTOR_VERSION}

ENTRYPOINT [ "/usr/bin/hugo" ]

CMD [ "--help" ]

### Runtime information and not relevant at build time

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
