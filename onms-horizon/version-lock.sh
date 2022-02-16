#!/usr/bin/env bash
set -u -o pipefail

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
export BASE_IMAGE="quay.io/labmonkeys/openjdk:jdk-11.0.14.b119"
export CONFD_VERSION="0.16.0"
export R_VERSION="4.1.2-1ubuntu1"
export RRDTOOL_VERSION="1.7.2-3ubuntu2"
export JICMP_VERSION="2.0.4-1"
export JICMP6_VERSION="2.0.3-1"
export JRRD2_VERSION="2.0.4"
export ONMS_HZN_VERSION="29.0.5"
