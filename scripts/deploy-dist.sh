#!/bin/bash
# credit goes to Van Eyck and David Pashley
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# see https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# internal variable
SCRIPT="./scripts/assets/create-min.sh"
GREP_STR='error Command "grunt" not found.'
CMD="$SCRIPT | grep -q $GREP_STR"

# check if grunt dep is installed
if [[ "$CMD" ]]; then
    # removing existing deps and install dev deps
    # for Yarn to allow compilation of assets
    rm -fr src/node_modules/
    unset CI_COMPOSER_NO_DEV
    unset CI_YARN_NO_DEV
    # if SemaphoreCI, use cache
    if [[ -n "${CI:-}" ]] && [[ -n "${SEMAPHORE:-}" ]] ; then
        .semaphore/yarn/cache-restore.sh
    fi
    ./scripts/setup.sh 'yarn'
    ./scripts/assets/create-min.sh
fi

# enable dist (no_dev) mode
export CI_COMPOSER_NO_DEV='1'
export CI_YARN_NO_DEV='1'

# remove existing deps as not sure
# if they are dist or dev
rm -fr src/vendor/ src/node_modules/
# if SemaphoreCI, use cache
if [[ -n "${CI:-}" ]] && [[ -n "${SEMAPHORE:-}" ]] ; then
    .semaphore/composer/cache-restore.sh
    .semaphore/yarn/cache-restore.sh
fi
# install no_dev deps
./scripts/setup.sh

# create dist (src.zip) using wp
docker exec wordpress ./create-dist.sh

# on local machine, reinstall deps
# using dev mode
if [[ -z "${CI:-}" ]]; then
    rm -fr src/vendor/ src/node_modules/
    unset CI_COMPOSER_NO_DEV
    unset CI_YARN_NO_DEV
    ./scripts/setup.sh
fi
