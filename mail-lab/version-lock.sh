#!/usr/bin/env bash
set -u -o pipefail

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
export BASE_IMAGE="quay.io/labmonkeys/ubuntu:jammy-20220428.b169"
export S6_OVERLAY_VERSION="v3.1.0.1"
export INETUTILS_SYSLOGD_VERSION="2:2.2-2"
export DOVECOT_IMAPD_VERSION="1:2.3.16+dfsg1-3ubuntu2"
export POSTFIX_VERSION="3.6.4-1ubuntu1"
export WHOIS_VERSION="5.5.13"
