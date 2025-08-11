#!/usr/bin/env bash

PKG_VERSION="$(cat "/usr/lib/homebrew/package-version.txt")"
HOMEBREW_BIN="${HOME}/.local/share/homebrew/${PKG_VERSION}/bin"

if [[ "${PATH}" != *"${HOMEBREW_BIN}"* ]]; then
  export PATH="$PATH:${HOMEBREW_BIN}"
fi
