#!/usr/bin/env bash

set -eux

type curl > /dev/null
type debuild > /dev/null
type gh > /dev/null

PKGNAME="homebrew"

DIRNAME="$(realpath "$(dirname  -- "${BASH_SOURCE[0]}")")"
PROJECT_ROOT="$(realpath "${DIRNAME}/..")"
BUILD_ROOT="${PROJECT_ROOT}/tmp/build-deb"
EXTRACTED_DIR="${BUILD_ROOT}/homebrew-extracted"

export DEBEMAIL="git@phanective.org"
export DEBFULLNAME="Jumpei Ogawa"

# Clean up
rm -rf "${BUILD_ROOT}"
mkdir --parents "${EXTRACTED_DIR}"

# Download homebrew
HOMEBREW_VERSION="$(gh release list --repo="Homebrew/brew" --jq="map(select(.isLatest == true)) | .[].tagName" --json="tagName,isLatest")"

curl -sSL \
  --output "${BUILD_ROOT}/homebrew_${HOMEBREW_VERSION}.orig.tar.gz" \
  "https://github.com/Homebrew/brew/archive/refs/tags/${HOMEBREW_VERSION}.tar.gz"

tar xf "${BUILD_ROOT}/homebrew_${HOMEBREW_VERSION}.orig.tar.gz" --directory="${EXTRACTED_DIR}"

HOMEBREW_ROOT="${BUILD_ROOT}/homebrew"

mv "${EXTRACTED_DIR}/$(ls ${EXTRACTED_DIR} | grep brew-*)" "${HOMEBREW_ROOT}"
rm -rf "${EXTRACTED_DIR}" "${BUILD_ROOT}/homebrew_${HOMEBREW_VERSION}.orig.tar.gz"

rm -rf \
  "${HOMEBREW_ROOT}/.devcontainer/" \
  "${HOMEBREW_ROOT}/.github/" \
  "${HOMEBREW_ROOT}/.sublime/" \
  "${HOMEBREW_ROOT}/.vscode/" \
  "${HOMEBREW_ROOT}/docs/" \
  "${HOMEBREW_ROOT}/Library/Homebrew/test/" \
  "${HOMEBREW_ROOT}/package/" \
  "${HOMEBREW_ROOT}/.dockerignore" \
  "${HOMEBREW_ROOT}/.editorconfig" \
  "${HOMEBREW_ROOT}/.gitignore" \
  "${HOMEBREW_ROOT}/.shellcheckrc" \
  "${HOMEBREW_ROOT}/CONTRIBUTING.md" \
  "${HOMEBREW_ROOT}/Dockerfile"
find "${HOMEBREW_ROOT}" -type f -name ".gitattributes" -exec rm -f "{}" \;
find "${HOMEBREW_ROOT}" -type f -name ".rubocop.yml" -exec rm -f "{}" \;
find "${HOMEBREW_ROOT}" -type f -name ".ruby-version" -exec rm -f "{}" \;

# Some +.rb files have execution permission, and it causes lintian error.
find "${HOMEBREW_ROOT}" -type f -name "*.rb" -exec chmod -x "{}" \;

cp --recursive "${PROJECT_ROOT}/debs/homebrew/debian" "${BUILD_ROOT}/"

# mkdir --parents "${HOMEBREW_ROOT}/usr/bin"
# ln --symbolic "/usr/lib/homebrew/bin/brew" "${HOMEBREW_ROOT}/usr/bin/brew"

(cd "${BUILD_ROOT}" && debuild -us -uc -b)
