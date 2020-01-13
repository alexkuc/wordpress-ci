#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# provide a rudimentary "manpage" for this script
function help {
    echo ''
    echo 'Bash script cache.sh is not called properly!'
    echo 'Proper format: cache.sh <command> <key> <folder>'
    echo 'command: which cache command to execute'
    echo 'List of available commands: store, restore'
    # shellcheck disable=SC2016
    echo 'key: cache key with can contain $VARS'
    echo 'folder: name of the folder you want to cache'
    echo ''
    echo "You forgot to specify $1!"
    echo ''
}

# sanity check:
# missing 1st parameter
if [[ -z "${1:-}" ]]; then
    help '<command>'
    exit 1
fi

# sanity check:
# missing 3rd parameter
if [[ -z "${3:-}" ]]; then
    help '<cache-key>'
    exit 1
fi

case "$1" in

    # store cache
    store)

        # sanity check:
        # missing 2nd parameter
        if [[ -z "${2:-}" ]]; then
            help '<folder>'
            exit 1
        fi

        # SemaphoreCI functions
        # https://docs.semaphoreci.com/ci-cd-environment/toolbox-reference/#cache
        cache store "$2" "$3"
        ;;

    # restore cache
    restore)
        # SemaphoreCI functions
        # https://docs.semaphoreci.com/ci-cd-environment/toolbox-reference/#cache
        cache restore "$2"
        ;;

    # catch-all for non-existing switch case
    *)
        echo 'unknown switch used!'
        ;;
esac
