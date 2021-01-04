# Optimism Integration

A single repository intended to provide the ability to run a local
Optimistic Ethereum enviornment including both L1 & L2 chains. This
can be used to rapidly iterate over the many Optimism repositories and
run integration tests.

A single repository intended to provide the ability to rapidly iterate over
the many Optimism repositories and run integration tests.

## Usage
This package can be used to run tests, or even just spin up an easy-to-edit
optimism system.

```bash
# Git clone with submodules
$ git clone git@github.com:ethereum-optimism/optimism-integration.git --recurse-submodules

$ cd optimism-integration

# The `docker` submodule is a one stop shop for building containers
$ ./docker/build.sh

# Run tests
$ ./test.sh

# Run full system
$ ./up.sh
```

Submodules are updated automatically as commits land in `master` in the
respective repositories through a Github action.

The submodules can be updated with:

```bash
$ git submodule update
```

## Scripts

### up.sh

There are two ways to run `up.sh`.

#### Running with Published Docker Images

This is the recommended way to use this repository for building an application
on the Optimistic Ethereum protocol.

Docker images are built and automatically published to [Dockerhub](https://hub.docker.com/u/ethereumoptimism).
Docker will automaticaly use images found locally. To pull the latest images,
use the command:

```bash
$ docker-compose pull
```

To start all of the services, run the command:

```bash
$ ./up.sh
```

Particular Docker images can be used by specifying an environment variable at
runtime. `<service_name>_TAG` will be templated into the `docker-compose.yml`
files at runtime.

To run the docker image `ethereumoptimism/go-ethereum:myfeature`, use the
command:

```
$ GETH_L2_TAG=myfeature ./up.sh
```

This is helpful when making changes to multiple repositories and testing the
changes across the whole system. See the [docker](https://github.com/ethereum-optimism/docker)
repository for instructions on building custom images locally.

#### Running with Local Code

This is the recommended way to use this repository when developing the
Optimistic Ethereum protocol itself.

The submodules can be mounted in at runtime so that any changes to the
submodules can be observed in the context of the whole system.
Any compiled code must be built inside of a Docker container so that
it is compiled correctly. The `build-local.sh` script is used for this
purpose.

To build all local submodules, run the command:

```bash
$ ./build-local.sh
```

To compile only a specific service, the `-s` flag can be used. The possible
services can be found in the `docker-compose.build.yml` file.

To build only `go-ethereum`, run the command:

```bash
$ ./build-local.sh -s geth_l2
```

To specify using the submodules with `up.sh`, use the `-l` flag:

```bash
$ ./up.sh -1
```

### test.sh

To run all of the tests:

```bash
$ ./test.sh
```

This script is used to run each of the `integration-tests` test suites
against the whole system. Each package in the `integration-tests` repo
gets its own fresh state, meaning that the tests cannot run in parallel
unless each test suite has its own instances of each of the Optimistic
Ethereum services.

To run only a specific test suite:

```bash
$ ./test.sh -p tx-ingestion
```

The `-p` flag is used to set the `PKGS` environment variable and is
used to specify which test suite runs. The possible test suites are found
in the [integration tests](https://github.com/ethereum-optimism/integration-tests)
repository, in the `packages` directory.

Set `PKGS` to the package name to run a particular package. If `PKGS` is unset,
each test suite will run in sequence. The name of a test suite can be found
in its `package.json` as the `.name` property without the `@eth-optimism`
prefix. Note that the name must match the name of the directory containing
the test suite for the automation to work. If `PKGS` contains
multiple packages delimated by a comma, the results will be non-deterministic
and the tests should be expected to fail.

The `optional` directory contains additional service files that will be used
if the name of the test suite has a corresponding file
`optional/<test-suite>-service.yml`. This is useful for adding additional
services that are not required for all test suites.

