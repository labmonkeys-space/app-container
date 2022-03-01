#!/usr/bin/env bash
set -u -o pipefail

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
export BASE_IMAGE="quay.io/labmonkeys/ubuntu:jammy-20220130.b140"
export S6_OVERLAY_VERSION="v2.2.0.3"
export INETUTILS_SYSLOGD_VERSION="2:2.2-2"
export DOVECOT_IMAPD_VERSION="1:2.3.13+dfsg1-1ubuntu3"
export POSTFIX_VERSION="3.5.13-1ubuntu2"
export WHOIS_VERSION="5.5.10ubuntu1"
