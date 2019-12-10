#!/bin/bash
# credit goes to Van Eyck and David Pashley
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# see https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

case "${1:-}" in
    shellcheck | phplint | phpcs )
        ./scripts/lint/"$1".sh
        ;;
    *)
        for i in scripts/lint/[^lint]*.sh; do
            bash "$i"
        done
        ;;
esac
