#!/bin/bash

# Start the services without all of the microservices
# or running the integration tests

SERVICES='geth_l2 postgres l1_chain microservices'

docker-compose -f docker-compose.local.yml rm -f
docker volume ls \
    --filter='label=com.docker.compose.project=optimism-integration' \
    | xargs docker volume rm 2&>/dev/null

docker-compose -f docker-compose.local.yml \
  up $SERVICES
