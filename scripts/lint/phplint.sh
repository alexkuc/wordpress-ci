#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# folders which will be linted by phplint
folders=("src" "test")

for i in "${folders[@]}"; do
    # check if binary exists locally
    # for example, IS_BIN=$(command -v yarn || true)
    # which checks for a locally installed yarn
    IS_BIN=$(command -v "$PWD"/"$i"/vendor/bin/phplint || true)

    # variables to create path where the command will be executed
    # this is essentially the same thing as cwd/pwd
    EXEC_PATH_DOCKER="/data"
    EXEC_PATH_LOCAL="$PWD/$i"

    # command to execute
    CMD_LOCAL="./vendor/bin/phplint"

    # name of Docker image to run, must be public or
    # Docker host must have credentials to be able to
    # access it; assumption is made that the image has
    # Bash installed (see below for details)
    DOCKER_IMAGE='composer'

    # execute either locally installed phpcs or fallback to Docker image option
    if [[ -n "$IS_BIN" ]]; then
        echo ''
        echo "Executing phplint locally for the folder '$i'...";
        echo ''

        # not unsetting safe-guards will errounously blame this script/command if lint fails
        set +Eeuo pipefail
        trap - ERR

        # cd into locally installed phpcs path and execute it
        (cd "$EXEC_PATH_LOCAL" && eval "$CMD_LOCAL")
    else
        echo ''
        echo "Executing phplint via Docker container for the folder '$i'...";
        echo ''

        # allows to modify the command if Docker container
        # requires it (see scripts/php/composer.sh for example)
        CMD_DOCKER="composer require overtrue/phplint && $CMD_LOCAL $EXEC_PATH_DOCKER"

        # not unsetting safe-guards will errounously blame this script/command if lint fails
        set +Eeuo pipefail
        trap - ERR

        # use Docker image option to run phpcs
        docker run --rm \
                    -v "$EXEC_PATH_LOCAL:$EXEC_PATH_DOCKER" \
                    "$DOCKER_IMAGE" bash -c "$CMD_DOCKER"
    fi
done
