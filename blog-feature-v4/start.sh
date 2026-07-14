#!/usr/bin/env bash
set -e

RBENV_RUBY="/Users/ertugrulsahin/.rbenv/versions/3.4.7"
BUNDLE_DIR="$RBENV_RUBY/project-gems"

export PATH="$RBENV_RUBY/bin:$PATH"
export BUNDLE_PATH="$BUNDLE_DIR"
export BUNDLE_BIN="$BUNDLE_DIR/bin"
unset GEM_HOME GEM_PATH RUBYOPT

cd "$(dirname "$0")"

# Install gems isolated to Ruby 3.4.7 (recompiles native extensions for correct version)
bundle install --quiet

case "${1:-api}" in
  api)
    # Kill any stale server process from previous run
    PID_FILE="tmp/pids/server.pid"
    if [ -f "$PID_FILE" ]; then
      OLD_PID=$(cat "$PID_FILE")
      kill "$OLD_PID" 2>/dev/null || true
      rm -f "$PID_FILE"
    fi
    lsof -ti:"${PORT:-3012}" | xargs kill -9 2>/dev/null || true
    echo "Starting Rails API on port ${PORT:-3012}..."
    exec bundle exec rails server -p "${PORT:-3012}"
    ;;
  web)
    echo "Starting Vite frontend..."
    exec bash -c "cd client && npm run dev"
    ;;
  *)
    echo "Usage: ./start.sh [api|web]"
    exit 1
    ;;
esac
