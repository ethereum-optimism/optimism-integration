#!/bin/bash

# Start services without the integration tests
# The `-s` flag takes a string of services to run.
# The `-l` flag will use mounted code.

SERVICES='geth_l2 l1_chain batch_submitter deployer'
DOCKERFILE="docker-compose.yml"

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

docker-compose -f $DOCKERFILE down -v --remove-orphans
docker-compose -f $DOCKERFILE \
  up $SERVICES
