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
CLI Arguments:
  -s|--service   - service to build
  -h|--help      - help message
"

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

if [ -z $SERVICE ]; then
    echo "Please select service to build"
    exit 1
fi

docker-compose -f docker-compose.build.yml up $SERVICE
