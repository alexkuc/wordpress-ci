#!/bin/bash
# credit goes to Van Eyck and David Pashley
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# see https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# internal variables
CODECEPT='vendor/bin/codecept' # path to codecept binary (WP-Browser)
CMD="cd /test && $CODECEPT build" # command to be executed

# re-run only failed tests
if [[ -e "test/tests/_output/failed" ]]; then
    echo ''
    echo "Detected 'failed' file..."
    echo 'Overriding user parameters...'
    echo 'Re-running failed tests...'
    echo ''
    echo "Hint: delete 'failed' file to stop this!"
    echo 'Path: test/tests/_output/failed'
    echo ''
    # override positional (user) parameters to run
    # 'codecept run -g failed', for more details see:
    # https://codeception.com/extensions#RunFailed
    set -- '-g' 'failed'
fi

# 'shellcheck' and 'phplint' is executed
# locally while in CI, docker image used
# refer to specific CI config for details
if [[ -z "${CI:-}" ]]; then
    ./scripts/lint/lint.sh
fi

# execute certain tests depending on supplied positional arguments
# all executions include "--debug" flag for extra verbosity
if [[ -n "${1:-}" && -n "${2:-}" ]]; then

    # not unsetting safe-guards will errounously blame this script/command if lint fails
    set +Eeuo pipefail
    trap - ERR
    # execute certain test(s) from a suite e.g. acceptance MyCept which is equivalent of
    # codecept run acceptance MyCept
    CMD="$CMD && $CODECEPT run $1 $2 --debug"

elif [[ -n "${1:-}" ]]; then

    # not unsetting safe-guards will errounously blame this script/command if lint fails
    set +Eeuo pipefail
    trap - ERR
    # execute certain suite e.g. acceptance which is equivalent of
    # codecept run acceptance
    CMD="$CMD && $CODECEPT run $1 --debug"

else

    # not unsetting safe-guards will errounously blame this script/command if lint fails
    set +Eeuo pipefail
    trap - ERR

    # execute *all* suites i.e. acceptance, functional, wpunit and unit
    # each suite has to be executed separate as per suggestions provided by WP-Browser:
    # https://wpbrowser.wptestkit.dev/summary/welcome/faq#can-i-run-all-my-tests-with-one-command
    CMD="$CMD && \
    $CODECEPT run acceptance --debug && \
    $CODECEPT run functional --debug && \
    $CODECEPT run wpunit --debug && \
    $CODECEPT run unit --debug"

fi

# pass command to Docker's container wordpress
docker exec wordpress bash -c "$CMD"

# reset certain variables in local environment
if [[ -z "${CI:-}" ]]; then
    # not unsetting safe-guards will errounously blame this script/command if lint fails
    set +Eeuo pipefail
    trap - ERR

    # When running tests locally, restore original value of the options siteurl and home
    docker exec wordpress bash -c "wp option update siteurl 'http://localhost:8080' --autoload=yes"
    docker exec wordpress bash -c "wp option update home 'http://localhost:8080' --autoload=yes"
fi
