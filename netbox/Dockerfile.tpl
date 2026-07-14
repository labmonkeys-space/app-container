# Copyright 2026 Ronny Trommer <ronny@no42.org>
# SPDX-License-Identifier: MIT
###
# Do not edit the generated Dockerfile
###

###
# Build stage: install our plugin (and its dependencies) from a pinned PyPI
# release into the NetBox virtualenv. Nothing from this stage besides the
# populated venv is kept.
###
# hadolint ignore=DL3006
FROM "${BASE_IMAGE}" AS build

RUN /usr/local/bin/uv pip install --no-cache --python /opt/netbox/venv/bin/python \
      "netbox-opennms-plugin==${PLUGIN_VERSION}"

###
# Runtime image: same NetBox base with the plugin-populated virtualenv copied in.
# The plugin is bundled but NOT activated; PLUGINS/PLUGINS_CONFIG are supplied by
# the deployment, keeping this image reusable and free of secrets.
###
# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

COPY --from=build --chown=999:0 /opt/netbox/venv /opt/netbox/venv

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
