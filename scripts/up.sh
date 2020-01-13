#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# internal variables
COUNT=0 # counter
LOGS='' # logs string

# sanity check:
# make sure docker-machine is running (local environment)
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
# pull the latest images for Docker
docker-compose pull

echo 'Starting docker-compose in detached state...'
# start docker-compose in detached state
docker-compose up -d

echo 'Waiting for wordpress container to be ready...'

# wait until wordpress environment is ready
# check is done by scrubbing docker-compose logs every second
# for a string 'WordPress Configuration Complete!'
# loop includes counter to provide a user feedback
# time varies depedending on your specific implementation
until [[ -n "$LOGS" ]]
do
    sleep 1
    ((COUNT=COUNT+1))
    echo "Waiting for wordpress container to be ready... $COUNT"
    LOGS="$(docker-compose logs | grep -E ".*?WordPress Configuration Complete\!.*" || echo '')"
done
