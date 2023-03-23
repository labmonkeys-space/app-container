###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

# hadolint ignore=DL3018, DL3003
RUN apk add --no-cache git && \
    git clone https://github.com/toptal/haste-server.git /app && \
    cd /app && \
    git checkout ${GIT_COMMIT} && \
    chown -R node:node /app && \
    rm -rf /app/.git

USER node

WORKDIR /app

RUN npm install && \
    npm install redis@0.8.1 && \
    npm install pg@4.5.7 && \
    npm install memcached@2.2.2 && \
    npm install aws-sdk@2.814.0 && \
    npm install rethinkdbdash@2.3.31

STOPSIGNAL SIGINT

ENTRYPOINT [ "bash", "docker-entrypoint.sh" ]

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s \
    --retries=3 CMD [ "sh", "-c", "echo -n 'curl localhost:7777... '; \
    (\
        curl -sf localhost:7777 > /dev/null\
    ) && echo OK || (\
        echo Fail && exit 2\
    )"]

CMD ["npm", "start"]

### Runtime information and not relevant at build time

EXPOSE 7777

ENV STORAGE_TYPE=memcached \
    STORAGE_HOST=127.0.0.1 \
    STORAGE_PORT=11211 \
    STORAGE_EXPIRE_SECONDS=2592000 \
    STORAGE_DB=2 \
    STORAGE_AWS_BUCKET= \
    STORAGE_AWS_REGION= \
    STORAGE_USENAME= \
    STORAGE_PASSWORD= \
    STORAGE_FILEPATH=

ENV LOGGING_LEVEL=verbose \
    LOGGING_TYPE=Console \
    LOGGING_COLORIZE=true

ENV HOST=0.0.0.0 \
    PORT=7777 \
    KEY_LENGTH=10 \
    MAX_LENGTH=400000 \
    STATIC_MAX_AGE=86400 \
    RECOMPRESS_STATIC_ASSETS=true

ENV KEYGENERATOR_TYPE=phonetic \
    KEYGENERATOR_KEYSPACE=

ENV RATELIMITS_NORMAL_TOTAL_REQUESTS=500 \
    RATELIMITS_NORMAL_EVERY_MILLISECONDS=60000 \
    RATELIMITS_WHITELIST_TOTAL_REQUESTS= \
    RATELIMITS_WHITELIST_EVERY_MILLISECONDS=  \
    # comma separated list for the whitelisted \
    RATELIMITS_WHITELIST=example1.whitelist,example2.whitelist \
    \
    RATELIMITS_BLACKLIST_TOTAL_REQUESTS= \
    RATELIMITS_BLACKLIST_EVERY_MILLISECONDS= \
    # comma separated list for the blacklisted \
    RATELIMITS_BLACKLIST=example1.blacklist,example2.blacklist
ENV DOCUMENTS=about=./about.md

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.description="Hastebin Server v1" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT" \
      io.artifacthub.package.readme-url="https://github.com/labmonkeys-space/app-container/blob/main/dupligator/README.md"
