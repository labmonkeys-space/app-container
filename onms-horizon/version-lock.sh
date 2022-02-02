#!/usr/bin/env bash
set -u -o pipefail

export VCS_SOURCE="$(git remote get-url --push origin)"
export VCS_REVISION="$(git describe --always)"
export BASE_IMAGE="quay.io/labmonkeys/openjdk:jdk-11.0.14.b106"
export CONFD_VERSION="0.16.0"
export R_VERSION="4.1.2-1ubuntu1"
export RRDTOOL_VERSION="1.7.2-3ubuntu2"
export JICMP_VERSION="2.0.4-1"
export JICMP6_VERSION="2.0.3-1"
export JRRD2_VERSION="2.0.4"
export ONMS_HZN_VERSION="29.0.5"
