#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

. .semaphore/composer/cache-checksums.sh

if [[ -z "${CI_COMPOSER_NO_DEV:-}" ]]; then
    ./.semaphore/cache.sh store "$WP_BROWSER_COMPOSER" 'test/vendor/'
fi

./.semaphore/cache.sh store "$MY_THEME_COMPOSER" 'src/vendor/'
