#!/bin/bash

# build-local.sh - build inside docker image
# for local development
# Copyright 2020 Optimism PBC
# MIT License

# This script uses docker-compose to manage the different
# commands and entrypoints for building the different services.
# The possible services are in docker-compose.local.yml

USAGE="
$ ./scripts/build-local.sh
Build docker images from git branches.
All images will be built if no service
is specificed.

CLI Arguments:
  -s|--service   - service to build
  -h|--help      - help message
"

# These services are defined in the `docker-compose.build.yml`
SERVICES="geth_l2
batch_submitter
integration_tests"
SERVICE=""

while (( "$#" )); do
  case "$1" in
    -s|--service)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        SERVICE="$2"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -h|--help)
      echo "$USAGE"
      exit 0
      ;;
    *)
      echo "Unknown argument $1" >&2
      shift
      ;;
  esac
done

docker-compose -f docker-compose.build.yml down -v --remove-orphans

if [ -z $SERVICE ]; then
    for SERVICE in $SERVICES; do
      docker-compose -f docker-compose.build.yml up $SERVICE
    done
else
    docker-compose -f docker-compose.build.yml up $SERVICE
fi
