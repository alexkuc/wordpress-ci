#!/bin/bash -e

trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

CMD='cd /wp-browser'

if [ -n "$1" ] && [ -n "$2" ]; then
    CMD="$CMD && vendor/bin/codecept run $1 $2 --debug"
else
    # each suite has to be executed separate as per suggestions provided by WP-Browser:
    # https://wpbrowser.wptestkit.dev/summary/welcome/faq#can-i-run-all-my-tests-with-one-command
    CMD="$CMD && \
    vendor/bin/codecept run acceptance --debug && \
    vendor/bin/codecept run functional --debug && \
    vendor/bin/codecept run wpunit --debug && \
    vendor/bin/codecept run unit --debug"
fi

docker exec wordpress bash -c "$CMD"
