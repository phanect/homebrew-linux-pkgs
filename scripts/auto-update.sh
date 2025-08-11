#!/usr/bin/env bash

set -eux

type debuild > /dev/null
type gh > /dev/null

DIRNAME="$(realpath "$(dirname  -- "${BASH_SOURCE[0]}")")"
PROJECT_ROOT="$(realpath "${DIRNAME}/..")"
WORKSPACE_DIR="${PROJECT_ROOT}/debs/homebrew"

# Create homebrew version file
HOMEBREW_VERSION="$(gh release list --repo="Homebrew/brew" --jq="map(select(.isLatest == true)) | .[].tagName" --json="tagName,isLatest")"

