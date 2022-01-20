#!/usr/bin/env bash
set -u -o pipefail

export VCS_SOURCE="$(git remote get-url --push origin)"
export VCS_REVISION="$(git describe --always)"
export BASE_IMAGE="quay.io/labmonkeys/ubuntu:jammy-20220101.b123"
export GIT_VERSION="1:2.33.1-1ubuntu1"
export RSYNC_VERSION="3.2.3-8ubuntu2"
export DNSUTILS_VERSION="1:9.16.15-1ubuntu3"
export IPUTILS_PING_VERSION="3:20210202-1build1"
