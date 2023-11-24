#! /usr/bin/env bash

set -eEo pipefail

# shellcheck disable=SC2154
trap 's=$?; echo >&2 "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

GIT_DATA=/data/opennms-overlay
GIT_HOST="${GIT_HOST:-github.com}"
GIT_HOST_SCHEME="${GIT_HOST_SCHEME:-https}"
GIT_BRANCH="${GIT_BRANCH:-main}"

if [ -z "${GIT_REPO}" ]; then
  echo "The GIT_REPO environment variable is required."
  echo "You need to set it to a GitHub repository to fetch into the GIT_DATA directory."
  echo "Set the environment variable with something like: GIT_REPO=myorg/repo"
  exit 1
fi

if [ -n "${GIT_USER}" ] && [ -n "${GIT_PASS}" ]; then
  echo "Configure credential helper for user ${GIT_USER} with the password provided in GIT_PASS."
  git config --global credential.helper store
  git config --global credential.helper "store --file ~/.git-credentials"
  echo "${GIT_HOST_SCHEME}://${GIT_USER}:${GIT_PASS}@${GIT_HOST}/${GIT_REPO}" > ~/.git-credentials
fi

if [ -d "${GIT_DATA}/.git" ] ; then
  echo "Clone skipped because ${GIT_DATA} is a git repository already."
  cd ${GIT_DATA}
  if [ ! "${GIT_BRANCH}" = "main" ]; then
    echo "Switch to branch ${GIT_BRANCH}."
    git checkout -b "${GIT_BRANCH}" origin/"${GIT_BRANCH}"
  else
    echo "Pull from main branch."
    git switch "${GIT_BRANCH}"
  fi
  git fetch --all
  git reset --hard origin/"${GIT_BRANCH}"
else
  echo "Initialize ${GIT_DATA} from reppository ${GIT_REPO}"
  git clone "${GIT_HOST_SCHEME}://${GIT_HOST}/${GIT_REPO}.git" "${GIT_DATA}"
  cd ${GIT_DATA}
  if [ ! "${GIT_BRANCH}" = "main" ]; then
    echo "Switch to branch ${GIT_BRANCH}."
    git checkout -b "${GIT_BRANCH}" origin/"${GIT_BRANCH}"
  fi
fi

if [ -f ~/.git-credentials ]; then
  echo "Clean up credentials"
  rm ~/.git-credentials
fi
