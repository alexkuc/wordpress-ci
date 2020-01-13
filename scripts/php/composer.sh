#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# check if Composer is installed locally
IS_COMPOSER=$(command -v composer || true)

# sanity check:
# check for 1st positional parameter
if [[ -z "${1:-}" ]]; then
    echo ''
    echo 'You need to specify path where to install Composer depedencies'
    echo "For example: ./scripts/php/composer.sh 'test'"
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

# interal variables
# acronym: DEPS = Depedencies
DEPS_DOCKER_PATH="$1"
DEPS_LOCAL_PATH="$PWD/$DEPS_DOCKER_PATH"

# specify Composer parameters depending on development/production mode
if [[ -n "${CI_COMPOSER_NO_DEV:-}" ]]; then
    echo ''
    echo 'Detected production environment for Composer...'

    # production mode
    # --ignore-platform-reqs because php is run on docker container
    COMPOSER_OPTIONS="--no-dev --optimize-autoloader --ignore-platform-reqs"
else
    echo ''
    echo 'Detected development environment for Composer...'

    # development mode
    COMPOSER_OPTIONS="--ignore-platform-reqs"
fi

# use locally installed Composer
CMD_LOCAL="composer install $COMPOSER_OPTIONS"

# Downloads packages in parallel to speed up the installation process
# https://github.com/hirak/prestissimo
PARALLEL_DL="composer global require hirak/prestissimo"

# check if Composer deps are installed or not
if [[ ! -d "$DEPS_LOCAL_PATH/vendor" ]]; then

    # either running local Composer or falling back to Docker image
    if [[ -n "$IS_COMPOSER" ]]; then

        # enable parallel download for local Composer
        if ! composer global show | grep -q 'hirak/prestissimo'; then
            echo ''
            echo 'Installing globally hirak/prestissimo via local Composer...'
            echo ''
            eval "$PARALLEL_DL"
        else
            echo ''
            echo 'hirak/prestissimo is already installed, skipping installation...'
            echo ''
        fi

        # local Composer
        echo ''
        echo "Installing PHP depedencies via local Composer for folder $1..."
        echo ''
        eval "$CMD_LOCAL" -d "$DEPS_LOCAL_PATH"

    else

        echo ''
        echo 'Composer is not installed locally! Resorting to Docker...'
        echo 'Will (globally) install hirak/prestissimo inside Docker-based Composer container...'
        echo "Will install PHP depedencies via Docker-based Composer container for folder $1..."
        echo 'Running Composer commands via Docker-based Composer container...'
        echo ''

        # interal variables
        CMD_DOCKER="$PARALLEL_DL"
        CMD_DOCKER="$CMD_DOCKER && $CMD_LOCAL"

        # fallback to Docker image for Composer binary
        docker run --rm \
                    -v "$DEPS_LOCAL_PATH:/$DEPS_DOCKER_PATH" \
                    -w "/$DEPS_DOCKER_PATH" \
                composer bash -c "$CMD_DOCKER"
    fi
else
    echo ''
    echo "Warning! Skipping Composer depedencies for folder '$1'!"
    echo 'Warning! Vendor dir is already present!'
    echo ''
fi
