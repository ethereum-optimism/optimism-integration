#!/bin/bash

git pull --recurse-submodules
git submodule update
docker-compose pull
