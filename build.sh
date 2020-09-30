#!/bin/bash

# Builds each of the services inside of a container with the artifacts
# remaining on the host system to prevent the need to rebuild in the future.

SERVICES="geth_l2 postgres l1_chain microservices integration_tests"
NEED_COMPILE="geth_l2 microservices integration_tests"

PROJECT_LABEL="com.docker.compose.project=optimism-integration"
COMPOSE_SERVICE_LABEL_KEY="com.docker.compose.service"

# assign the first argument to ARGS
ARGS=$1

# if an argument was not passed
if [ ! -z $ARGS ]; then
    # only build/fetch the argument passed in
    NEED_COMPILE="$ARGS"

    # validate the argument
    if [ -z $(echo $ARGS | grep -E 'geth_l2|microservices|integration_tests') ]; then
        echo "Unknown build target: $ARGS"
        exit 1
    fi
fi

# build the runtime containers
for SERVICE in $SERVICES; do
    HAS_SERVICE=$(docker images \
        --filter "label=$PROJECT_LABEL" \
        --filter "label=$COMPOSE_SERVICE_LABEL_KEY=$SERVICE" \
        --format='{{.ID}}')

    if [ -z $HAS_SERVICE ]; then
        docker-compose -f docker-compose.local.yml build "$SERVICE"
    fi
done

# fetch the dependencies and compile the code
REBUILD=1 \
FETCH_DEPS=1 \
    docker-compose \
        -f docker-compose.local.yml \
        up $NEED_COMPILE
