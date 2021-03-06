#!/bin/bash
# credit goes to Van Eyck and David Pashley
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# see https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

if [[ "$CI" == 'true' ]] && [[ "$SEMAPHORE" == 'true' ]]; then
    # shellcheck disable=SC1091
    source /home/semaphore/.nvm/nvm.sh
    nvm use stable
fi

# install Composer and Yarn dependencies
case "${1:-}" in

    # allow selective installation of either Composer
    # or Yarn dependencies
    composer | yarn )
        ./scripts/deps/"$1".sh
        ;;

    # default state to install both Composer and
    # Yarn dependecies
    *)
        for i in scripts/deps/*.sh; do
            bash "$i"
        done
        ;;

esac
