# rhino-v4-rails-react

Rhino V4 project template — Rails 8 API backend + React 19 frontend.

Includes the TaskFlow domain (Organizations, Projects, Tasks, Comments, Labels)
as working examples. Add your own models with `bundle exec rails agentcode:blueprint`.

## Stack

- **Backend:** Rails 8.1 · rhino-rails 4.5 · SQLite (dev) · RSpec
- **Frontend:** React 19 · Vite · @rhino-dev/rhino-react · Tailwind

## First run

```bash
cp .env.example .env
./start.sh setup      # install gems, create DB, migrate, seed
```

## Daily use

```bash
./start.sh api        # Rails API → http://localhost:3000
./start.sh web        # React client → http://localhost:5173
./start.sh seed       # Re-seed database
```

## Seed credentials

| Email | Password | Org | Role |
|---|---|---|---|
| alice@acme.com | password | Acme Corp | admin |
| bob@acme.com | password | Acme Corp | manager |
| carol@acme.com | password | Acme Corp | member |
| dave@acme.com | password | Acme Corp | viewer |
| eve@globex.com | password | Globex Inc | admin |
