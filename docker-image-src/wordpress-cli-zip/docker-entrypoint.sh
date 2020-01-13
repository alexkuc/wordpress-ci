#!/bin/bash
set -euo pipefail

# vanilla, taken from:
# https://github.com/docker-library/wordpress/blob/c63f536e5d24b474c93e6c4b8deeacf95a89eb64/php7.3/cli/docker-entrypoint.sh

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- wp "$@"
fi

# if our command is a valid wp-cli subcommand, let's invoke it through wp-cli instead
# (this allows for "docker run wordpress:cli help", etc)
if wp --path=/dev/null help "$1" > /dev/null 2>&1; then
    set -- wp "$@"
fi

exec "$@"
