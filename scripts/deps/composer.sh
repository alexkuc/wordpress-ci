#!/bin/bash
# credit goes to Van Eyck and David Pashley
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# see https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# install composer dependencies for test (WP-Browser)
# assuming env var is not empty
if [[ -z "${CI_COMPOSER_NO_DEV:-}" ]]; then
    ./scripts/php/composer.sh 'test'
fi

# install composer dependencies for src (theme)
./scripts/php/composer.sh 'src'
