###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
      curl \
      diffutils \
      jq \
      libwww-perl \
      libxml-twig-perl \
      rsync && \
    apt-get -y install --no-install-recommends \
      rrdtool="${RRDTOOL_VERSION}" \
      r-recommended="${R_VERSION}" && \
    curl -1sLf 'https://packages.opennms.com/public/common/setup.deb.sh' | bash && \
    apt-get -y install --no-install-recommends \
      jicmp \
      jicmp6 \
      jrrd2 && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L -o /tmp/onms-horizon.tar.gz "https://github.com/OpenNMS/opennms/releases/download/opennms-${ONMS_HZN_VERSION}-1/opennms-${ONMS_HZN_VERSION}.tar.gz" && \
    curl -L -o /usr/bin/confd "https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64" && \
    chmod +x /usr/bin/confd && \
    groupadd --gid 10001 opennms && \
    adduser --uid 10001 --gid 10001 --home /opt/opennms --system opennms && \
    tar xzf /tmp/onms-horizon.tar.gz -C /opt/opennms && \
    chown 10001:10001 /opt/opennms -R && \
    rm -rf /tmp/*

WORKDIR /opt/opennms

USER 10001

### Runtime information and not relevant at build time

LABEL org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
