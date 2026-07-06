#!/usr/bin/env bash
set -u -o pipefail

source ../base_images.sh

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
# The current Robot Framework test stack (requests, urllib3, pytest, robotframework,
# cryptography, grpcio, ...) only ships wheels for Python >=3.10, so override the shared
# LANG_PYTHON_3_ALPINE 3.9 pin (still used by sunshine) with a newer interpreter here.
export BASE_IMAGE="python:3.14.1-alpine3.21"
export GIT_COMMIT="17d482f2cba1a8735df0a9278ae6e68c500537c1"
