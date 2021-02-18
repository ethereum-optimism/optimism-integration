#!/bin/bash

# Start services without the integration tests
# The `-s` flag takes a string of services to run.
# The `-l` flag will use mounted code.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
DOCKERFILE="docker-compose.yml"
# run all of the services except for the integration_tests
SERVICES=$(docker-compose config --services \
    | grep -v integration_tests \
    | tr '\n' ' ')

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
    -f $DIR/$DOCKERFILE \
    -f $DIR/optional/x-domain-service.yml \
    down -v --remove-orphans

docker-compose \
    -f $DIR/$DOCKERFILE \
    -f $DIR/optional/x-domain-service.yml \
    up $SERVICES
