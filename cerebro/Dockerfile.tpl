###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN apt-get update && apt-get --no-install-recommends -y install curl && \
    curl -L https://github.com/lmenezes/cerebro/releases/download/v${CEREBRO_VERSION}/cerebro-${CEREBRO_VERSION}.tgz -o /opt/cerebro.tar.gz && \
    mkdir -p "${CEREBRO_HOME}/logs" "${CEREBRO_HOME}/data" && \
    tar xzf /opt/cerebro.tar.gz --strip-components=1 -C "${CEREBRO_HOME}" && \
    sed -i '/<appender-ref ref="FILE"\/>/d' ${CEREBRO_HOME}/conf/logback.xml && \
    sed -i 's/\.\/cerebro.db/\/opt\/cerebro\/data\/cerebro\.db/g' ${CEREBRO_HOME}/conf/application.conf && \
    addgroup -gid 1000 cerebro && \
    adduser -q --system --no-create-home --disabled-login -gid 1000 -uid 1000 cerebro && \
    chown cerebro:cerebro ${CEREBRO_HOME} && \
    chown -R cerebro:cerebro ${CEREBRO_HOME}/conf \
                             ${CEREBRO_HOME}/logs \
                             ${CEREBRO_HOME}/data && \
    rm -rf /opt/cerebro.tar.gz && \
    apt-get autoremove && apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR ${CEREBRO_HOME}

USER cerebro

ENTRYPOINT [ "${CEREBRO_HOME}/bin/cerebro" ]

# Expose web UI on port 9000 by default
EXPOSE 9000/tcp

# Persistence for configs and database
VOLUME [ "${CEREBRO_HOME}/data", "${CEREBRO_HOME}/conf" ]

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.description="Cerebro - A web admin tool to manage ElasticSearch" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT" \
      io.artifacthub.package.readme-url="https://github.com/labmonkeys-space/app-container/blob/main/cerebro/README.md" \
      io.artifacthub.package.maintainers="[{"name":"Ronny Trommer","email":"ronny@no42.org"}]"
