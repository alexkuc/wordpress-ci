#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# work around for Mac's issue with permisions on Docker's volumes
# see: https://github.com/moby/moby/issues/2259#issuecomment-556134161
ln -s /src /app/wp-content/themes/

# create symlink inside wordpress to container to allow shorter path
# e.g. 'docker exec wordpress ./create-dist.sh' assuming workdir is
# '/app'
ln -s /app/wp-content/themes/src/create-dist.sh /app/create-dist.sh
