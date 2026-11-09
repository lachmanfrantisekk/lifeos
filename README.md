# LifeOS
Private personal dashboard built with React + TypeScript + Vite and Cloudflare Workers + D1.

## Structure
- `frontend/` — React UI and PWA
- `worker/src/` — Cloudflare API with JWT verification
- `worker/migrations/` — D1 SQL migration
- `.github/workflows/deploy.yml` — GitHub Pages deployment
- `DEPLOY-CZ.md` — Czech deployment guide

## Local development
```bash
npm install
VITE_API_URL=https://your-api.example.com npm run dev -w frontend
```

See DEPLOY-CZ.md before deployment. API endpoints require a valid Cloudflare Access JWT and an allowlisted email. No API secrets belong in Vite variables.
