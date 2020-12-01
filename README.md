# Optimism Integration
A single repository intended to provide the ability to rapidly iterate over
the many Optimism repositories and run integration tests.

## Usage
This package can be used to run tests, or even just spin up an easy-to-edit
optimism system.

```bash
# Git clone with submodules
$ git clone git@github.com:ethereum-optimism/optimism-integration.git --recurse-submodules

# The `docker` submodule is a one stop shop for building containers
$ ./docker/build.sh

# Run tests
$ ./test.sh
```

Submodules are updated automatically as commits land in `master`.
The submodules can be updated with:

```bash
$ git submodule update
```

## Scripts

### up.sh
There are two ways to run `up.sh`:

The first is using the images published to Dockerhub. This is the recommended way to spin everything up, especially if you're not changing any submodules. To pull the latest images, run 
```bash
$ docker-compose pull
```
Then run:
```bash
$ ./up.sh
```
The second way is to build images from your local submodules. This is recommened if you are locally changing submodules (e.g. testing local changes to geth). To get this set up the first time, run 
```bash
$ ./build-local
```
Then as you make changes to your local submodules (e.g. to `go-ethereum`), then make sure to build those specific services:
```bash
$ ./build-local -s geth_l2
```
Then add the `-l` flag to run: 
```bash
$ ./up.sh -1
```




### test.sh

Runs the containers against each test suite defined in the `integration-tests`
repo. Each package gets its own fresh state. Use the `PKGS` environment variable
to specify a single package to use. The package names can be found in the
`package.json` as the `name` property`, not including the `@eth-optimism` prefix.
The package name must match the name of the directory that contains the package.
These test suites cannot currently be ran in parallel, so if `PKGS` contains
multiple packages delimated by a comma, the results will be non-deterministic
and the tests should fail.

