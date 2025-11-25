#!/usr/bin/env bash
set -e

# stop gnssrefl-dev (ok if gnss-dev does not exist)
docker compose stop gnssrefl-dev || true

# remove gnssrefl-dev container (ok if gnss-dev does not exist)
docker compose rm -f gnssrefl-dev || true

# restart
docker compose up gnssrefl-dev
