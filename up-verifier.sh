#!/bin/bash

DOCKERFILE='docker-compose.yml'
SERVICES='deployer verifier l1_chain batch_submitter geth_l2'
LOCAL_VERIFIER=

while (( "$#" )); do
  case "$1" in
    -l|--local)
      DOCKERFILE="docker-compose.local.yml"
      LOCAL_VERIFIER=true
      shift 1
      ;;
    --local-sequencer)
      DOCKERFILE="docker-compose.local.yml"
      shift 1
      ;;
    --local-verifier)
      LOCAL_VERIFIER=true
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

dcmd="docker-compose"
dcmd="$dcmd -f $DOCKERFILE"
dcmd="$dcmd -f optional/verifier-service.yml"
if [ ! -z $LOCAL_VERIFIER ]; then
    dcmd="$dcmd -f optional/verifier-service.local.yml"
fi
dcmd="$dcmd down -v --remove-orphans"
$dcmd

cmd="docker-compose"
cmd="$cmd -f $DOCKERFILE"
cmd="$cmd -f optional/verifier-service.yml"
if [ ! -z $LOCAL_VERIFIER ]; then
    cmd="$cmd -f optional/verifier-service.local.yml"
fi
cmd="$cmd up $SERVICES"
exec $cmd
