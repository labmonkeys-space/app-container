#!/usr/bin/env bash
set -u -o pipefail

source ../base_images.sh

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
export BASE_IMAGE="quay.io/labmonkeys/frrouting:9.1"
export NETSNMP_VERSION="5.9.3-r3"
export LLDPD_VERSION="1.0.16-r1"
export S6_OVERLAY_VERSION="3.1.5.0-r0"
