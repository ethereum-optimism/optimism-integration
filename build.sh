#!/bin/bash

SERVICES='geth_l2 postgres l1_chain microservices integration_tests'

GIT_MODULES=$(cat .gitmodules | grep path | cut -d '=' -f2 | tr -d ' ' | tr '\n' ' ')
echo "Building $GIT_MODULES"

docker-compose -f docker-compose.local.yml build $SERVICES
