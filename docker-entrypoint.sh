#!/usr/bin/env bash
set -e

SRC="${GNSSREFL_SRC_IN_CONTAINER:-/usr/src/gnssrefl}"

if [ -f "${SRC}/pyproject.toml" ]; then
  echo "Re-installing local gnssrefl from ${SRC} (no deps)..."
  pip install "${SRC}" --no-deps --no-build-isolation
else
  echo "WARNING: ${SRC}/pyproject.toml がないので gnssrefl の再インストールはスキップします"
fi

exec "$@"
