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
export ACTIVEMQ_VERSION="6.1.3"
export SHA512_VAL="e47e907a85a9625e3e19ccea1bab293eba842e58d30b12936087ececbb65a14297d527152ad276f6f759ad403ad91308671eec66db06ada4d331f903762cc0b4"
export ACTIVEMQ_HOME="/opt/activemq"
