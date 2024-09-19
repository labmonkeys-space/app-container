#!/usr/bin/env bash
set -u -o pipefail

source ../base_images.sh

VCS_SOURCE="$(git remote get-url --push origin)"
VCS_REVISION="$(git describe --always)"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_SOURCE
export VCS_REVISION
export DATE
export BASE_IMAGE="${OS_UBUNTU}"
export S6_OVERLAY_VERSION="v3.2.0.0"
export INETUTILS_SYSLOGD_VERSION="2:2.5-3ubuntu4"
export DOVECOT_IMAPD_VERSION="1:2.3.21+dfsg1-2ubuntu6"
export POSTFIX_VERSION="3.8.6-1build2"
export WHOIS_VERSION="5.5.22"
