.PHONY: all integration-test deployer geth-l2 batch-submitter data-transport-layer test

all:
	./build-local.sh

docker:
	./docker/build.sh

integration-tests:
	./build-local.sh -s integration_tests

deployer:
	./build-local.sh -s deployer

geth-l2:
	./build-local.sh -s geth_l2

batch-submitter:
	./build-local.sh -s batch_submitter

data-transport-layer:
	./build-local.sh -s data_transport_layer

up: 
	./up.sh

# make up <package-name>
up %:
	./up.sh -l $@

test:
	./test.sh
