#!/usr/bin/env bash
# Copyright 2022 Ronny Trommer <ronny@no42.org>
# SPDX-License-Identifier: MIT
set -u -o pipefail

source ../base_images.sh

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
# Pleroma 2.11 locks cowlib 2.21, which uses Erlang's `maybe` expression and
# so needs OTP 27 to compile. LANG_ELIXIR in base_images.sh is still on OTP 26.
export BASE_IMAGE_BUILD="elixir:1.17.3-otp-27-alpine"
export BASE_IMAGE="alpine:3.24.4"
export PLEROMA_VERSION="v2.11.1"

# arm64 disabled: the Elixir/Erlang `mix release` hangs indefinitely under
# QEMU emulation on amd64 runners, exceeding the 6h CI ceiling.
export PLATFORMS="linux/amd64"
