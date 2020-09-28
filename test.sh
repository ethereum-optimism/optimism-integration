#!/bin/bash

USAGE="
./test.sh

CLI Arguments:
  -r|--rebuild    - rebuild the images
"

REBUILD=""

while (( "$#" )); do
  case "$1" in
    -r|--rebuild)
        REBUILD=1
        shift
      ;;
    -h|--help)
        echo $USAGE
        exit 0
    esac
done

docker-compose -f docker-compose.local.yml rm -f

sleep 1

REBUILD=$REBUILD \
    docker-compose -f docker-compose.local.yml \
        up \
        --exit-code-from integration_tests \
        --abort-on-container-exit
