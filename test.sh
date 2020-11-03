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

function run {
    PKGS=$PKGS \
    DEPLOYER_TAG=$DEPLOYER_TAG \
    BATCH_SUBMITTER_TAG=$BATCH_SUBMITTER_TAG \
    GETH_L2_TAG=$GETH_L2_TAG \
    L1_CHAIN_TAG=$L1_CHAIN_TAG \
    INTEGRATION_TESTS_TAG=$INTEGRATION_TESTS_TAG \
        docker-compose -f $DOCKERFILE \
            up \
            --exit-code-from integration_tests \
            --abort-on-container-exit
}

if [ ! -z "$PKGS" ]; then
    docker-compose -f $DOCKERFILE down -v --remove-orphans
    run
else
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

    # The directory name must match the package name with @eth-optimism/ prefix
    for PACKAGE_PATH in $DIR/integration-tests/packages/*; do
        [ -e "$PACKAGE_PATH" ] || continue
        PKGS=$(basename $PACKAGE_PATH)
        echo "Running $PKGS test suite"

        docker-compose -f $DOCKERFILE down -v --remove-orphans
        run
    done
fi

