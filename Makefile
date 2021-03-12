.PHONY: all integration-tests deployer geth-l2 batch-submitter data-transport-layer test

SHELL := /bin/bash

all:
	@echo "Building in parallel in the background"
	./build-local.sh
	@while :; do [ $$(docker ps --format='{{.Image}}' | grep builder | wc -l) == 0 ] && exit 0; sleep 2; done;

up-local:
	./up.sh -l

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

# For developing against published docker images
up:
	./up.sh

test:
	./test.sh

test-%:
	./test.sh -p $@
