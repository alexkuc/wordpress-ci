#!/bin/bash -e

trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

CMD='cd /wp-browser && \
vendor/bin/codecept run acceptance && \
vendor/bin/codecept run functional && \
vendor/bin/codecept run wpunit && \
vendor/bin/codecept run unit'

docker exec wordpress bash -c "$CMD"
