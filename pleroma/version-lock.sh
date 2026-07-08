#!/usr/bin/env bash
set -u -o pipefail

source ../base_images.sh

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
export BASE_IMAGE_BUILD="${LANG_ELIXIR}"
export BASE_IMAGE="alpine:3.20.9"
export PLEROMA_VERSION="v2.10.2"

# arm64 disabled: the Elixir/Erlang `mix release` hangs indefinitely under
# QEMU emulation on amd64 runners, exceeding the 6h CI ceiling.
export PLATFORMS="linux/amd64"
