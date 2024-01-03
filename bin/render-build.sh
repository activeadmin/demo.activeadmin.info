#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
./bin/rails assets:precompile
./bin/rails assets:clean
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 ./bin/rails db:reset
