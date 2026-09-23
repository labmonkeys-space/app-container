#!/usr/bin/env bash
set -u -o pipefail

source ../base_images.sh

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
# fd.io publishes vpp packages only for Ubuntu noble and jammy, so vpp
# cannot follow OS_UBUNTU to 26.04 (resolute) yet. Renovate tracks this pin.
export BASE_IMAGE="ubuntu:noble-20260911"
export VPP_VERSION="24.10-release"

export PLATFORMS="linux/amd64,linux/arm64"
