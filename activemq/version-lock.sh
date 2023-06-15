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
export ACTIVEMQ_VERSION="5.18.1"
export SHA512_VAL="2c28f88bcfdd5c9a25d4764f832a740d18b12bc9443f2f211f85df3734730d5da1a4596bf19fd9315e066bb4169ef482f95ad746018fe5551066cf2cf347b6ad"
export ACTIVEMQ_HOME="/opt/activemq"
