#!/bin/bash

# Start services without the integration tests
# The `-s` flag takes a string of services to run.
# The `-l` flag will use mounted code.

VERSION=$(docker-compose --version)
node -e "
const version = '$VERSION'.match(/([0-9]+)\.([0-9]+)\.([0-9]+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+[0-9A-Za-z-]+)?/);
if (version !== null) {
  if (version[2] < 27 || version[3] < 3) {
    console.log('Warning, update docker-compose')
  }
}"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
SERVICES=
DOCKERFILE="docker-compose.yml"
IS_LOCAL=

while (( "$#" )); do
  case "$1" in
    -l|--local)
      DOCKERFILE="docker-compose.local.yml"
      IS_LOCAL=true
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

# If the services haven't been specified, parse
# the docker-compose files for the services.
# Run everything except for the integration tests
if [ -z "$SERVICES" ]; then
    SERVICES=$(docker-compose \
        -f $DIR/$DOCKERFILE \
        -f $DIR/docker-compose.env.yml \
        -f $DIR/optional/x-domain-service.yml \
        config --services \
        | grep -v integration_tests \
        | tr '\n' ' ')
fi

if [ ! -z "$IS_LOCAL" ]; then
    git submodule foreach \
        '
            BRANCH=$(git branch --show-current)
            COMMIT=$(git rev-parse --short HEAD)
            echo "$BRANCH $COMMIT"
        '
fi

docker-compose \
    -f $DIR/$DOCKERFILE \
    -f $DIR/docker-compose.env.yml \
    -f $DIR/optional/x-domain-service.yml \
    down -v --remove-orphans

docker-compose \
    -f $DIR/$DOCKERFILE \
    -f $DIR/docker-compose.env.yml \
    -f $DIR/optional/x-domain-service.yml \
    up $SERVICES
