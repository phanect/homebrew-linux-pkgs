#!/usr/bin/env bash

set -eux

type snap > /dev/null
type snapcraft > /dev/null

snap set snapcraft provider=multipass
snapcraft pack
snap install ./brew_4.6.14_amd64.snap --dangerous --devmode
