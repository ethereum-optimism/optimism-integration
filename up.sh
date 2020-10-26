#!/bin/bash

# Start the services without all of the microservices
# or running the integration tests

SERVICES='geth_l2 l1_chain batch_submitter'

docker-compose -f docker-compose.yml rm -f
docker volume ls \
    --filter='label=com.docker.compose.project=optimism-integration' \
    | xargs docker volume rm 2&>/dev/null

docker-compose -f docker-compose.yml \
  up $SERVICES
