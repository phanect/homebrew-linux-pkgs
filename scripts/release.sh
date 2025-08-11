#!/usr/bin/env bash

set -eux

DIRNAME="$(realpath "$(dirname  -- "${BASH_SOURCE[0]}")")"
PROJECT_ROOT="$(realpath "${DIRNAME}/..")"

function get-homebrew-version() {
  dpkg --info "$@" | grep --only-matching --perl-regexp "^ Version: \K[0-9\.]+$"
}

HOMEBREW_VERSION="$(get-homebrew-version "${PROJECT_ROOT}/debs/homebrew.deb")"

if gh release view "${HOMEBREW_VERSION}"; then
  echo "Homebrew ${HOMEBREW_VERSION} already released. Exiting..."
else
  gh release create "${HOMEBREW_VERSION}" --generate-notes ./debs/homebrew_*.deb
fi
