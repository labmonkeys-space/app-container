###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "golang:1.15-buster" as builder

ENV GOPATH=/opt/go

# hadolint ignore=DL3018, DL3003
RUN go get -u github.com/ipchama/dupligator
RUN cd /opt/go/src/github.com/ipchama/dupligator && \
    git checkout ${GIT_COMMIT} && \
    go build -o bin/dupligator . && \
    mv bin/dupligator /usr/bin/dupligator

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

RUN adduser --system dupligator

COPY --chown=dupligator --from=builder /usr/bin/dupligator /usr/bin/dupligator

USER dupligator

ENTRYPOINT [ "/usr/bin/dupligator" ]

CMD [ "-v" ]

### Runtime information and not relevant at build time

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.description="DupliGator is a UDP packet replicator inspired by Samplicator" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT" \
      io.artifacthub.package.readme-url="https://github.com/labmonkeys-space/app-container/blob/main/dupligator/README.md"
