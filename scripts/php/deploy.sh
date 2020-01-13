#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# is wp locally installed or not
IS_WP=$(command -v wp || true)

# sanity check:
# 1st positional parameter
if [[ -z "${1:-}" ]]; then
    echo ''
    echo 'You need to specify path where your WordPress code exists'
    echo "For example: ./scripts/code/deploy.sh 'src'"
    echo ''
    exit 1
fi

# sanity check:
# check if specified folder exists
if [[ ! -e "$1" ]]; then
    echo ''
    echo "The specified folder '$1' does not exist!"
    echo ''

    exit 1
fi

# variables to create path where the command will be executed
# includes path for both, local and Docker-based wp
EXEC_PATH_DOCKER="$1"
EXEC_PATH_LOCAL="$PWD/$EXEC_PATH_DOCKER"

# local command to be executed
CMD_LOCAL="wp package install wp-cli/dist-archive-command && wp dist-archive . $1.zip"

# Docker image to be used
DOCKER_IMAGE='alexkuc/wordpress:cli-zip'

# check if wp is installed locally or not
# additionally, check if 'wp-config.php' exists or not
if [[ -n "$IS_WP" ]] && [[ -e 'wp-config.php' ]]; then

    echo ''
    echo 'Creating dist-archive using locally installed wp-cli...';
    # use local wp
    (cd "$EXEC_PATH_LOCAL" && eval "$CMD_LOCAL")

else
    echo ''
    echo 'Creating dist-archive using Docker based wp-cli...';

    # adding Docker specific parameters here
    CMD_DOCKER="$CMD_LOCAL"

    # fallback to Docker image for wp binary
    docker run --rm \
                -v "$EXEC_PATH_LOCAL:/$EXEC_PATH_DOCKER" \
                -v "$PWD/configs/php.ini-wp-cli:/usr/local/etc/php/php.ini" \
                -w "/$EXEC_PATH_DOCKER" \
                "$DOCKER_IMAGE" bash -c "$CMD_DOCKER"
fi
