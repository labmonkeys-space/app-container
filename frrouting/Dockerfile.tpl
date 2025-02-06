###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

RUN apt-get update && \
    apt-get -y install curl \
                       dnsutils \
                       gnupg2 \
                       iftop \
                       inetutils-ping \
                       iperf3 \
                       iptraf-ng \
                       lldpd \
                       lsb-release \
                       mtr-tiny \
                       pmacct \
                       procps \
                       snmpd \
                       tcptraceroute \
                       traceroute \
                       xz-utils \
                       && \
    curl -s https://deb.frrouting.org/frr/keys.asc | apt-key add - && \
    echo deb https://deb.frrouting.org/frr $(lsb_release -s -c) frr-stable | tee -a /etc/apt/sources.list.d/frr.list && \
    apt-get update && \
    apt-get -y install frr-snmp="${FRR_VERSION}" && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/frr && \
    mkdir -p /etc/snmp/conf.d && \
    chown -R frr:frr /etc/frr /var/run/frr

# Using s6 to run lldpd and snmpd in the container
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp

RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

# Add a basic configuration for lldpd, snmpd and pmacctd to the container
COPY config/s6/services /etc/services.d
COPY config/lldpd.conf /etc/lldpd.d
COPY config/snmpd.conf /etc/snmp/
COPY config/pmacctd.conf /etc/pmacct/pmacctd.conf
COPY config/interfaces.map /etc/pmacct/interfaces.map

# Simple init manager for reaping processes and forwarding signals
ENTRYPOINT ["/init"]

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
