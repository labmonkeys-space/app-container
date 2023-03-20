###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends curl && \
    mkdir ${ACTIVEMQ_HOME} && \
    curl -L "http://www.apache.org/dyn/closer.cgi?filename=/activemq/${ACTIVEMQ_VERSION}/apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz&action=download" -o ${ACTIVEMQ_HOME}/activemq-bin.tar.gz && \
    rm -rf /var/lib/apt/lists/*

WORKDIR "${ACTIVEMQ_HOME}"

RUN echo "${SHA512_VAL} *activemq-bin.tar.gz" > activemq-bin.tar.gz.sha512 && \
    sha512sum -c activemq-bin.tar.gz.sha512 && \
    tar xzf activemq-bin.tar.gz --strip-components 1 && \
    useradd -r -M -d ${ACTIVEMQ_HOME} activemq && \
    chown -R activemq:activemq ${ACTIVEMQ_HOME} && \
    chown -h activemq:activemq ${ACTIVEMQ_HOME} && \
    rm activemq-bin.tar.gz activemq-bin.tar.gz.sha512

USER activemq

ENTRYPOINT [ "bin/activemq" ]

CMD [ "console" ]

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT" \
      io.artifacthub.package.readme-url="https://github.com/labmonkeys-space/app-container/blob/main/antora/README.md"

# MQTT:         1883/tcp
# AMQP:         5672/tcp
# UI:           8161/tcp
# STOMP:        61613/tcp
# WS:           61614/tcp
# ActiveMQ TCP: 61616/tcp
EXPOSE 1883/tcp 5672/tcp 8161/tcp  61613/tcp 61614/tcp 61616/tcp
