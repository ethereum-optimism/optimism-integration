# Optimism Integration
A single repository intended to provide the ability to rapidly iterate over
the many Optimism repositories.

## Usage
This package can be used to run tests, or even just spin up an easy-to-edit
fullnode.

```bash
# Git clone with submodules
git clone --recurse-submodules xxxx

# Build the submodules with docker-compose
# TODO: This is currently broken
./build.sh

# Run tests
./test.sh

# Start a node
# TODO: Add this? Maybe?
./start-node.sh

# Inspect db with pg admin
# TODO: Add this!
./start-postgres.sh
```
