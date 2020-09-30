# Optimism Integration
A single repository intended to provide the ability to rapidly iterate over
the many Optimism repositories.

## Usage
This package can be used to run tests, or even just spin up an easy-to-edit
fullnode.

```bash
# Git clone with submodules
$ git clone --recurse-submodules

# Build the submodules with docker-compose
# Optionally pass a single service to build
# Services are defined in docker-compose.local.yml
$ ./build.sh

# Run tests
$ ./test.sh
```
