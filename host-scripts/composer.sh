#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

IS_COMPOSER=$(command -v composer || true)

# Acronym: DEPS = Depedencies
DEPS_DOCKER_PATH="/wp-browser"
DEPS_LOCAL_PATH="$PWD/$DEPS_DOCKER_PATH"

# --ignore-platform-reqs because php is run on docker container
CMD_LOCAL="composer install --ignore-platform-reqs"

# Downloads packages in parallel to speed up the installation process
# https://github.com/hirak/prestissimo
PARALLEL_DL="composer global require hirak/prestissimo"

if [ ! -d "$DEPS_LOCAL_PATH/vendor" ]; then
    if [ -n "$IS_COMPOSER" ]; then
        if ! composer --quiet global show | grep -q 'hirak/prestissimo'; then
            echo 'Installing (globally) hirak/prestissimo via local Composer...'
            eval "$PARALLEL_DL"
        else
            echo 'hirak/prestissimo is already installed, skipping installation...'
        fi

        if [ ! -d "$DEPS_LOCAL_PATH/vendor" ]; then
            echo 'Installing PHP depedencies via local Composer...'
            eval "$CMD_LOCAL" -d "$DEPS_LOCAL_PATH"
        fi
    else
        echo 'Composer is not installed locally! Resorting to Docker...'

        echo 'Will (globally) install hirak/prestissimo inside Docker-based Composer container...'
        CMD_DOCKER="$PARALLEL_DL"

        echo 'Will install PHP depedencies via Docker-based Composer container...'
        CMD_DOCKER="$CMD_DOCKER && $CMD_LOCAL"

        echo 'Running Composer commands via Docker-based Composer container...'
        docker run --rm \
                    -v "$DEPS_LOCAL_PATH:$DEPS_DOCKER_PATH" \
                    -w "$DEPS_DOCKER_PATH" \
                composer bash -c "$CMD_DOCKER"
    fi
else
    echo ''
    echo 'Warning! Composer (vendor dir) is already present!'
    echo 'Skipping installation of Composer depedencies!'
    echo ''
fi
