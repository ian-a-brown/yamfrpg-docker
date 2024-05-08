#!/usr/bin/env bash

SHELL_DIR=`dirname "$0"`
YAMFRPG_DOCKER_COMPOSE_FILE=docker-compose.yml

if [ $# -eq 0 ]; then
  ${SHELL_DIR}/start_db.sh
fi

docker-compose -f ${YAMFRPG_DOCKER_COMPOSE_FILE} \
  run -T --no-deps --rm engine bash --login -c "/yamfrpg/setup-for-rails.sh; bundle exec rails db:migrate; bundle exec rails db:test:prepare"

if [ $# -eq 0 ]; then
  ${SHELL_DIR}/stop_db.sh
fi
