#!/bin/sh -ex

# Fly.io Dockerfile entrypoint (configured in fly.toml).
#
# With arguments, run them instead of the server. Fly passes `release_command`
# to this ENTRYPOINT as arguments (it replaces CMD only), so without this the
# release machine would start the web server and never run migrations.
if [ "$#" -gt 0 ]; then
  exec "$@"
fi

# NOTE: We call `node` directly instead of `pnpm run start` because the
# production Docker image does not include pnpm-workspace.yaml. Without it,
# pnpm cannot resolve the workspace and the server fails to start.

NODE_ENV=production exec node ./build/server/index.js
