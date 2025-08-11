#!/usr/bin/env bash

set -eux

DIRNAME="$(realpath "$(dirname  -- "${BASH_SOURCE[0]}")")"
PROJECT_ROOT="$(realpath "${DIRNAME}/..")"
WORKSPACE_DIR="${PROJECT_ROOT}/debs/homebrew"

HOMEBREW_VERSION="$(dpkg-parsechangelog --show-field Version --file "${WORKSPACE_DIR}/debian/changelog")"

if gh release view "${HOMEBREW_VERSION}"; then
  echo "Homebrew ${HOMEBREW_VERSION} already released. Exiting..."
else
  gh release create "${HOMEBREW_VERSION}" --generate-notes ./debs/homebrew_*.deb
fi
