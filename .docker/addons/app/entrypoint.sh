#!/bin/bash
set -e

if [ -f package.json ]; then
  npm install --no-audit --no-fund
  exec npm run dev -- --host 0.0.0.0 --port 5173
fi

exec tail -f /dev/null
