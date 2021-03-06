#!/bin/bash
# credit goes to Van Eyck and David Pashley
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# see https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

echo ''
echo 'Creating minified assets!'
echo ''

# run custom grunt task to create minified css and js files
./scripts/assets/minified/create-min-js.sh
./scripts/assets/minified/create-min-css.sh
