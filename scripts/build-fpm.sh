#!/usr/bin/env bash

set -eux

PKGNAME="homebrew"

DIRNAME="$(realpath "$(dirname  -- "${BASH_SOURCE[0]}")")"
PROJECT_ROOT="$(realpath "${DIRNAME}/..")"
BUILD_DIR="${PROJECT_ROOT}/tmp/build-deb"

# Clean up
rm -rf "${BUILD_DIR}"
mkdir --parents "${BUILD_DIR}"

# Install dependencies
bundle install

# Download homebrew
HOMEBREW_VERSION="$(gh release list --repo="Homebrew/brew" --jq="map(select(.isLatest == true)) | .[].tagName" --json="tagName,isLatest")"

curl -sSL \
  --output "${BUILD_DIR}/homebrew.zip" \
  "https://github.com/Homebrew/brew/archive/refs/tags/${HOMEBREW_VERSION}.zip"
unzip -q -d "${BUILD_DIR}/homebrew" "${BUILD_DIR}/homebrew.zip"

HOMEBREW_ROOT="${BUILD_DIR}/homebrew/$(ls "${BUILD_DIR}/homebrew")"

bundle exec fpm \
    -p "${PKGNAME}_${HOMEBREW_VERSION}-1_all.deb" \
    --name "${PKGNAME}" \
    --version "${HOMEBREW_VERSION}" \
  brew="${HOMEBREW_ROOT}/bin/brew"
