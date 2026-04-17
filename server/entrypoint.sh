#!/usr/bin/env sh

HOST=${LUNAR_HOST:-127.0.0.1}
PORT=${LUNAR_HTTP_PORT:-8080}
SCENE=${LUNAR_SCENE:-0}

exec ./lunar-tear --host "$HOST" --http-port "$PORT" --scene "$SCENE" "$@"