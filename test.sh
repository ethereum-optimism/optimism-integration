#!/bin/bash

set -eou pipefail

# PKGS are packages in the "integration-tests" repo.
# The name of the directory must match the package name
# with the "eth-optimism/" prefix.

PKGS=${PKGS:-""}
DOCKERFILE=docker-compose.yml

while (( "$#" )); do
  case "$1" in
    -p|--pkgs)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        PKGS="$2"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -l|--local)
      DOCKERFILE=docker-compose.local.yml
      shift 1
      ;;
    *)
      echo "Unknown argument $1" >&2
      shift
      ;;
  esac
done

DEPLOYER_TAG=${DEPLOYER_TAG:-latest}
BATCH_SUBMITTER_TAG=${BATCH_SUBMITTER_TAG:-latest}
GETH_L2_TAG=${GETH_L2_TAG:-latest}
L1_CHAIN_TAG=${L1_CHAIN_TAG:-latest}
INTEGRATION_TESTS_TAG=${INTEGRATION_TESTS_TAG:-latest}

# Replace slash with underscore in tags
DEPLOYER_TAG=$(echo $DEPLOYER_TAG | sed 's/\//_/g')
BATCH_SUBMITTER_TAG=$(echo $BATCH_SUBMITTER_TAG | sed 's/\//_/g')
GETH_L2_TAG=$(echo $GETH_L2_TAG | sed 's/\//_/g')
L1_CHAIN_TAG=$(echo $L1_CHAIN_TAG | sed 's/\//_/g')
INTEGRATION_TESTS_TAG=$(echo $INTEGRATION_TESTS_TAG | sed 's/\//_/g')

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

function run {
    cmd="docker-compose -f $DIR/$DOCKERFILE"
    if [ -f "$DIR/optional/$PKGS-service.yml" ]; then
        cmd="$cmd -f $DIR/optional/$PKGS-service.yml"
    fi
    cmd="$cmd up"
    cmd="$cmd --exit-code-from integration_tests"
    cmd="$cmd --abort-on-container-exit"

    PKGS=$PKGS \
    DEPLOYER_TAG=$DEPLOYER_TAG \
    BATCH_SUBMITTER_TAG=$BATCH_SUBMITTER_TAG \
    GETH_L2_TAG=$GETH_L2_TAG \
    L1_CHAIN_TAG=$L1_CHAIN_TAG \
    INTEGRATION_TESTS_TAG=$INTEGRATION_TESTS_TAG \
        $cmd
}

function clean {
    cmd="docker-compose -f $DOCKERFILE"
    if [ -f "$DIR/optional/$PKGS-service.yml" ]; then
        cmd="$cmd -f $DIR/optional/$PKGS-service.yml"
    fi
    cmd="$cmd down -v --remove-orphans"
    $cmd
}

if [ ! -z "$PKGS" ]; then
    clean
    run
else
    # The directory name must match the package name with @eth-optimism/ prefix
    for PACKAGE_PATH in $DIR/integration-tests/packages/*; do
        [ -e "$PACKAGE_PATH" ] || continue
        PKGS=$(basename $PACKAGE_PATH)
        echo "Running $PKGS test suite"

        clean
        run
    done
fi

