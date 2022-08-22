#!/usr/bin/env bash
set -u -o pipefail

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
export BASE_IMAGE="quay.io/labmonkeys/alpine:3.16.2.b205"
export FREERADIUS_VERSION="3.0.25-r2"
export SQLITE_VERSION="3.38.5-r0"
export OPENSSL_VERSION="1.1.1q-r0"
