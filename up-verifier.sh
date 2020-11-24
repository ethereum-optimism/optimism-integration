#!/bin/bash

DOCKERFILE='docker-compose.local.yml'
SERVICES="up deployer verifier l1_chain batch_submitter geth_l2"

while (( "$#" )); do
  case "$1" in
    -l|--local)
      DOCKERFILE="docker-compose.local.yml"
      shift 1
      ;;
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

docker-compose \
    -f $DOCKERFILE \
    -f optional/verifier-service.yml \
    -f optional/verifier-service.local.yml \
    down -v --remove-orphans

docker-compose \
    -f $DOCKERFILE \
    -f optional/verifier-service.yml \
    -f optional/verifier-service.local.yml \
    $SERVICES
