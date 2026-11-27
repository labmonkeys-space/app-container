#!/usr/bin/env bash
# Copyright 2026 Ronny Trommer <ronny@no42.org>
# SPDX-License-Identifier: MIT
set -u -o pipefail

source ../base_images.sh

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
# Debian stable (trixie). OS_DEBIAN in base_images.sh is still on bookworm.
export BASE_IMAGE="debian:trixie-20261123-slim"
# Release and SHA-256 of asterisk-<version>.tar.gz on its GitHub release page.
# Change both together. The build stops when they do not match.
export ASTERISK_VERSION="24.0.0"
export ASTERISK_SHA256="ece42a75bc965180007c56b03f2fd1dc8484eb84fc4cddc090db0ee5d5da1af9"

# arm64 not enabled: Asterisk and pjproject would compile under QEMU emulation
# on the amd64 runners. Not tried yet.
export PLATFORMS="linux/amd64"
