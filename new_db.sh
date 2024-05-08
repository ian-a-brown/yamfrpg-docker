#!/usr/bin/env bash

SHELL_DIR=`dirname "$0"`
YAMFRPG_DOCKER_COMPOSE_FILE=docker-compose.yml
#YAMFRPG_POSTGRES_DATA=`pwd`/yamfrpg-disks/postgres_data

#if [ ! -d ${YAMFRPG_POSTGRES_DATA} ]; then
#  mkdir ${YAMFRPG_POSTGRES_DATA}
#fi
#docker volume create \
#  --driver local \
#  --opt type=none \
#  --opt device=${YAMFRPG_POSTGRES_DATA} \
#  --opt o=bind \
#  postgres_data

${SHELL_DIR}/start_db.sh

${SHELL_DIR}/drop_db.sh --have-database
${SHELL_DIR}/create_db.sh --have-database
${SHELL_DIR}/migrate_db.sh --have-database
${SHELL_DIR}/load_data.sh --have-database

${SHELL_DIR}/stop_db.sh
