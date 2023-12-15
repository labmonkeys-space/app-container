#!/usr/bin/env bash
set -u -o pipefail

source ../base_images.sh

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
export BASE_IMAGE="${LANG_JRE_17}"
export ACTIVEMQ_VERSION="6.0.1"
export SHA512_VAL="3955c57520b61275f9cc7e8437973ff98049e98f3527bf9ea8403d6526742ae15bf8be9780470506dcf9fd4db41d16054662f0a2e67e0f86f2f9c3b07c493f9d"
export ACTIVEMQ_HOME="/opt/activemq"
