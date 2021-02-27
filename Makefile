.PHONY: all integration-tests deployer geth-l2 batch-submitter data-transport-layer test

all:
	@echo "Building all modules locally..."
	@echo "Use \`make <module-name>\` to build a specific module for saved time."
	@read -p "Continue with building all? [y/n]: " yn; \
	if [ $${yn} = "y" ]; then \
		./build-local.sh; \
	else \
		exit 1; \
	fi

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
