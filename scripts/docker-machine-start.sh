#!/bin/bash
# credit goes to Van Eyck and David Pashley
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# see https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# do not run this script inside CI environment
# it is intended to be run for local setups only
if [[ -n "${CI:-}" ]]; then
    exit 0
fi

# sanity check:
# this script should be sourced instead of
# running it in a separate shell process
if [[ "$0" = "${BASH_SOURCE[0]}" ]]; then
  echo ''
  echo 'You need to source this script!'
  echo 'Otherwise you will not inherite environment variables!'
  echo ''
  echo 'Correct usage: source scripts/docker-machine-start.sh'
  echo 'Correct usage: . scripts/docker-machine-start.sh'
  echo ''

  exit 1
fi

# internal variables
MACHINE_NAME="${MACHINE_NAME:-default}" # computer name
IS_RUNNING=$(docker-machine status "$MACHINE_NAME") # check docker-machine status

# OSX-specific variables
IS_OSX=$(uname -s || true) # is OSX?
IS_BREW=$(command -v brew || true) # homebrew installed?
IS_NFS_MACHINE=$(command -v docker-machine-nfs || true) # docker-machine-nfs installed?

# check status of docker-machine
if [[ "$IS_RUNNING" != 'Running' ]]; then

    # start docker-machine
    echo "Starting docker-machine $MACHINE_NAME"
    docker-machine start "$MACHINE_NAME"

    #
    # performance fix for Docker on Mac
    # https://github.com/covex-nn/docker-workflow-symfony/issues/1
    # requires homebrew and docker-nfs-machine to be installed
    #
    # rationale is the following: installation of both dependencies can have
    # severe side affects for the user and should not be done silently!
    #
    if [[ "$IS_OSX" = 'Darwin' && -n "$IS_BREW" && -n "$IS_NFS_MACHINE" ]]; then
        echo "Starting docker-machine-nfs $MACHINE_NAME"
        docker-machine-nfs "$MACHINE_NAME"
    fi

else
    echo ''
    echo 'Skipping docker-machine start!'
    echo "docker-machine $MACHINE_NAME is already running!"
    echo ''
fi

echo ''
echo "Evalulating docker-machine env $MACHINE_NAME"
echo ''
# import (source) docker environment variables
eval "$(docker-machine env "$MACHINE_NAME")"

# not unsetting safe-guards will cause issues as you need to source this script
set +Eeuo pipefail
trap - ERR
