#!/usr/bin/env bash
# Copyright 2026 Ronny Trommer <ronny@no42.org>
# SPDX-License-Identifier: MIT
set -u -o pipefail

source ../base_images.sh

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE

# NetBox runtime image. Pinned to a concrete upstream release (never :latest);
# tracked by Renovate via a customManager in ../renovate.json.
export BASE_IMAGE="netboxcommunity/netbox:v4.6.4"

# netbox-opennms-plugin, pinned to a Git tag (no PyPI release yet). Installed
# into the NetBox virtualenv at build time; tracked by Renovate (github-tags).
export PLUGIN_VERSION="v0.0.3"

export PLATFORMS="linux/amd64,linux/arm64"
