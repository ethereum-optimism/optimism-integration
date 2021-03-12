#!/bin/bash

# Start services without the integration tests
# The `-s` flag takes a string of services to run.
# The `-l` flag will use mounted code.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
SERVICES=
DOCKERFILE="docker-compose.yml"
IS_LOCAL=

while (( "$#" )); do
  case "$1" in
    -l|--local)
      IS_LOCAL=true
      LOCAL_SUBMODULES=$2
      shift 2
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

cmd="docker-compose \
    -f $DIR/$DOCKERFILE \
    -f $DIR/docker-compose.env.yml \
    -f $DIR/optional/x-domain-service.yml"

# docker compose down - to remove old containers and volumes
down="$cmd down -v --remove-orphans"
$down

# docker compose up - to spin up the full system
up="$cmd"
for i in $(echo $LOCAL_SUBMODULES | sed "s/,/ /g")
do
  dcfile=$DIR/optional/local/$i.local.yml
  if test -f "$dcfile"; then
    up="$up -f $dcfile"
  else
    echo "Error: Docker compose file $dcfile not found! Make sure your local submodule is specified correctly."
    exit 1
  fi
done
up="$up up $SERVICES"
$up
