###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

RUN apt-get update && apt-get install -y --no-install-recommends \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg \
		iproute2 \
		iputils-ping && \
    curl -s https://packagecloud.io/install/repositories/fdio/release/script.deb.sh | bash && \
    apt-get install -y vpp="${VPP_VERSION}" \
                       vpp-plugin-core="${VPP_VERSION}" \
                       vpp-plugin-dpdk="${VPP_VERSION}" && \
 	rm -rf /var/lib/apt/lists/*

WORKDIR /vpp

RUN mkdir -p /var/log/vpp

CMD ["/usr/bin/vpp", "-c", "/etc/vpp/startup.conf"]

### Runtime information and not relevant at build time

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VPP_VERSION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"