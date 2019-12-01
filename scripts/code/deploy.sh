#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

IS_WP=$(command -v wp || true)

if [[ -z "${1:-}" ]]; then
    echo ''
    echo 'You need to specify path where your WordPress code exists'
    echo 'For example: ./scripts/code/deploy.sh "my-theme" or'
    echo 'For example: ./scripts/code/deploy.sh "my-plugin"'
    echo ''

    exit 1
fi

if [[ ! -e "$1" ]]; then
    echo ''
    echo "The specified folder '$1' does not exist!"
    echo ''

    exit 1
fi

# variables to create path where the command will be executed
EXEC_PATH_DOCKER="$1"
EXEC_PATH_LOCAL="$PWD/$EXEC_PATH_DOCKER"

# local command to be executed
CMD_LOCAL="wp package install wp-cli/dist-archive-command && wp dist-archive . $1.zip"

# Docker image to be used
DOCKER_IMAGE='alexkuc/wordpress:cli-zip'

if [[ -n "$IS_WP" ]] && [[ -e 'wp-config.php' ]]; then
    echo ''
    echo 'Creating dist-archive using locally installed wp-cli...';

    (cd "$EXEC_PATH_LOCAL" && eval "$CMD_LOCAL")

else
    echo ''
    echo 'Creating dist-archive using Docker based wp-cli...';

    # adding Docker specific parameters here
    CMD_DOCKER="$CMD_LOCAL"

    docker run --rm \
                -v "$EXEC_PATH_LOCAL:/$EXEC_PATH_DOCKER" \
                -v "$PWD/configs/php.ini-wp-cli:/usr/local/etc/php/php.ini" \
                -w "/$EXEC_PATH_DOCKER" \
                "$DOCKER_IMAGE" bash -c "$CMD_DOCKER"
fi
