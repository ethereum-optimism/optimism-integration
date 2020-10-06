#!/bin/bash

# PKGS are packages in the "integration-tests" repo.
# The name of the directory must match the package name
# with the "eth-optimism/" prefix.


if [ ! -z "$PKGS" ]; then
    docker-compose -f docker-compose.local.yml rm -f
    docker volume ls \
        --filter='label=com.docker.compose.project=optimism-integration' \
        | xargs docker volume rm 2&>/dev/null

    PKGS=$PKGS \
        docker-compose -f docker-compose.local.yml \
            --env-file docker-compose.microservices.env \
            up \
            --exit-code-from integration_tests \
            --abort-on-container-exit
else
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

    for PACKAGE_PATH in $DIR/integration-tests/packages/*; do
        [ -e "$PACKAGE_PATH" ] || continue
        PKGS=$(basename $PACKAGE_PATH)
        echo "Running $PKGS test suite"

        docker-compose -f docker-compose.local.yml rm -f
        docker volume ls \
            --filter='label=com.docker.compose.project=optimism-integration' \
            | xargs docker volume rm 2&>/dev/null

        PKGS=$PKGS \
            docker-compose -f docker-compose.local.yml \
                --env_file docker-compose.microservices.env \
                up \
                --exit-code-from integration_tests \
                --abort-on-container-exit
    done
fi
