#!/bin/bash

DOCKERFILE='docker-compose.local.yml'

docker-compose \
    -f $DOCKERFILE \
    -f optional/verifier-service.yml \
    -f optional/verifier-service.local.yml \
    rm -f -v

docker volume ls --format='{{.Name}}' | xargs docker volume rm 2&>/dev/null

docker-compose \
    -f $DOCKERFILE \
    -f optional/verifier-service.yml \
    -f optional/verifier-service.local.yml \
    up deployer verifier l1_chain batch_submitter geth_l2

