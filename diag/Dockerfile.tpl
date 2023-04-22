###
# Do not edit the generated Dockerfile
###

FROM "${BASE_IMAGE}"

ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini-amd64 /bin/tini
ADD https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz /tmp/ngrok.tgz
ADD https://github.com/labmonkeys-space/g-userping/releases/download/v0.1.0/g-userping_0.1.0_linux_amd64.tar.gz /tmp/g-userping.tar.gz

ENV DEBIAN_FRONTEND=noninteractive

# hadolint ignore=DL3008
RUN apt-get update && apt-get -y install --no-install-recommends ca-certificates="${CA_CERT_VERSION}" \
    attr \
    curl \
    dnsutils \
    dnscap \
    dnstop \
    fprobe \
    git \
    htop \
    iftop \
    iperf3 \
    iproute2 \
    iptotal \
    iptraf-ng \
    iputils-ping \
    jnettop \
    jq \
    libcap2-bin \
    ltrace \
    mtr \
    mz \
    netcat \
    netdiag \
    netr \
    nfswatch \
    ngrep \
    nicstat \
    nmap \
    pmacct \
    scapy \
    socat \
    speedtest-cli \
    strace \
    sudo \
    sysstat \
    tcpdump \
    tcptraceroute \
    tcpxtract \
    tmate \
    tmux \
    tshark \
    unzip \
    vim \
    wget \
    zsh && \
    rm -rf /var/lib/apt/lists/* && \
    echo "${DEBIAN_FRONTEND}" && \
    tar xzf /tmp/g-userping.tar.gz -C /usr/bin && \
    tar xzf /tmp/ngrok.tgz -C /usr/bin && \
    chmod +rx /usr/bin/ngrok /bin/tini && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    chsh -s $(which zsh)

RUN groupadd --gid 10001 diaguser && \
    adduser --uid 10001 --gid 10001 --home /home/diaguser diaguser --system && \
    echo "diaguser ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/diaguser

USER 10001

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    git clone https://github.com/zsh-users/zsh-autosuggestions /home/diaguser/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/diaguser/.oh-my-zsh/custom/themes/powerlevel10k

WORKDIR /home/diaguser

COPY --chown="10001:10001" container-fs/zshrc .zshrc
COPY --chown="10001:10001" container-fs/motd motd

CMD ["/bin/tini", "--", "/usr/bin/zsh"]

### Runtime information and not relevant at build time

LABEL org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
