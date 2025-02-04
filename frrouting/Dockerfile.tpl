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
    ###
    ## TODO: This is the build environment for ipfixprobe
    #
    apt-get -y install git build-essential autoconf libtool libpcap-dev pkg-config libxml2-dev libunwind-dev libssl-dev libfuse3-dev fuse3 cmake liblz4-dev rpm && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/frr && \
    mkdir -p /etc/snmp/conf.d && \
    chown -R frr:frr /etc/frr /var/run/frr

RUN git clone --depth 1 https://github.com/CESNET/nemea-framework /tmp/nemea-framework

WORKDIR /tmp/nemea-framework

RUN ./bootstrap.sh &&./configure --bindir=/usr/bin/nemea/ -q && \
    make -j10 && \
    make install

RUN git clone --depth 1 https://github.com/CESNET/nemea-modules /tmp/nemea-modules

WORKDIR /tmp/nemea-modules

RUN ./bootstrap.sh && \
     ./configure --bindir=/usr/bin/nemea/ -q && \
     make -j10 && \
     make install

RUN git clone -b release --depth 1 https://github.com/CESNET/telemetry /tmp/telemetry

WORKDIR /tmp/telemetry

RUN mkdir build

WORKDIR  build

RUN cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make -j10 && \
    make install

RUN git clone --recurse-submodules https://github.com/CESNET/ipfixprobe.git /tmp/ipfixprobe

WORKDIR /tmp/ipfixprobe

RUN autoreconf -i && \
    ./configure --with-raw --with-pcap --with-nemea --with-gtest && \
    make && \
    make install

# Using s6 to run lldpd and snmpd in the container
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp

RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

# Add a basic configuration for lldpd, snmpd and pmacctd to the container
COPY config/s6/services /etc/services.d
COPY config/lldpd.conf /etc/lldpd.d
COPY config/snmpd.conf /etc/snmp/

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
