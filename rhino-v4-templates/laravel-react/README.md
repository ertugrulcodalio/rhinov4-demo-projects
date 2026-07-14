# rhino-v4-laravel-react

Rhino V4 project template — Laravel 13 API backend + React 19 frontend.

Includes the TaskFlow domain (Organizations, Projects, Tasks, Comments, Labels)
as working examples. Add your own models with `php artisan rhino:blueprint`.

## Stack

- **Backend:** Laravel 13 · PHP 8.3 · rhino-laravel 4.5 · SQLite (dev) · PHPUnit
- **Frontend:** React 19 · Vite · @rhino-dev/rhino-react · Tailwind

## First run

```bash
./start.sh setup      # install deps, generate key, migrate, seed
```

## Daily use

```bash
./start.sh api        # Laravel API → http://localhost:8000
./start.sh web        # React client → http://localhost:5173
./start.sh seed       # Fresh migrate + seed
```

## Seed credentials

| Email | Password | Org | Role |
|---|---|---|---|
| alice@acme.com | password | Acme Corp | admin |
| bob@acme.com | password | Acme Corp | manager |
| carol@acme.com | password | Acme Corp | member |
| dave@acme.com | password | Acme Corp | viewer |
| eve@globex.com | password | Globex Inc | admin |
