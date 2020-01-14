#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# check if binary exists locally
# for example, IS_BIN=$(command -v yarn || true)
# which checks for a locally installed yarn
IS_BIN=$(command -v yarn || true)

# variables to create path where the command will be executed
# this is essentially the same thing as cwd/pwd
EXEC_PATH_DOCKER="src"
EXEC_PATH_LOCAL="$PWD/$EXEC_PATH_DOCKER"

# command to execute
CMD_LOCAL="yarn install"

# determine if running development or production mode
if [[ -n "${CI_YARN_NO_DEV:-}" ]]; then
    # production mode
    echo ''
    echo 'Detected production environment for Yarn...'
    CMD_LOCAL="$CMD_LOCAL --production=true"
else
    # development mode
    echo ''
    echo 'Detected development environment for Yarn...'
    CMD_LOCAL="$CMD_LOCAL --production=false"
fi

# name of Docker image to run, must be public or
# Docker host must have credentials to be able to
# access it; assumption is made that the image has
# Bash installed (see below for details)
DOCKER_IMAGE='node'

# check if binary exists locally or fallback to Docker image option
if [[ -n "$IS_BIN" ]]; then
    echo ''
    echo 'Executing command locally...';

    # cd into path of the locally binary
    # execute local binary
    (cd "$EXEC_PATH_LOCAL" && eval "$CMD_LOCAL")
else
    echo ''
    echo 'Executing command via Docker container...';

    # allows to modify the command if Docker container
    # requires it (see scripts/php/composer.sh for example)
    CMD_DOCKER="$CMD_LOCAL"

    # fallback to Docker image option
    docker run --rm \
                -v "$EXEC_PATH_LOCAL:/$EXEC_PATH_DOCKER" \
                -w "/$EXEC_PATH_DOCKER" \
                "$DOCKER_IMAGE" bash -c "$CMD_DOCKER"
fi
