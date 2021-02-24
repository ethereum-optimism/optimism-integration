#!/bin/bash

# Start services without the integration tests
# The `-s` flag takes a string of services to run.
# The `-l` flag will use mounted code.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
DOCKERFILE="docker-compose.yml"
SERVICES=$(docker-compose \
    -f $DIR/$DOCKERFILE \
    -f $DIR/docker-compose.env.yml \
    -f $DIR/optional/x-domain-service.yml \
    -f $DIR/optional/replica-service.yml \
    config --services \
    | grep -v integration_tests \
    | tr '\n' ' ')

docker-compose \
    -f $DIR/$DOCKERFILE \
    -f $DIR/docker-compose.env.yml \
    -f $DIR/optional/x-domain-service.yml \
    -f $DIR/optional/replica-service.yml \
    down -v --remove-orphans

docker-compose \
    -f $DIR/$DOCKERFILE \
    -f $DIR/docker-compose.env.yml \
    -f $DIR/optional/x-domain-service.yml \
    -f $DIR/optional/replica-service.yml \
    up $SERVICES
