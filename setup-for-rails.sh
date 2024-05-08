#!/usr/bin/env bash
cp /tmp/hosts /etc/hosts; /yamfrpg/wait-for-it.sh postgres:5432
bundle exec rails app:db:environment:set RAILS_ENV=development
