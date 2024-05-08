#!/usr/bin/env bash

YAMFRPG_DOCKER_COMPOSE_FILE=docker-compose.yml

echo "Closing databases"
docker-compose -f ${YAMFRPG_DOCKER_COMPOSE_FILE} stop postgres
