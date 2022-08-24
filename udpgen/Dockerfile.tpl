###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}" as builder

WORKDIR /root

# Change default shell for RUN from Dash to Bash
SHELL ["/bin/bash", "-exo", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get -y install --no-install-recommends ca-certificates \
                                               git \
                                               libsnmp-dev \
                                               make \
                                               cmake \
                                               g++ && \
    git clone https://github.com/OpenNMS/udpgen.git && \
    mkdir udpgen/build

WORKDIR /root/udpgen

RUN git checkout -b build ${GIT_COMMIT}

WORKDIR /root/udpgen/build

RUN cmake .. && \
    make

######
FROM "${BASE_IMAGE}"

# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get -y install --no-install-recommends libsnmp-dev && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /root/udpgen/build/udpgen /usr/bin

ENTRYPOINT [ "/usr/bin/udpgen" ]

CMD [ "--help" ]

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.description="UDP generation tool for Syslog, SNMP Traps and NetFlow v5/v9 traffic" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT" \
      io.artifacthub.package.readme-url="https://github.com/OpenNMS/udpgen/blob/master/README.md"
