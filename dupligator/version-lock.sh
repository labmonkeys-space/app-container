#!/usr/bin/env bash
set -u -o pipefail

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
export BASE_IMAGE="quay.io/labmonkeys/alpine:3.17.0-20221221.b257"
export GIT_COMMIT="6721d9941eb2674aef14249e2fc6dcecbfe46163"
