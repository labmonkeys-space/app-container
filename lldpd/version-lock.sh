#!/usr/bin/env bash
set -u -o pipefail

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
export BASE_IMAGE="quay.io/labmonkeys/alpine:3.17.1-20230131.b265"
export BASH_VERSION="5.2.15-r0"
export NETSNMP_VERSION="5.9.3-r1"
export LLDPD_VERSION="1.0.16-r0"
