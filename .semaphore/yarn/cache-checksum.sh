#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# sanity check:
# script needs to be sourced
if [[ "$0" = "${BASH_SOURCE[0]}" ]]; then
  echo ''
  echo 'You need to source this script!'
  echo 'Otherwise you will not inherite environment variables!'
  echo ''
  echo 'Correct usage: source .semaphore/yarn/cache-checksums.sh'
  echo 'Correct usage: . .semaphore/yarn/cache-checksums.sh'
  echo ''
  exit 1
fi

# function to calculate checksum for package.json & yarn.lock
# additionally, dev/no-dev mode is considered
function calculate_checksum {
  PACKAGE_JSON="$(checksum ./"$1"/package.json)"
  YARN_LOCK="$(checksum ./"$1"/yarn.lock)"
  if [[ -n "${CI_YARN_NO_DEV:-}" ]]; then
    YARN_MODE='no-dev'
  else
    YARN_MODE='dev'
  fi
  echo "yarn-$YARN_MODE-$PACKAGE_JSON-$YARN_LOCK"
  exit 0
}

# prepare checksum variable for src (theme)
MY_THEME_NODE="$(calculate_checksum 'src')"
MY_THEME_NODE="docker-my-theme-$MY_THEME_NODE"

# variable is used in other scripts hence export
export MY_THEME_NODE

# not unsetting safe-guards will cause issues as you need to source this script
set +Eeuo pipefail
trap - ERR
