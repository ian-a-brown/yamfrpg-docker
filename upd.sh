#!/usr/bin/env bash

YAMFRPG_DOCKER_COMPOSE_FILE=docker-compose.yml

docker-compose -f ${YAMFRPG_DOCKER_COMPOSE_FILE} up -d $1
