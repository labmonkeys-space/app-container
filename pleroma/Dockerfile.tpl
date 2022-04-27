###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

ENV MIX_ENV=prod

RUN apk add --no-cache git gcc g++ musl-dev make cmake file-dev \
            exiftool imagemagick libmagic ncurses postgresql-client ffmpeg

RUN addgroup -g 911 pleroma && \
    adduser -h /pleroma -s /bin/false -D -G pleroma -u 911 pleroma

RUN mkdir -p /etc/pleroma && \
    chown -R pleroma /etc/pleroma && \
    mkdir -p /var/lib/pleroma/uploads && \
    mkdir -p /var/lib/pleroma/static && \
    chown -R pleroma /var/lib/pleroma

USER pleroma
WORKDIR /pleroma

RUN git clone -b develop https://git.pleroma.social/pleroma/pleroma.git /pleroma  && \
    git checkout ${PLEROMA_VERSION}

RUN echo "import Mix.Config" > config/prod.secret.exs && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get --only prod && \
    mkdir release && \
    mix release --path /pleroma

COPY ./container-fs/config.exs /etc/pleroma/config.exs

EXPOSE 4000

ENTRYPOINT ["/pleroma/docker-entrypoint.sh"]

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
