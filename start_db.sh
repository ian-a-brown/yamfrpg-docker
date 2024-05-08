#!/usr/bin/env bash

YAMFRPG_DOCKER_COMPOSE_FILE=docker-compose.yml

echo "Starting databases"
docker-compose -f ${YAMFRPG_DOCKER_COMPOSE_FILE} up -d postgres
