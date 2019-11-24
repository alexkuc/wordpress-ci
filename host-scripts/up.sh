#!/bin/bash -e

trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

COUNT=0

./host-scripts/docker-machine-start.sh

echo 'Pulling latest docker images...'
docker-compose pull

echo 'Starting docker-compose in detached state...'
docker-compose up -d

check_logs () {
    LOGS=$(docker-compose logs | grep -E ".*?WordPress Configuration Complete\!.*" || true)
}

echo 'Waiting for wordpress container to be ready...'

while [ -z "$LOGS" ]; do
    sleep 1
    ((COUNT=COUNT+1))
    echo "Waiting for wordpress container to be ready... $COUNT"
    check_logs
done
