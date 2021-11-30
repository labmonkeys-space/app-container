###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

RUN apk --no-cache add net-snmp="${NETSNMP_VERSION}" && \
    mkdir -p /etc/snmp/conf.d && \
    adduser -S snmp && \
    chown -R snmp:root /etc/snmp /var/lib/net-snmp

COPY --chown=snmp:root config/snmpd.conf /etc/snmp/snmpd.conf
COPY --chown=snmp:root config/conf.d/* /etc/snmp/conf.d/

USER snmp

ENTRYPOINT [ "/usr/sbin/snmpd" ]

CMD [ "-f", "-Le", "-LS0-6d", "-c", "/etc/snmp/snmpd.conf" ]

### Runtime information and not relevant at build time

EXPOSE 161/udp

LABEL org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
