.NOTPARALLEL:

SHELL = /usr/bin/env bash
DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

build:
	${DIR}/export-env.sh; ${DIR}/build.sh

create_db:
	${DIR}/export-env.sh; ${DIR}/create_db.sh

down:
	${DIR}/export-env.sh; ${DIR}/down.sh

drop_db:
	${DIR}/export-env.sh; ${DIR}/drop_db.sh

engine_shell:
	${DIR}/export-env.sh; ${DIR}/shell.sh engine

api_shell:
	${DIR}/export-env.sh; ${DIR}/shell.sh api
\
load_data:
	${DIR}/export-env.sh; ${DIR}/load_data.sh

migrate_db:
	${DIR}/export-env.sh; ${DIR}/migrate_db.sh

new_db:
	${DIR}/export-env.sh; ${DIR}/new_db.sh

postgres:
	${DIR}/export-env.sh; ${DIR}/upd.sh postgres

prepare_test_db:
	${DIR}/export-env.sh; ${DIR}/prepare_test_db.sh

prune:
	docker system prune

start_db:
	${DIR}/export-env.sh; ${DIR}/start_db.sh

stop_db:
	${DIR}/export-env.sh; ${DIR}/stop_db.sh
