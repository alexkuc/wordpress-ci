#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

if [[ "$0" = "${BASH_SOURCE[0]}" ]]; then
  echo ''
  echo 'You need to source this script!'
  echo 'Otherwise you will not inherite environment variables!'
  echo ''
  echo 'Correct usage: source .semaphore/composer/cache-checksums.sh'
  echo 'Correct usage: . .semaphore/composer/cache-checksums.sh'
  echo ''

  exit 1
fi

function calculate_checksum {
  COMPOSER_JSON="$(checksum ./"$1"/composer.json)"
  COMPOSER_LOCK="$(checksum ./"$1"/composer.lock)"
  if [[ -n "${CI_COMPOSER_NO_DEV:-}" ]]; then
    COMPOSER_MODE='no-dev'
  else
    COMPOSER_MODE='dev'
  fi
  echo "composer-$COMPOSER_MODE-$COMPOSER_JSON-$COMPOSER_LOCK"
  exit 0
}

WP_BROWSER_COMPOSER="$(calculate_checksum 'test')"
WP_BROWSER_COMPOSER="docker-wp-browser-$WP_BROWSER_COMPOSER"
export WP_BROWSER_COMPOSER

MY_THEME_COMPOSER="$(calculate_checksum 'src')"
MY_THEME_COMPOSER="docker-my-theme-$MY_THEME_COMPOSER"
export MY_THEME_COMPOSER

# not unsetting safe-guards will cause issues as you need to source this script
set +Eeuo pipefail
trap - ERR
