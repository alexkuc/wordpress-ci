#!/bin/bash
# credit goes to Van Eyck and David Pashley
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# see https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# remove deps as not sure what mode they use
rm -r src/vendor/ src/node_modules/

# install dev deps
unset CI_COMPOSER_NO_DEV
unset CI_YARN_NO_DEV
./scripts/setup.sh

# TODO: use SemaphoreCI caching

# remove minified assets (css and js)
./scripts/assets/delete-min.sh

# create dist (src.zip) using wp
docker exec wordpress ./create-dist.sh

# on local machine, reinstall deps
# using dev mode
if [[ -z "${CI:-}" ]]; then
    rm -r src/vendor/ src/node_modules/
    unset CI_COMPOSER_NO_DEV
    unset CI_YARN_NO_DEV
    ./scripts/setup.sh
fi
