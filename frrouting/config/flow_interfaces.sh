#!/command/with-contenv bash
# Copyright 2025 Ronny Trommer <ronny@no42.org>
# SPDX-License-Identifier: MIT
# shellcheck shell=bash
set -eEuo pipefail

# Build the pmacct interface map from the comma-separated $INTERFACES env var:
# one "ifindex=<n> ifname=<name> direction=in" line per interface.
IFS=',' read -r -a INTERFACES <<< "${INTERFACES}"
for int in "${INTERFACES[@]}"; do
  ifindex=$(cat "/sys/class/net/${int}/ifindex")
  printf "ifindex=%d ifname=%s direction=in\n" "${ifindex}" "${int}" >> /etc/pmacct/interfaces.map
done
