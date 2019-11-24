#!/bin/bash -e

trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

echo 'Cleaning up current docker-compose.yml...'
docker-compose down --volumes --remove-orphans
