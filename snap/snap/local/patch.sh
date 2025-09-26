#!/bin/bash

set -eux

DIRNAME="$(realpath "$(dirname  -- "${BASH_SOURCE[0]}")")"

echo "Patching..."

ls -lR /root/prime

test -f "/root/prime/Library/Homebrew/brew.sh.orig" && mv "/root/prime/Library/Homebrew/brew.sh.orig" "/root/prime/Library/Homebrew/brew.sh"


echo "${DIRNAME}/patches/debug.diff"

patch "/root/prime/Library/Homebrew/brew.sh" "${DIRNAME}/patches/debug.diff"
