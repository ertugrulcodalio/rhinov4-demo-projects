#!/usr/bin/env bash
set -e

RBENV_RUBY="/Users/$(whoami)/.rbenv/versions/3.4.7"
BUNDLE_DIR="$RBENV_RUBY/project-gems"

export PATH="$RBENV_RUBY/bin:$PATH"
export BUNDLE_PATH="$BUNDLE_DIR"
export BUNDLE_BIN="$BUNDLE_DIR/bin"
unset GEM_HOME GEM_PATH RUBYOPT

cd "$(dirname "$0")"

case "${1:-help}" in
  api)
    bundle install --quiet
    PID_FILE="tmp/pids/server.pid"
    if [ -f "$PID_FILE" ]; then
      OLD_PID=$(cat "$PID_FILE"); kill "$OLD_PID" 2>/dev/null || true; rm -f "$PID_FILE"
    fi
    lsof -ti:"${PORT:-3000}" | xargs kill -9 2>/dev/null || true
    echo "Starting Rails API on port ${PORT:-3000}..."
    exec bundle exec rails server -p "${PORT:-3000}"
    ;;
  web)
    echo "Starting Vite frontend on port 5173..."
    cd client && exec npm run dev
    ;;
  seed)
    bundle install --quiet
    bundle exec rails db:seed
    ;;
  setup)
    bundle install
    bundle exec rails db:create db:migrate db:seed
    ;;
  *)
    echo "Usage: ./start.sh [api|web|seed|setup]"
    echo "  api   — start Rails API (port 3000)"
    echo "  web   — start Vite React client (port 5173)"
    echo "  seed  — seed the database"
    echo "  setup — install gems, create DB, migrate, seed (first run)"
    exit 1
    ;;
esac
