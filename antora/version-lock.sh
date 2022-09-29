#!/usr/bin/env bash
set -u -o pipefail

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
export BASE_IMAGE="antora/antora:3.1.1"
export BASH_VERSION="5.1.16-r2"
export MAKE_VERSION="4.3-r0"
export GIT_VERSION="2.36.2-r0"
export OPENSSH_CLIENT_VERSION="9.0_p1-r2"
export ANTORA_XREF_VALIDATOR="v1.0.0-alpha.14"
export LUNR_EXTENSION_VERSION="1.0.0-alpha.8"
