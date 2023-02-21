#!/usr/bin/env bash

set -eu

# Check dependencies
type node > /dev/null

if [[ -f ".env" ]]; then
  export $(grep --invert-match "^#" .env | xargs)
fi

# Check if secrets are set
: "${GPG_PRIVATE_KEY:?GPG_PRIVATE_KEY is not defined}"
: "${GPG_PUBLIC_KEY:?GPG_PUBLIC_KEY is not defined}"
: "${EMAIL:?EMAIL is not defined}"

PROJECT_ROOT="$(dirname "$(realpath "${BASH_SOURCE:-$0}")")"

rm -rf "${PROJECT_ROOT}/public"

node ./scripts/fetch-debs.js
./scripts/build-configs.sh
