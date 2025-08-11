#!/usr/bin/env bash

HOMEBREW_PKG_VERSION="$(cat "/usr/lib/homebrew/version.txt")"
HOMEBREW_BIN="${HOME}/.local/share/homebrew/${HOMEBREW_PKG_VERSION}/bin"

if [[ "${PATH}" != *"${HOMEBREW_BIN}"* ]]; then
  export PATH="$PATH:${HOMEBREW_BIN}"
fi
