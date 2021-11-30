#!/usr/bin/env bash
set -u -o pipefail

export VCS_SOURCE="$(git remote get-url --push origin)"
export VCS_REVISION="$(git describe --always)"
export BASE_IMAGE="antora/antora:2.3.4"
export BASH_VERSION="5.0.11-r1"
export MAKE_VERSION="4.2.1-r2"
export GIT_VERSION="2.24.4-r0"
export OPENSSH_CLIENT_VERSION="8.1_p1-r1"
