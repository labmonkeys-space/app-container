###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

RUN apt-get update && \
    apt-get -y install curl \
                       gnupg2 \
                       lsb-release \
                       tini \
                       lldpd \
                       snmpd && \
    curl -s https://deb.frrouting.org/frr/keys.asc | apt-key add - && \
    echo deb https://deb.frrouting.org/frr $(lsb_release -s -c) frr-stable | tee -a /etc/apt/sources.list.d/frr.list && \
    apt-get update && \
    apt-get -y install frr-snmp && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/frr && \
    mkdir -p /etc/snmp/conf.d && \
    chown -R frr:frr /etc/frr /var/run/frr

COPY config/lldpd.conf /etc/lldpd.d
COPY config/snmpd.conf /etc/snmp/

# Simple init manager for reaping processes and forwarding signals
ENTRYPOINT ["/usr/bin/tini", "--"]

# Default CMD starts watchfrr
COPY docker-start /usr/lib/frr/docker-start
CMD ["/usr/lib/frr/docker-start"]

### Runtime information and not relevant at build time

EXPOSE 161/udp

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
