#!/bin/bash

DOCKERFILE='docker-compose.local.yml'
SERVICES="deployer verifier l1_chain batch_submitter geth_l2 integration_tests"

while (( "$#" )); do
  case "$1" in
    -s|--services)
      SERVICES="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument $1" >&2
      shift
      ;;
  esac
done

# always use local
DOCKERFILE="docker-compose.local.yml"

docker-compose \
    -f $DOCKERFILE \
    -f optional/verifier-service.yml \
    -f optional/verifier-service.local.yml \
    down -v --remove-orphans

PKGS=x-domain \
docker-compose \
    -f $DOCKERFILE \
    -f optional/verifier-service.yml \
    -f optional/verifier-service.local.yml \
    up $SERVICES
