#!/bin/bash

docker-compose -f docker-compose.local.yml rm -f

docker volume ls \
    --filter='label=com.docker.compose.project=optimism-integration' \
    | xargs docker volume rm 2&>/dev/null

docker-compose -f docker-compose.local.yml up \
    --exit-code-from integration_tests \
    --abort-on-container-exit
