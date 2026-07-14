#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

case "${1:-help}" in
  api)
    echo "Starting Laravel API on port ${PORT:-8000}..."
    exec php artisan serve --port="${PORT:-8000}"
    ;;
  web)
    echo "Starting Vite frontend on port 5173..."
    cd client && exec npm run dev
    ;;
  seed)
    php artisan migrate:fresh --seed
    ;;
  setup)
    composer install
    cp -n .env.example .env || true
    php artisan key:generate
    php artisan migrate:fresh --seed
    ;;
  *)
    echo "Usage: ./start.sh [api|web|seed|setup]"
    echo "  api   — start Laravel API (port 8000)"
    echo "  web   — start Vite React client (port 5173)"
    echo "  seed  — fresh migrate + seed"
    echo "  setup — install deps, generate key, migrate, seed (first run)"
    exit 1
    ;;
esac
