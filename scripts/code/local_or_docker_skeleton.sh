#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# this is a scaffold/skeleton script to provide a template
# where a command can be run either locally or via docker;
# see composer.sh in folder 'scripts/code' for example

# check if binary exists locally
# for example, IS_BIN=$(command -v yarn || true)
# which checks for a locally installed yarn
IS_BIN=$(command -v yarn || true)

# variables to create path where the command will be executed
# this is essentially the same thing as cwd/pwd
EXEC_PATH_DOCKER="folder"
EXEC_PATH_LOCAL="$PWD/$EXEC_PATH_DOCKER"

# command to execute
CMD_LOCAL="..."

# name of Docker image to run, must be public or
# Docker host must have credentials to be able to
# access it; assumption is made that the image has
# Bash installed (see below for details)
DOCKER_IMAGE=''

if [[ -n "$IS_BIN" ]]; then
    echo ''
    echo 'Executing command locally...';

    (cd "$EXEC_PATH_LOCAL" && eval "$CMD_LOCAL")

else
    echo ''
    echo 'Executing command via Docker container...';

    # allows to modify the command if Docker container
    # requires it (see scripts/code/composer.sh for example)
    CMD_DOCKER="$CMD_LOCAL"

    docker run --rm \
                -v "$EXEC_PATH_LOCAL:/$EXEC_PATH_DOCKER" \
                -w "/$EXEC_PATH_DOCKER" \
                "$DOCKER_IMAGE" bash -c "$CMD_DOCKER"
fi
