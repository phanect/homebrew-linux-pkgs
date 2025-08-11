#!/usr/bin/env bash

set -eux

type debuild > /dev/null
type gh > /dev/null

DIRNAME="$(realpath "$(dirname  -- "${BASH_SOURCE[0]}")")"
PROJECT_ROOT="$(realpath "${DIRNAME}/..")"
WORKSPACE_DIR="${PROJECT_ROOT}/debs/homebrew"

# Create homebrew version file
HOMEBREW_VERSION="$(gh release list --repo="Homebrew/brew" --jq="map(select(.isLatest == true)) | .[].tagName" --json="tagName,isLatest")"
PKG_VERSION="$(dpkg-parsechangelog --show-field Version --file "${WORKSPACE_DIR}/debian/changelog")"

if [[ "${PKG_VERSION}" != "${HOMEBREW_VERSION}-"*  ]]; then
  echo "Homebrew version mismatch: expected ${HOMEBREW_VERSION}-*, got ${PKG_VERSION}. Please update the changelog."
  exit 1
fi

mkdir -p "${WORKSPACE_DIR}/usr/lib/"
echo "${HOMEBREW_VERSION}" | tee "${WORKSPACE_DIR}/usr/lib/homebrew-version.txt"
echo "${PKG_VERSION}" | tee "${WORKSPACE_DIR}/usr/lib/package-version.txt"

export DEBEMAIL="git@phanective.org"
export DEBFULLNAME="Jumpei Ogawa"

(cd "${WORKSPACE_DIR}" && debuild -us -uc -b)
