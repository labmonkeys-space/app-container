###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

RUN apt update && apt -y install --no-install-recommends git-core tini && \
    git clone https://github.com/ZeitOnline/jira_exporter.git && \
    cd jira_exporter && git checkout ${GIT_COMMIT} && \
    pip install --no-deps -r requirements.txt && \
    rm -rf /var/lib/apt/lists

ENTRYPOINT ["/usr/local/bin/jira_exporter"]

CMD ["--help"]

### Runtime information and not relevant at build time

EXPOSE 9653/tcp

LABEL org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
