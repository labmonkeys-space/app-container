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
export BASH_VERSION="5.2.26-r0"
export GIT_VERSION="2.45.2-r0"
export GITHUB_CLI_VERSION="2.47.0-r4"
