###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

RUN apk --no-cache add net-snmp="${NETSNMP_VERSION}" lldpd="${LLDPD_VERSION}" s6-overlay="${S6_OVERLAY_VERSION}" && \
    mkdir -p /etc/snmp/conf.d

COPY config/snmpd.conf /etc/snmp/snmpd.conf
COPY config/lldpd.conf /etc/lldpd.conf
COPY config/s6/services /etc/services.d

USER root

ENTRYPOINT [ "/init" ]

CMD [ "/usr/lib/frr/docker-start" ]

### Runtime information and not relevant at build time

EXPOSE 161/udp

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
