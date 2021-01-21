#!/usr/bin/env bash

ORIG_DIR="$(pwd)"
cd "$(dirname "$0")"
BIN_DIR="$(pwd)"

trap "cd '${ORIG_DIR}'" EXIT

# docker run --rm -p 9999:8080 plantuml/plantuml-server:jetty

if [ "$1" = "down" ]
then
  docker-compose down
else
  echo "Running plantuml..."
  docker-compose pull
  docker-compose up -d
fi
