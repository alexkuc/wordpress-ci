#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

COUNT=0
LOGS=''

if [[ -z "${CI:-}" && -z "${DOCKER_HOST:-}" ]]; then
    echo ''
    # shellcheck disable=SC2016
    echo 'Variables $DOCKER_HOST is empty...'
    echo ''
    echo 'Did you forget to source docker-machine-start.sh?'
    echo ''
    echo 'Example: . scripts/docker-machine-start.sh'
    echo 'Example: source scripts/docker-machine-start.sh'
    echo ''

    exit 1
fi

echo 'Pulling latest docker images...'
docker-compose pull

echo 'Starting docker-compose in detached state...'
docker-compose up -d

echo 'Waiting for wordpress container to be ready...'

until [[ -n "$LOGS" ]]
do
    sleep 1
    ((COUNT=COUNT+1))
    echo "Waiting for wordpress container to be ready... $COUNT"
    LOGS="$(docker-compose logs | grep -E ".*?WordPress Configuration Complete\!.*" || echo '')"
done