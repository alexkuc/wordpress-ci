#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

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

if [[ -z "${1:-}" ]]; then
    help '<command>'
    exit 1
fi

if [[ -z "${3:-}" ]]; then
    help '<cache-key>'
    exit 1
fi

case "$1" in
    store)
        if [[ -z "${2:-}" ]]; then
            help '<folder>'
            exit 1
        fi

        cache store "$2" "$3"
        ;;

    restore)
        cache restore "$2"
        ;;

    *)
        echo 'unknown switch used!'
        ;;
esac
