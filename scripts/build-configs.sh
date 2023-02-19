#!/usr/bin/env bash

set -eu

# Hostname
HOSTNAME="apt.phanective.org"
# Supported Architectures
ARCHS="i386 amd64 arm64 arm7 armhf"

PROJECT_ROOT="$(dirname "$(realpath "${BASH_SOURCE:-$0}")")/.."

#
# Generate Packages.gz
#
for arch in $ARCHS; do
  mkdir --parents "${PROJECT_ROOT}/public/dists/stable/main/binary-${arch}"
  (
    cd "${PROJECT_ROOT}/public/" && \
    dpkg-scanpackages --multiversion --arch "${arch}" pool > "${PROJECT_ROOT}/public/dists/stable/main/binary-${arch}/Packages"
  )
  cat "${PROJECT_ROOT}/public/dists/stable/main/binary-${arch}/Packages" | gzip -9c > "${PROJECT_ROOT}/public/dists/stable/main/binary-${arch}/Packages.gz"
done

#
# Generate Release
#
RELEASE_PATH="${PROJECT_ROOT}/public/dists/stable/Release"

hash() {
  HASH_NAME=$1
  HASH_CMD=$2

  echo "${HASH_NAME}:"

  for file in $(find "${PROJECT_ROOT}/public/dists/stable" -type f); do
    if [[ "$file" = "${RELEASE_PATH}" ]]; then
      continue
    fi

    HASH_CODE="$(${HASH_CMD} "${file}" | cut --delimiter=" " --fields=1)"
    FILE_SIZE="$(wc --bytes "${file}" | cut --delimiter=" " --fields=1)"
    RELATIVE_FILE_PATH="${file/${PROJECT_ROOT}\/public\/dists\/stable\//}"

    echo " ${HASH_CODE} ${FILE_SIZE} ${RELATIVE_FILE_PATH}"
  done
}

cat << __RELEASE__ > "${RELEASE_PATH}"
Origin: ${HOSTNAME}
Label: ${HOSTNAME}
Suite: stable
Codename: stable
Version: $(date --utc "+%Y.%-m.%-d")
Architectures: ${ARCHS}
Components: main
Description: phanective.org apt repository
Date: $(date --rfc-email --utc)
__RELEASE__

hash "MD5Sum" "md5sum" >> "${RELEASE_PATH}"
hash "SHA1" "sha1sum" >> "${RELEASE_PATH}"
hash "SHA256" "sha256sum" >> "${RELEASE_PATH}"

#
# GPG Signature
#
echo "${GPG_PRIVATE_KEY}" | base64 --decode | gpg --import
cat "${RELEASE_PATH}" | gpg --default-key "${EMAIL}" --armor --detach-sign --sign > "${RELEASE_PATH}.gpg"
cat "${RELEASE_PATH}" | gpg --default-key "${EMAIL}" --armor --detach-sign --sign --clearsign > "${RELEASE_PATH/Release/InRelease}"

echo "${GPG_PUBLIC_KEY}" | base64 --decode > ./public/phanective.gpg
