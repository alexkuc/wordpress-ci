#!/bin/bash -e

trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

IS_COMPOSER=$(command -v composer || true)

DOCKER_COMPOSER_PATH="/wp-browser"
LOCAL_COMPOSER_PATH="$PWD/$DOCKER_COMPOSER_PATH"

# --ignore-platform-reqs because php is run on docker container
FIX="composer global require hirak/prestissimo"
CMD="composer install --ignore-platform-reqs"

if [ ! -d "$LOCAL_COMPOSER_PATH/vendor" ]; then
    if [ -n "$IS_COMPOSER" ]; then
        echo 'Installing (globally) hirak/prestissimo via local Composer...'
        eval $FIX

        if [ ! -d "$LOCAL_COMPOSER_PATH/vendor" ]; then
            echo 'Installing PHP depedencies via local Composer...'
            eval $CMD -d $LOCAL_COMPOSER_PATH
        fi
    else
        echo 'Composer is not installed locally! Resorting to Docker...'

        echo 'Will (globally) install hirak/prestissimo inside Docker-based Composer container...'
        CMD_DOCKER="$FIX"

        if [ ! -d "$LOCAL_COMPOSER_PATH/vendor" ]; then
            echo 'Will install PHP depedencies via Docker-based Composer container...'
            CMD_DOCKER="${CMD_DOCKER} && $CMD -d $DOCKER_COMPOSER_PATH"
        fi

        echo 'Running Composer commands via Docker-based Composer container...'
        docker run --rm \
                    -v "$LOCAL_COMPOSER_PATH:$DOCKER_COMPOSER_PATH" \
                composer bash -c "$CMD_DOCKER"
    fi
else
    echo ''
    echo 'Warning! Composer (vendor dir) is already present!'
    echo 'Skipping installation of Composer depedencies!'
    echo ''
fi
