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
    mkdir -p /opt/cerebro/logs && \
    tar xzf /opt/cerebro.tar.gz --strip-components=1 -C /opt/cerebro && \
    rm -rf /opt/cerebro.tar.gz && \
    apt-get autoremove && apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    addgroup -gid 1000 cerebro && \
    adduser -q --system --no-create-home --disabled-login -gid 1000 -uid 1000 cerebro && \
    chown -R root:root /opt/cerebro && \
    chown -R cerebro:cerebro /opt/cerebro/logs && \
    chown cerebro:cerebro /opt/cerebro && \
    sed -i '/<appender-ref ref="FILE"\/>/d' /opt/cerebro/conf/logback.xml

WORKDIR /opt/cerebro

USER cerebro

ENTRYPOINT [ "/opt/cerebro/bin/cerebro" ]

LABEL org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"

