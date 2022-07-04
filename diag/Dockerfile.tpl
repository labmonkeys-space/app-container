###
# Do not edit the generated Dockerfile
###

FROM "${BASE_IMAGE}"

ADD https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-darwin-amd64.zip /usr/bin/ngrok

RUN groupadd --gid 10001 diaguser && \
    adduser --uid 10001 --gid 10001 --home /home/diaguser diaguser --system

# hadolint ignore=DL3008
RUN apt-get update && apt-get -y install --no-install-recommends ca-certificates="${CA_CERT_VERSION}" \
    curl \
    htop \
    libcap2-bin \
    netcat \
    sysstat \
    tcpdump \
    tmate \
    tmux \
    tshark \
    unzip \
    vim \
    wget && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +rx /usr/bin/ngrok

USER 10001

CMD [ "/usr/bin/bash" ]

### Runtime information and not relevant at build time

LABEL org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
