###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

# Karaf environment variables
ENV KARAF_HOME="${KARAF_HOME}"

ADD https://dlcdn.apache.org/karaf/${KARAF_VERSION}/apache-karaf-${KARAF_VERSION}.tar.gz /tmp/karaf.tar.gz

RUN mkdir -p "${KARAF_HOME}" && \
    tar xzf /tmp/karaf.tar.gz --strip-components=1 -C /opt/karaf && \
    sed -i "21s/out/stdout/" /opt/karaf/etc/org.ops4j.pax.logging.cfg && \
    rm -rf /tmp/* && \
    groupadd --gid 10001 karaf && \
    useradd --system --uid 10001 --gid karaf karaf --home-dir ${KARAF_HOME} && \
    chown 10001 /opt/karaf -R && \
    chgrp -R 0 /opt/karaf && \
    chmod -R g=u /opt/karaf

WORKDIR /opt/karaf

USER 10001

ENTRYPOINT ["/opt/karaf/bin/karaf"]

CMD ["run"]

EXPOSE 8101 1099 44444 8181 9999

LABEL org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
