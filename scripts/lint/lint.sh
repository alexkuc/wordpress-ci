#!/bin/bash
# credit goes to Van Eyck and David Pashley
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# see https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# bash script to automate various linting tasks
case "${1:-}" in

    # allow calling specific linter to speed up local development
    shellcheck | phplint | phpcs | jshint )
        ./scripts/lint/"$1".sh
        ;;

    # execute all linters by default
    *)
        for i in scripts/lint/[^lint]*.sh; do
            bash "$i"
        done
        ;;

esac
