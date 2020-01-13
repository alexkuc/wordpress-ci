#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# calculate checksum for src (theme)
. .semaphore/yarn/cache-checksum.sh

# restore cache for src (theme)
./.semaphore/cache.sh restore "$MY_THEME_NODE" 'src/node_modules/'
