#!/usr/bin/env bash
set -u -o pipefail

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
export BASE_IMAGE="quay.io/labmonkeys/alpine:3.16.3.b241"
export BASH_VERSION="5.1.16-r2"
export NETSNMP_VERSION="5.9.3-r0"
export LLDPD_VERSION="1.0.14-r1"
