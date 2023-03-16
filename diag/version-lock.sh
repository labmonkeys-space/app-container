#!/usr/bin/env bash
set -u -o pipefail

source ../base_images.sh

export VCS_SOURCE="$(git remote get-url --push origin)"
export VCS_REVISION="$(git describe --always)"
export BASE_IMAGE="${OS_UBUNTU_JAMMY}"
export CA_CERT_VERSION="20211016"
