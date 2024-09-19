###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE_BUILD}" as build

ENV MIX_ENV=prod
ENV VIX_COMPILATION_MODE=PLATFORM_PROVIDED_LIBVIPS

RUN apk add --no-cache git gcc g++ musl-dev make cmake file-dev vips-dev && \
    git clone -b develop https://git.pleroma.social/pleroma/pleroma.git /usr/src/pleroma

WORKDIR /usr/src/pleroma

RUN git checkout ${PLEROMA_VERSION}

RUN echo "import Mix.Config" > config/prod.secret.exs && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get --only prod && \
    mkdir /release && \
    mix release --path /release

###
# Runtime image
###
FROM "${BASE_IMAGE}"

RUN apk add --no-cache exiftool ffmpeg vips libmagic ncurses postgresql-client && \
    addgroup -g 911 pleroma && \
    adduser -h /pleroma -s /bin/false -D -G pleroma -u 911 pleroma && \
    mkdir -p /etc/pleroma && \
    chown -R pleroma /etc/pleroma && \
    mkdir -p /var/lib/pleroma/uploads && \
    mkdir -p /var/lib/pleroma/static && \
    chown -R pleroma /var/lib/pleroma

COPY --from=build --chown=pleroma:0 /release /pleroma
COPY --from=build --chown=pleroma:0 /usr/src/pleroma/config/docker.exs /etc/pleroma/config.exs
COPY --from=build --chown=pleroma:0 /usr/src/pleroma/docker-entrypoint.sh /pleroma

WORKDIR /pleroma

USER pleroma

ENTRYPOINT ["/pleroma/docker-entrypoint.sh"]

EXPOSE 4000

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
