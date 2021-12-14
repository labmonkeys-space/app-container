#!/usr/bin/env bash
set -u -o pipefail

export VCS_SOURCE="$(git remote get-url --push origin)"
export VCS_REVISION="$(git describe --always)"
export BASE_IMAGE="antora/antora:3.0.0-rc.2"
export BASH_VERSION="5.1.4-r0"
export MAKE_VERSION="4.3-r0"
export GIT_VERSION="2.32.0-r0"
export OPENSSH_CLIENT_VERSION="8.6_p1-r3"
export ANTORA_XREF_VALIDATOR="v1.0.0-alpha.14"
export ANTORA_LUNR="0.8.0"
export ANTORA_SITE_GENERATOR="0.6.1"
