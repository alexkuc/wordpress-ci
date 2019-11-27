#!/bin/bash
# credit goes to Van Eyck and David Pashley
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# see https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# do not run this script inside CI environment
# it is intended to be run for local setups only
if [ -n "${CI:-}" ]; then
    exit 0
fi

echo ''
echo 'WARNING! You need to source this script!'
echo 'Do not run it via sub shell otherwise you will not inherite environment variables!'
echo 'Correct usage: source host-scripts/docker-machine-start.sh'
echo 'Correct usage: . host-scripts/docker-machine-start.sh'
echo ''

MACHINE_NAME="${MACHINE_NAME:-default}"
IS_RUNNING=$(docker-machine status "$MACHINE_NAME")

# OSX-specific
IS_OSX=$(uname -s || true)
IS_BREW=$(command -v brew || true)
IS_NFS_MACHINE=$(command -v docker-machine-nfs || true)

if [ "$IS_RUNNING" != 'Running' ]; then
    echo "Starting docker-machine $MACHINE_NAME"
    docker-machine start "$MACHINE_NAME"
    # performance fix for Docker on Mac (requires Brew and docker-machine-nfs)
    # https://github.com/covex-nn/docker-workflow-symfony/issues/1
    if [ "$IS_OSX" = 'Darwin' ] && [ -n "$IS_BREW" ] && [ -n "$IS_NFS_MACHINE" ]; then
        echo "Starting docker-machine-nfs $MACHINE_NAME"
        docker-machine-nfs "$MACHINE_NAME"
    fi
else
    echo 'Skipping docker-machine start!'
    echo "docker-machine $MACHINE_NAME is already running!"
fi

echo "Evalulating docker-machine env $MACHINE_NAME"
eval "$(docker-machine env "$MACHINE_NAME")"
