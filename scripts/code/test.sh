#!/bin/bash
# credit goes to Van Eyck and David Pashley
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# see https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

CODECEPT='vendor/bin/codecept'

CMD="cd /wp-browser && $CODECEPT build"

# 'shellcheck' and 'phplint' is executed
# locally while in CI, docker image used
# refer to specific CI config for details
if [[ -z "${CI:-}" ]]; then
    ./scripts/code/lint.sh
fi

if [[ -n "${1:-}" && -n "${2:-}" ]]; then
    CMD="$CMD && $CODECEPT run $1 $2 --debug"
elif [[ -n "${1:-}" ]]; then
    CMD="$CMD && $CODECEPT run $1 --debug"
else
    # each suite has to be executed separate as per suggestions provided by WP-Browser:
    # https://wpbrowser.wptestkit.dev/summary/welcome/faq#can-i-run-all-my-tests-with-one-command
    CMD="$CMD && \
    $CODECEPT run acceptance --debug && \
    $CODECEPT run functional --debug && \
    $CODECEPT run wpunit --debug && \
    $CODECEPT run unit --debug"
fi

docker exec wordpress bash -c "$CMD"

if [[ -z "${CI:-}" ]]; then
    # When running tests locally, restore original value of the options siteurl and home
    docker exec wordpress bash -c "wp option update siteurl 'http://localhost:8080' --autoload=yes"
    docker exec wordpress bash -c "wp option update home 'http://localhost:8080' --autoload=yes"
fi
