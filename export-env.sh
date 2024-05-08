#!/usr/bin/env bash

trap 'rm -f "$TMPFILE"' EXIT
TMPFILE=$(mktemp) || exit 1
grep -v '^#' .env | sed -e 's/\=.*//' | sed -e '/^[[:space:]]*$/d' >>${TMPFILE}

while read -r variable_name; do
  variable_value=$(printenv "${variable_name}")
  if [ "${variable_value}" = "" ]; then
    export $(grep "${variable_name}" .env | xargs)
  fi
done < ${TMPFILE}
