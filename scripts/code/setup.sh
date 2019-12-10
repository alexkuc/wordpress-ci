#!/bin/bash
# credit goes to Van Eyck and David Pashley
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# see https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# install Composer depedencies if $CI is not defined or
# $CI and $COMPOSER is defined (to any value)
if [[ -z "${CI:-}" ]] || [[ -n "${CI:-}" && -n "${CI_COMPOSER:-}" ]]; then
    ./scripts/code/composer.sh 'test'
    ./scripts/code/composer.sh 'src'
fi

# run scripts/commands here to build assets locally
# e.g. ./scripts/code/bootstrap.sh or ./scripts/code/node.sh
# use scripts/code/local_or_docker_skeleton.sh if you need
# to invoke a binary which may not be present locally for
# extra portability of this local setup
