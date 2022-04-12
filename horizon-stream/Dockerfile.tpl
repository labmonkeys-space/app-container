###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BUILD_BASE_IMAGE}" as builder

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /usr/src

# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    git && \
    git clone https://github.com/OpenNMS/horizon-stream.git

WORKDIR /usr/src/horizon-stream

RUN git checkout "${GIT_COMMIT}" && \
    mvn install -f platform && \
    cp ./platform/assemblies/core-dynamic-dist/target/core-dynamic-dist-*.tar.gz /tmp/core-dynamic-distcore-dynamic-dist.tar.gz

###
# Building runtime image
###
# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

COPY --from=builder /tmp/core-dynamic-distcore-dynamic-dist.tar.gz /tmp

RUN apt-get update && apt-get install -y --no-install-recommends tini && \
    mkdir -p /opt/hzn-stream && \
    groupadd --gid 10001 hzn-stream && \
    useradd --system --uid 10001 --gid hzn-stream hzn-stream --home-dir /opt/hzn-stream && \
    tar xzf /tmp/core-dynamic-distcore-dynamic-dist.tar.gz --strip-components=1 -C /opt/hzn-stream && \
    chown 10001 /opt/hzn-stream -R && \
    chgrp -R 0 /opt/hzn-stream && \
    chmod -R g=u /opt/hzn-stream && \
    rm -rf /tmp/*.tar.gz && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/hzn-stream

USER 10001

# Tini kills the child process group , so that every process in the group gets the signal.
# This corresponds more closely to what happens when you do ctrl-C etc.
# In a terminal: The signal is sent to the foreground process group.
ENTRYPOINT ["/usr/bin/tini", "-g" ,"--"]

CMD ["/opt/hzn-stream/bin/karaf", "run"]

EXPOSE 8101 1099 44444 8181 9999


LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.title="Horizon Stream Platform commit ${GIT_COMMIT}" \
      org.opencontainers.image.base.name="${BASE_IMAGE}"
