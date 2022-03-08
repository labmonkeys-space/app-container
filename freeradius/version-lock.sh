#!/usr/bin/env bash
set -u -o pipefail

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
export BASE_IMAGE="quay.io/labmonkeys/alpine:3.15.0.b74"
export FREERADIUS_VERSION="3.0.25-r1"
export SQLITE_VERSION="3.36.0-r0"
export OPENSSL_VERSION="1.1.1l-r8"
