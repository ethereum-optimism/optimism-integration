#!/bin/bash

# Start services without the integration tests
# The `-s` flag takes a string of services to run.
# The `-l` flag will use mounted code.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
SERVICES='geth_l2 l1_chain batch_submitter deployer message_relayer data_transport_layer'
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


function branch() {
    BRANCH=$(git --git-dir $DIR/$1 branch --show-current)
    COMMIT=$(git --git-dir $DIR/$1 rev-parse --short HEAD)
    echo "$1 $BRANCH $COMMIT"
}

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
