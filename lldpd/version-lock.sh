#!/usr/bin/env bash
set -u -o pipefail

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
export BASE_IMAGE="quay.io/labmonkeys/alpine:3.16.0.b182"
export BASH_VERSION="5.1.16-r2"
export NETSNMP_VERSION="5.9.1-r6"
export LLDPD_VERSION="1.0.14-r1"
