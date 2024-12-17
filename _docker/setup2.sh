#!/bin/bash

CONTAINER_NAME="sphinx"

IS_RUNNING=$(docker inspect -f '{{.State.Running}}' $CONTAINER_NAME 2>/dev/null)
if [[ "$IS_RUNNING" == "true" ]]; then
    echo "Container $CONTAINER_NAME already running."
else
    echo "Container $CONTAINER_NAME not running. Run..."
    docker-compose start $CONTAINER_NAME
fi

docker-compose exec sphinx bash -c 'indexer --all --rotate --verbose || { echo "Indexer failed"; exit 1; }'


