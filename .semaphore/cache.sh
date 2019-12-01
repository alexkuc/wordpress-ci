#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

COMPOSER_JSON="$(checksum ./wp-browser/composer.lock)"
COMPOSER_LOCK="$(checksum ./wp-browser/composer.json)"

case "$1" in
    store)
        cache store "composer-$COMPOSER_LOCK-$COMPOSER_JSON" wp-browser/vendor
        ;;

    restore)
        cache restore "composer-$COMPOSER_LOCK-$COMPOSER_JSON"
        ;;

    *)
        echo 'unknown switch used!'
        ;;
esac
