#!/usr/bin/env bash
set -u -o pipefail

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
export BASE_IMAGE_BUILD="elixir:1.11.4-alpine"
export BASE_IMAGE="quay.io/labmonkeys/alpine:3.16.3-20230131.b258"
export PLEROMA_VERSION="v2.5.0"
