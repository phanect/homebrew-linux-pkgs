#!/usr/bin/env bash

set -eux

type debuild > /dev/null
type gh > /dev/null

DIRNAME="$(realpath "$(dirname  -- "${BASH_SOURCE[0]}")")"
PROJECT_ROOT="$(realpath "${DIRNAME}/..")"
WORKSPACE_DIR="${PROJECT_ROOT}/debs/homebrew"

# Create homebrew version file
HOMEBREW_VERSION="$(gh release list --repo="Homebrew/brew" --jq="map(select(.isLatest == true)) | .[].tagName" --json="tagName,isLatest")"
mkdir -p "${WORKSPACE_DIR}/lib/"
echo "${HOMEBREW_VERSION}" | tee "${WORKSPACE_DIR}/lib/version.txt"

export DEBEMAIL="git@phanective.org"
export DEBFULLNAME="Jumpei Ogawa"

(cd "${WORKSPACE_DIR}" && debuild -us -uc -b)
