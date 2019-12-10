#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# work around for Mac's issue with permisions on Docker's volumes
# see: https://github.com/moby/moby/issues/2259#issuecomment-556134161
ln -s /src /app/wp-content/themes/
