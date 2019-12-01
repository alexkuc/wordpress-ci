#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

. .semaphore/composer/cache-checksums.sh

./.semaphore/cache.sh restore "$WP_BROWSER_COMPOSER" 'wp-browser'
./.semaphore/cache.sh restore "$MY_THEME_COMPOSER" 'my-theme'
./.semaphore/cache.sh restore "$MY_PLUGIN_COMPOSER" 'my-plugin'
