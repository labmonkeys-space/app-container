#!/usr/bin/env bash
set -u -o pipefail

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
export BUILD_BASE_IMAGE="quay.io/labmonkeys/maven:jdk11.0.15-3.6.3.b459"
export BASE_IMAGE="quay.io/labmonkeys/openjdk:jre-11.0.16.b152"
export GIT_COMMIT="66c6a56"
