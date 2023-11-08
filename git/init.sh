#! /usr/bin/env bash

set -eEo pipefail

# shellcheck disable=SC2154
trap 's=$?; echo >&2 "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

OPENNMS_OVERLAY=/opt/opennms-overlay
GIT_HOST="${GIT_HOST:-github.com}"
GIT_HOST_SCHEME="${GIT_HOST_SCHEME:-https}"

if [ -z "${GIT_REPO}" ]; then
  echo "The GIT_REPO environment variable is required."
  echo "You need to set it to a GitHub repository to fetch a configuration for the OPENNMS_OVERLAY directory."
  echo "Set the environment variable with something like: GIT_REPO=myorg/repo"
  exit 1
fi

if [ -n "${GIT_USER}" ] && [ -n "${GIT_PASS}" ]; then
  echo "Configure credential helper for user ${GIT_USER} with the password provided in GIT_PASS."
  git config --global credential.helper store
  git config --global credential.helper "store --file ~/.git-credentials"
  echo "${GIT_HOST_SCHEME}://${GIT_USER}:${GIT_PASS}@${GIT_HOST}/${GIT_REPO}" > ~/.git-credentials
fi

if [ -d "${OPENNMS_OVERLAY}" ] ; then
  echo "Clone skipped because the folder ${OPENNMS_OVERLAY} exists"
  cd ${OPENNMS_OVERLAY}
  git pull
else
  echo "Initialize ${OPENNMS_OVERLAY} from reppository ${GIT_REPO}"
  git clone "${GIT_HOST_SCHEME}://${GIT_HOST}/${GIT_REPO}.git" "${OPENNMS_OVERLAY}"
fi

if [ -f ~/.git-credentials ]; then
  echo "Clean up credentials"
  rm ~/.git-credentials
fi

