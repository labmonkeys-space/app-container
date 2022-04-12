#!/usr/bin/env bash
set -u -o pipefail

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
export BUILD_BASE_IMAGE="quay.io/labmonkeys/maven:jdk11.0.14-3.6.3.b284"
export BASE_IMAGE="quay.io/labmonkeys/openjdk:jre-11.0.14.b135"
export GIT_COMMIT="94f575ea"
