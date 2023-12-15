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
export GOHUGO_VERSION="0.119.0"
export RUBY_VERSION="3.2.2-r0"
export ASCIIDOCTOR_VERSION="2.0.20"
export NPM_VERSION="10.2.5-r0"

