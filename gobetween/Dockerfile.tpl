###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

ADD "https://github.com/yyyar/gobetween/releases/download/${GOBETWEEN_VERSION}/gobetween_${GOBETWEEN_VERSION}_linux_amd64.tar.gz" /tmp/gobetween.tar.gz

RUN mkdir /etc/gobetween && \
    tar xzf /tmp/gobetween.tar.gz -C /tmp && \
    mv /tmp/gobetween /usr/bin && \
    mv /tmp/config/* /etc/gobetween && \
    rm -rf /tmp/* && \
    adduser -S gobetween

USER gobetween

ENTRYPOINT [ "/usr/bin/gobetween" ]

CMD [ "--help" ]

### Runtime information and not relevant at build time

LABEL org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
