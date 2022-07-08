###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "golang:1.18-alpine3.16" as builder

# hadolint ignore=DL3018, DL3003
RUN go install github.com/ipchama/dupligator@latest
RUN apk --no-cache add git && \
    git clone https://github.com/ipchama/dupligator.git /go/src/dupligator && \
    cd /go/src/dupligator && \
    git checkout 6721d9941eb2674aef14249e2fc6dcecbfe46163 && \
    go mod init && \
    go mod tidy && \
    go build -o bin/dupligator . && \
    mv bin/dupligator /usr/bin/dupligator

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

RUN addgroup dupligator && \
    adduser --system dupligator dupligator

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
