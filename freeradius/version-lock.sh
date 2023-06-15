#!/usr/bin/env bash
set -u -o pipefail

source ../base_images.sh

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
export BASE_IMAGE="${OS_ALPINE}"
export FREERADIUS_VERSION="3.0.26-r2"
export SQLITE_VERSION="3.41.2-r2"
export OPENSSL_VERSION="3.1.1-r1"
