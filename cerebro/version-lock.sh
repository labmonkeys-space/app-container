#!/usr/bin/env bash
set -u -o pipefail

export VCS_SOURCE="$(git remote get-url --push origin)"
export VCS_REVISION="$(git describe --always)"
export BASE_IMAGE="quay.io/labmonkeys/openjdk:jre-11.0.14.b104"
export CEREBRO_VERSION="0.9.4"
export CEREBRO_HOME="/opt/cerebro"

