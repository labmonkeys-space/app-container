###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

ARG TARGETARCH

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
    apt-get -y install frr-snmp && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/frr && \
    mkdir -p /etc/snmp/conf.d && \
    chown -R frr:frr /etc/frr /var/run/frr

# Using s6 to run lldpd and snmpd in the container. The arch tarball is named
# x86_64 / aarch64, mapped from TARGETARCH; noarch is architecture-independent.
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp

RUN case "$TARGETARCH" in \
      amd64) S6ARCH=x86_64 ;; \
      arm64) S6ARCH=aarch64 ;; \
      *) echo "unsupported TARGETARCH=$TARGETARCH" >&2; exit 1 ;; \
    esac && \
    curl -fsSLo /tmp/s6-overlay-arch.tar.xz "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6ARCH}.tar.xz" && \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-arch.tar.xz

# Add a basic configuration for lldpd, snmpd and pmacctd to the container
COPY config/s6/services /etc/services.d
COPY config/lldpd.conf /etc/lldpd.d
COPY config/snmpd.conf /etc/snmp/
COPY config/pmacctd.conf /etc/pmacct/pmacctd.conf

# Simple init manager for reaping processes and forwarding signals
ENTRYPOINT ["/init"]

# Default CMD starts watchfrr
COPY docker-start /usr/lib/frr/docker-start
CMD ["/usr/lib/frr/docker-start"]

### Runtime information and not relevant at build time
ENV INTERFACES=eth0

EXPOSE 161/udp

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
