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
export ACTIVEMQ_VERSION="5.17.4"
export SHA512_VAL="1fbc83f5efdab9980690e938c101a3beea22d4af496c1f793b41dbbe086e341f159bb62740451221139d6e5968184bc82b55c27f46510811896c84ec12c0d595"
export ACTIVEMQ_HOME="/opt/activemq"
