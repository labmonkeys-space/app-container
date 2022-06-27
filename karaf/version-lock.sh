#!/usr/bin/env bash
set -u -o pipefail

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
export KARAF_HOME="/opt/karaf"
export BASE_IMAGE="quay.io/labmonkeys/openjdk:jre-11.0.15.b141"
export KARAF_VERSION="4.3.7"
