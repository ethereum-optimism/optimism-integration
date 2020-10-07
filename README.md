# Optimism Integration
A single repository intended to provide the ability to rapidly iterate over
the many Optimism repositories.

## Usage
This package can be used to run tests, or even just spin up an easy-to-edit
optimism system.

```bash
# Git clone with submodules
$ git clone git@github.com:ethereum-optimism/optimism-integration.git --recurse-submodules

# Build the submodules with docker-compose
# Optionally pass a single service to build
# Services are defined in docker-compose.local.yml
$ ./build.sh

# Run tests
$ ./test.sh
```

Submodules are updated automatically as commits land in `master`.
The submodules can be updated with:

```bash
$ git submodule update
```

## Scripts

### build.sh

Builds the docker services in a container. Can specify the name of a service
as the first argument and only that service will be built.

### test.sh

Runs the containers against each test suite defined in the `integration-tests`
repo. Each package gets its own fresh state. Use the `PKGS` environment variable
to specify a single package to use. The package names can be found in the
`package.json` as the `name` property`, not including the `@eth-optimism` prefix.
The package name must match the name of the directory that contains the package.
These test suites cannot currently be ran in parallel, so if `PKGS` contains
multiple packages delimated by a comma, the results will be non-deterministic
and the tests should fail.

### postgres.sh

Runs the postgres docker images with the docker volume mounted in so that the
data can be observed with a tool such a `pgadmin` or `psql`.

