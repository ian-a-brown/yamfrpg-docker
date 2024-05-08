#!/usr/bin/env bash

SHELL_DIR=`dirname "$0"`
YAMFRPG_DOCKER_COMPOSE_FILE=docker-compose.yml
YAMFRPG_DATA_FOLDER=${YAMFRPG_DATA_FOLDER:-/yamfprg-data}

# We'll eventually want to look for data files in the folder. These will be YAML files that can be loaded by rails tasks.
echo "No data to load"
