#!/bin/bash
# credit goes to Van Eyck and David Pashley
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# see https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

if [[ ! -f /.dockerenv ]]; then
    echo ''
    echo 'You are meant to launch this script from *inside* the container!'
    echo ''
    exit 1
fi

# https://developer.wordpress.org/cli/commands/dist-archive/#installing
if [[ ! "$(wp dist-archive)" ]]; then
    echo ''
    echo 'Installing wp-cli/dist-archive-command...'
    echo ''
    wp package install wp-cli/dist-archive-command
fi

cd wp-content/themes/src
rm -f src.zip
wp dist-archive . "$PWD/src.zip"
