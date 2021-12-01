#!/usr/bin/env bash
set -u -o pipefail

export VCS_SOURCE="$(git remote get-url --push origin)"
export VCS_REVISION="$(git describe --always)"
export BASE_IMAGE="quay.io/labmonkeys/alpine:3.15.0.b74"
export BASH_VERSION="5.1.8-r0"
export NETSNMP_VERSION="5.9.1-r5"
export LLDPD_VERSION="1.0.13-r0"
