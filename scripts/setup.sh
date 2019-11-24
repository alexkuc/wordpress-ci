#!/bin/bash

# work around for Mac's issue with permisions on Docker's volumes
# see: https://github.com/moby/moby/issues/2259#issuecomment-556134161
ln -s /my-plugin /app/wp-content/plugins/
ln -s /my-theme /app/wp-content/themes/
