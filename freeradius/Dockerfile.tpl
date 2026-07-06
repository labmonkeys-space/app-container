###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

RUN apk add --no-cache freeradius freeradius-sqlite freeradius-radclient freeradius-rest \
                   sqlite openssl-dev && \
                   chgrp radius /usr/sbin/radiusd && \
                   chmod g+rwx /usr/sbin/radiusd

ENTRYPOINT [ "/usr/sbin/radiusd" ]

CMD [ "--help" ]

### Runtime information and not relevant at build time

EXPOSE 1812/udp 18120/tcp 1813/udp

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.description="Fast, feature-rich, modular, and scalable." \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
