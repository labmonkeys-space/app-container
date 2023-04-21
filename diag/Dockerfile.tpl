###
# Do not edit the generated Dockerfile
###

FROM "${BASE_IMAGE}"

ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini-amd64 /bin/tini
ADD https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz /tmp/ngrok.tgz
ADD https://github.com/labmonkeys-space/g-userping/releases/download/v0.1.0/g-userping_0.1.0_linux_amd64.tar.gz /tmp/g-userping.tar.gz

RUN groupadd --gid 10001 diaguser && \
    adduser --uid 10001 --gid 10001 --home /home/diaguser diaguser --system && \
    tar xzf /tmp/g-userping.tar.gz -C /usr/bin && \
    tar xzf /tmp/ngrok.tgz -C /usr/bin

ENV DEBIAN_FRONTEND=noninteractive

# hadolint ignore=DL3008
RUN apt-get update && apt-get -y install --no-install-recommends ca-certificates="${CA_CERT_VERSION}" \
    attr \
    curl \
    dnsutils \
    dnscap \
    dnstop \
    fprobe \
    htop \
    iftop \
    iperf3 \
    iproute2 \
    iptotal \
    iptraf-ng \
    iputils-ping \
    jnettop \
    libcap2-bin \
    mtr \
    mz \
    netcat \
    netdiag \
    netr \
    nfswatch \
    ngrep \
    nicstat \
    pmacct \
    sudo \
    sysstat \
    tcpdump \
    tcpxtract \
    tmate \
    tmux \
    tshark \
    unzip \
    vim \
    wget && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +rx /usr/bin/ngrok /bin/tini && \
    echo "diaguser ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/diaguser && \
    echo "${DEBIAN_FRONTEND}"

CMD ["/bin/tini", "--", "usr/bin/bash"]

USER 10001

### Runtime information and not relevant at build time

LABEL org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
