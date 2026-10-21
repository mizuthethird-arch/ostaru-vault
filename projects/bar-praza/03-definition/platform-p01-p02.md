# Platform spec: repository and CI (P-01, P-02), v2
- Date: 2026-10-22 (v1: 2026-10-21)
- Owner: PROMETHEUS (Platform/DevOps Lead). Reviewer: CTO (ATHENA). P-02 is shared with JANUS.
- Status: **PROPOSED, IMPLEMENTED—NOT VERIFIED.** Everything below is config and code "written, not run" (Rule 9). The owner runs it.
- Basis: [ADR-006](adr/ADR-006-technology-stack-v2.md) (accepted; supersedes ADR-002), [ADR-003](adr/ADR-003-multi-tenancy.md) (accepted), [ADR-005](adr/ADR-005-file-storage.md), [ATHENA handoff](../handoffs/2026-10-21-ATHENA-to-PROMETHEUS-stack-v2.md).
- Items: P-01 and P-02 in the [backlog](../04-planning/backlog.md) and [Cycle 1](../04-planning/cycles/cycle-01.md).
- Labels: **[V]** decided, **[A]** assumption, **[E]** estimate.

## 1. What changed from v1
| Topic | v1 (ADR-002) | v2 (ADR-006) |
|---|---|---|
| Package manager | pnpm | **npm workspaces**, `npm ci` in CI and Docker |
| API | NestJS | **Express** (module rule enforced by P-02) |
| Styling | not set | **Tailwind CSS** in the dashboard |
| Real time | NestJS gateways | Socket.IO, added with F6 (not in P-01) |
| Images | built in CI only | built in CI, pushed to **GitHub Container Registry** from `main` |
| Approvals | ADR-002 assumed approved | ADR-003 and ADR-006 are approved [V]; ADR-002 is superseded |

## 2. Owner checklist (CEO / Sponsor, Rule 9: the owner runs everything)
1. Create the **private** GitHub repository `ostaru-agora` (name confirmed by the CEO, 2026-10-22 [V]; it is the real product repository, not a test repo).
2. Create the files in section 9, then run the install commands there **inside the Docker workspace, never on your PC** (Sponsor rule, 2026-10-22). This writes `package-lock.json`; commit it.
3. **Pin versions from official release pages:** Node.js LTS (nodejs.org release schedule) into `.nvmrc` and the Dockerfiles; the PostgreSQL major (postgresql.org versioning policy) into `docker-compose.yml`; GitHub Action versions (each action's releases page).
4. Run `cp .env.example .env`, then `docker compose run --rm workspace npm run format`, `docker compose run --rm workspace npm run check` and `docker compose up --build`. Send the output of any failure to PROMETHEUS.
5. Push to GitHub and make sure **Actions are enabled**. The `publish-images` job needs no secret; it uses the built-in token with `packages: write`.
6. Settings → Branches: protect `main` and require the checks `verify` and `compose-smoke` (gate G5).
7. Commit as the CEO (Q2: code in chat, the CEO commits).
No other secret is needed in Cycle 1. Real secrets (production) go to a secrets system chosen later, never to the vault.

## 3. Repository layout
```
ostaru-agora/
├── apps/api/            Express; business modules in src/modules/<name>/
├── apps/dashboard/      React + Vite + Tailwind; nginx in the container
├── packages/shared/     types only for now (HealthStatus; FileStorage later, ADR-005)
├── .github/workflows/ci.yml
├── docker-compose.yml   db (PostgreSQL), api, dashboard
└── package.json (workspaces), tsconfig.base.json, eslint.config.mjs, .prettierrc, .nvmrc, .env.example
```
- `packages/ui` is **not** created in P-01. UI-01 creates it; the `packages/*` workspace glob picks it up. When it exists, add it to the `build` script order and to the Dockerfile `COPY` lines.
- `minio` joins Compose with F2-05 (ADR-005, Cycle 2 [E]). Not in P-01.
- The API does not connect to PostgreSQL yet; data access waits for [ADR-004](adr/ADR-004-data-access.md) Part B. Compose already provides the database and `DATABASE_URL`.
- Compose builds production-style images, one per app. **Nothing is installed on the owner's PC** (Sponsor rule, 2026-10-22): only Docker and git are needed. Every `npm` command runs in the `workspace` service (`docker compose run --rm workspace <command>`), and `node_modules` lives in a Docker volume, not on the host.

## 4. CI (GitHub Actions)
- Runs on every pull request and on pushes to `main`. Read-only token by default. Older runs of the same ref are cancelled.
- `verify`: `npm ci`, `npm run lint`, `npm run format:check`, `npm run build` (includes `tsc` type checks), `npm test` (includes the architecture test).
- `compose-smoke`: `docker compose up --build --wait`, then `curl` of `/api/health` through the dashboard, then `down -v`. This checks the P-01 acceptance criterion.
- `publish-images`: only on `main`, after both jobs pass. Pushes `api` and `dashboard` images to `ghcr.io/<owner>/ostaru-agora/*`, tagged with the commit SHA and `main`. **Nothing is deployed**; Hostinger comes much later.
- Not in P-01: Playwright end-to-end, Storybook build (UI-01), dependency and image scanning (propose to EUNOMIA/JUPITER at G3).

## 5. P-02: module boundary rule
- `apps/api/src/modules/<module>/index.ts` is the **only** file other modules may import. Everything else in the module is internal.
- `src/shared-kernel/` must not import from `modules/`.
- Enforced by `dependency-cruiser` inside a Vitest test, so a violation fails `npm test` and CI. With Express this is the only enforcement (ADR-006), so it is mandatory.
- Tests prove: legal import passes, internal import fails, kernel-to-module import fails, real `src` is clean.
- JANUS confirms the layout through the [handoff](../handoffs/2026-10-21-PROMETHEUS-to-JANUS.md). Until a real module exists, the "real source" test passes trivially.

## 6. Acceptance mapping
| Criterion | Where |
|---|---|
| `docker compose up` starts API, dashboard and database | `docker-compose.yml`, checked by `compose-smoke` |
| CI runs lint and all tests on every change | `verify` |
| CI green on a sample test | `apps/api/test/health.test.ts`, `apps/dashboard/src/App.test.tsx` |
| Build fails on a forbidden import | `apps/api/test/architecture/module-boundaries.test.ts` |

## 7. Risks
- Config for ESLint 9 flat config, Vitest, dependency-cruiser, Tailwind 4 and Docker was written without running it. Expect small fixes on the first run.
- `npm prune` in the API Dockerfile removes dev dependencies for the whole workspace, so the runtime image carries the dashboard's runtime packages too (harmless, a little larger).
- Actions are referenced by major tag. Pinning to commit hashes is later hardening.
- Cost of CI: GitHub Actions minutes and GHCR storage for a private repo, small at this scale [E].

## 8. Hostinger: online research, not a decision
Sources: [Hostinger VPS hosting](https://www.hostinger.com/vps-hosting.md), [Hostinger Docker hosting](https://hostinger.com/docker-hosting), read 2026-10-22. Prices in USD, excluding VAT, paid upfront, "indicative".
1. Product: **VPS (KVM)**. Shared web hosting is not suitable for Docker Compose.
2. Docker Compose: the VPS offers **Docker Manager**, which deploys from a Compose file or a Git repository URL, plus an Ubuntu 24.04 with Docker template and a Traefik template for HTTPS.
3. EU region: the pages say "data centers across North America, Europe, Asia and South America" but **list no EU country**. To confirm in the order flow before buying.
4. Backups: **free automatic weekly backups and manual snapshots**. No daily backups mentioned. Worst-case loss is about a week, so a nightly `pg_dump` to separate storage is needed for order data [A].
5. KVM 1: 1 vCPU, 4 GB RAM, 50 GB NVMe, $6.49/month promo (24-month term), $11.99/month renewal.
6. KVM 2: 2 vCPU, 8 GB RAM, 100 GB NVMe, about $8.79–8.99/month promo, $14.99/month renewal.
7. Terms of 1, 12 or 24 months, paid upfront; 30-day money-back guarantee.
8. Sizing [E]: API, dashboard, PostgreSQL and MinIO for one restaurant probably fit KVM 2; KVM 1 is tight with 4 GB.
9. Unknown: whether raw YAML can be pasted in Docker Manager, firewall and managed database options, GDPR data-processing terms.
10. Not a decision: provider is [V] Hostinger, the product, region and plan stay open until hosting is scheduled.

## 9. Files (complete, written not run)

### Install commands (run after creating the files and `.env`, from the repository root)
```bash
docker compose run --rm workspace npm install --save-exact -D typescript eslint @eslint/js typescript-eslint globals prettier
docker compose run --rm workspace npm install --save-exact -w @agora/api express
docker compose run --rm workspace npm install --save-exact -D -w @agora/api @types/express @types/node tsx vitest supertest @types/supertest dependency-cruiser typescript
docker compose run --rm workspace npm install --save-exact -w @agora/dashboard react react-dom
docker compose run --rm workspace npm install --save-exact -D -w @agora/dashboard typescript vite vitest @vitejs/plugin-react jsdom @testing-library/react @types/react @types/react-dom tailwindcss @tailwindcss/vite
```

### Root
`package.json`
```json
{
  "name": "ostaru-agora",
  "private": true,
  "workspaces": ["apps/*", "packages/*"],
  "scripts": {
    "lint": "eslint .",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "build": "npm run build -w @agora/shared && npm run build -w @agora/api && npm run build -w @agora/dashboard",
    "test": "npm test --workspaces --if-present",
    "check": "npm run lint && npm run format:check && npm run build && npm test"
  }
}
```
`.nvmrc` → current Node LTS (owner pins). `.prettierrc` → `{ "singleQuote": true }`. `.prettierignore` → `node_modules`, `dist`, `package-lock.json`.

`tsconfig.base.json`
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  }
}
```
`eslint.config.mjs`
```js
import js from '@eslint/js';
import tseslint from 'typescript-eslint';
import globals from 'globals';

export default [
  { ignores: ['**/dist/**', '**/node_modules/**', 'apps/api/test/architecture/fixtures/**'] },
  js.configs.recommended,
  ...tseslint.configs.recommended,
  { languageOptions: { globals: { ...globals.node, ...globals.browser } } },
];
```
`.gitignore` → `node_modules`, `dist`, `.env`. `.dockerignore` → `**/node_modules`, `**/dist`, `.git`, `.env`.

`.env.example` (local development only)
```
POSTGRES_USER=agora
POSTGRES_PASSWORD=change-me-local-only
POSTGRES_DB=agora
```
`docker-compose.yml` (set the PostgreSQL major from the official page)
```yaml
name: agora
services:
  db:
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-agora}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:?copy .env.example to .env}
      POSTGRES_DB: ${POSTGRES_DB:-agora}
    volumes:
      - db-data:/var/lib/postgresql/data
    ports:
      - "127.0.0.1:5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-agora} -d ${POSTGRES_DB:-agora}"]
      interval: 5s
      timeout: 3s
      retries: 10

  api:
    build:
      context: .
      dockerfile: apps/api/Dockerfile
    environment:
      PORT: "3000"
      DATABASE_URL: postgres://${POSTGRES_USER:-agora}:${POSTGRES_PASSWORD}@db:5432/${POSTGRES_DB:-agora}
    depends_on:
      db:
        condition: service_healthy
    ports:
      - "127.0.0.1:3000:3000"
    healthcheck:
      test: ["CMD", "node", "-e", "fetch('http://localhost:3000/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"]
      interval: 5s
      timeout: 3s
      retries: 10

  dashboard:
    build:
      context: .
      dockerfile: apps/dashboard/Dockerfile
    depends_on:
      api:
        condition: service_healthy
    ports:
      - "127.0.0.1:8080:80"

  # Dev tools only. Never started by `docker compose up`. All npm commands run here, not on the PC.
  workspace:
    profiles: ["tools"]
    image: node:24-alpine
    working_dir: /repo
    volumes:
      - .:/repo
      - node-modules:/repo/node_modules
    ports:
      - "127.0.0.1:5173:5173"

volumes:
  db-data:
  node-modules:
```
`.github/workflows/ci.yml`
```yaml
name: CI
on:
  pull_request:
  push:
    branches: [main]
permissions:
  contents: read
concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true
jobs:
  verify:
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version-file: .nvmrc
          cache: npm
      - run: npm ci
      - run: npm run lint
      - run: npm run format:check
      - run: npm run build
      - run: npm test

  compose-smoke:
    runs-on: ubuntu-latest
    timeout-minutes: 15
    env:
      POSTGRES_PASSWORD: ci-only-throwaway
    steps:
      - uses: actions/checkout@v4
      - run: docker compose up --build --wait
      - run: curl --retry 10 --retry-connrefused --retry-delay 2 -fsS http://localhost:8080/api/health
      - if: failure()
        run: docker compose logs
      - if: always()
        run: docker compose down -v

  publish-images:
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    needs: [verify, compose-smoke]
    runs-on: ubuntu-latest
    timeout-minutes: 20
    permissions:
      contents: read
      packages: write
    steps:
      - uses: actions/checkout@v4
      - run: echo "IMAGE_PREFIX=ghcr.io/${GITHUB_REPOSITORY,,}" >> "$GITHUB_ENV"
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/build-push-action@v6
        with:
          context: .
          file: apps/api/Dockerfile
          push: true
          tags: |
            ${{ env.IMAGE_PREFIX }}/api:${{ github.sha }}
            ${{ env.IMAGE_PREFIX }}/api:main
      - uses: docker/build-push-action@v6
        with:
          context: .
          file: apps/dashboard/Dockerfile
          push: true
          tags: |
            ${{ env.IMAGE_PREFIX }}/dashboard:${{ github.sha }}
            ${{ env.IMAGE_PREFIX }}/dashboard:main
```

### packages/shared
`package.json`
```json
{
  "name": "@agora/shared",
  "version": "0.0.0",
  "private": true,
  "types": "dist/index.d.ts",
  "scripts": { "build": "tsc -p tsconfig.json" }
}
```
`tsconfig.json`
```json
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": { "declaration": true, "emitDeclarationOnly": true, "outDir": "dist", "rootDir": "src" },
  "include": ["src"]
}
```
`src/index.ts`
```ts
export type HealthStatus = { status: 'ok' };
```

### apps/api
`package.json`
```json
{
  "name": "@agora/api",
  "version": "0.0.0",
  "private": true,
  "scripts": {
    "dev": "tsx watch src/main.ts",
    "build": "tsc -p tsconfig.json",
    "start": "node dist/main.js",
    "test": "vitest run"
  },
  "dependencies": { "@agora/shared": "*" }
}
```
`tsconfig.json`
```json
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": { "module": "commonjs", "moduleResolution": "node", "outDir": "dist", "rootDir": "src" },
  "include": ["src"]
}
```
`src/app.ts`
```ts
import express from 'express';
import type { HealthStatus } from '@agora/shared';

export function createApp() {
  const app = express();
  app.disable('x-powered-by');
  app.get('/health', (_req, res) => {
    const body: HealthStatus = { status: 'ok' };
    res.json(body);
  });
  return app;
}
```
`src/main.ts`
```ts
import { createApp } from './app';

const port = Number(process.env.PORT ?? 3000);
createApp().listen(port, '0.0.0.0', () => console.log(`api listening on ${port}`));
```
`test/health.test.ts`
```ts
import request from 'supertest';
import { describe, it } from 'vitest';
import { createApp } from '../src/app';

describe('GET /health', () => {
  it('answers ok', async () => {
    await request(createApp()).get('/health').expect(200, { status: 'ok' });
  });
});
```
`test/architecture/rules.ts`
```ts
// ADR-001 and ADR-006; modular monolith standard, rules 4 and 9.
export const forbiddenRules = [
  {
    name: 'no-cross-module-internals',
    comment: "A module may import another module only through that module's index.ts.",
    severity: 'error',
    from: { path: '(^|/)modules/([^/]+)/' },
    to: {
      path: '(^|/)modules/([^/]+)/',
      pathNot: ['(^|/)modules/$2/', '(^|/)modules/[^/]+/index\\.ts$'],
    },
  },
  {
    name: 'shared-kernel-has-no-business-logic',
    comment: 'The shared kernel must not import from business modules.',
    severity: 'error',
    from: { path: '(^|/)shared-kernel/' },
    to: { path: '(^|/)modules/' },
  },
];
```
`test/architecture/module-boundaries.test.ts`
```ts
import { fileURLToPath } from 'node:url';
import { cruise } from 'dependency-cruiser';
import { describe, expect, it } from 'vitest';
import { forbiddenRules } from './rules';

const dir = (rel: string) => fileURLToPath(new URL(rel, import.meta.url));

async function violationsIn(path: string) {
  const { output } = await cruise([path], {
    ruleSet: { forbidden: forbiddenRules },
    validate: true,
    tsPreCompilationDeps: true,
    doNotFollow: { path: 'node_modules' },
  });
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  return (output as any).summary.violations as { rule: { name: string }; from: string; to: string }[];
}

describe('module boundaries (P-02)', () => {
  it("allows imports through a module's index.ts and inside a module", async () => {
    expect(await violationsIn(dir('./fixtures/valid'))).toEqual([]);
  });

  it("fails when a module imports another module's internals", async () => {
    const found = await violationsIn(dir('./fixtures/invalid-internals'));
    expect(found.map((v) => v.rule.name)).toContain('no-cross-module-internals');
    expect(found.some((v) => v.to.endsWith('b/internal/secret.ts'))).toBe(true);
  });

  it('fails when the shared kernel imports a module', async () => {
    const found = await violationsIn(dir('./fixtures/invalid-kernel'));
    expect(found.map((v) => v.rule.name)).toContain('shared-kernel-has-no-business-logic');
  });

  it('has no violations in the real source', async () => {
    expect(await violationsIn(dir('../../src'))).toEqual([]);
  });
});
```
Fixtures (under `test/architecture/fixtures/`)
```ts
// valid/modules/a/index.ts
import { b } from '../b';
import { helper } from './internal/helper';
export const a = () => b() + helper();
// valid/modules/a/internal/helper.ts
export const helper = () => 1;
// valid/modules/b/index.ts
export const b = () => 2;

// invalid-internals/modules/a/index.ts
import { secret } from '../b/internal/secret';
export const a = () => secret();
// invalid-internals/modules/b/index.ts
export const b = () => 2;
// invalid-internals/modules/b/internal/secret.ts
export const secret = () => 3;

// invalid-kernel/shared-kernel/logger.ts
import { b } from '../modules/b';
export const log = () => b();
// invalid-kernel/modules/b/index.ts
export const b = () => 2;
```
`Dockerfile` (build context: repo root; Node tag pinned by the owner)
```dockerfile
FROM node:24-alpine AS build
WORKDIR /repo
COPY package.json package-lock.json tsconfig.base.json ./
COPY apps/api/package.json apps/api/
COPY apps/dashboard/package.json apps/dashboard/
COPY packages/shared/package.json packages/shared/
RUN npm ci
COPY packages/shared packages/shared
COPY apps/api apps/api
RUN npm run build -w @agora/shared && npm run build -w @agora/api
RUN npm prune --omit=dev

FROM node:24-alpine
WORKDIR /repo
ENV NODE_ENV=production
COPY --from=build /repo/node_modules node_modules
COPY --from=build /repo/package.json ./
COPY --from=build /repo/apps/api/package.json apps/api/
COPY --from=build /repo/apps/api/dist apps/api/dist
COPY --from=build /repo/packages/shared/package.json packages/shared/
USER node
EXPOSE 3000
CMD ["node", "apps/api/dist/main.js"]
```

### apps/dashboard
`package.json`
```json
{
  "name": "@agora/dashboard",
  "version": "0.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite --host",
    "build": "tsc --noEmit && vite build",
    "test": "vitest run"
  },
  "dependencies": { "@agora/shared": "*" }
}
```
`tsconfig.json`
```json
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": {
    "lib": ["ES2022", "DOM"],
    "module": "ESNext",
    "moduleResolution": "bundler",
    "jsx": "react-jsx",
    "noEmit": true
  },
  "include": ["src", "vite.config.ts"]
}
```
`vite.config.ts`
```ts
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';
import { defineConfig } from 'vitest/config';

export default defineConfig({
  plugins: [react(), tailwindcss()],
  server: { proxy: { '/api': { target: 'http://localhost:3000', rewrite: (p) => p.replace(/^\/api/, '') } } },
  test: { environment: 'jsdom' },
});
```
`index.html`
```html
<!doctype html>
<html lang="es">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Agora</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
```
`src/index.css` → `@import "tailwindcss";` (design-line tokens arrive with UI-01)

`src/main.tsx`
```tsx
import { createRoot } from 'react-dom/client';
import { App } from './App';
import './index.css';

createRoot(document.getElementById('root')!).render(<App />);
```
`src/App.tsx`
```tsx
import { useEffect, useState } from 'react';
import type { HealthStatus } from '@agora/shared';

export function App() {
  const [api, setApi] = useState<'checking' | 'ok' | 'down'>('checking');
  useEffect(() => {
    fetch('/api/health')
      .then((r) => r.json() as Promise<HealthStatus>)
      .then((h) => setApi(h.status === 'ok' ? 'ok' : 'down'))
      .catch(() => setApi('down'));
  }, []);
  return (
    <main className="p-6">
      <h1 className="text-2xl font-semibold">Agora</h1>
      <p>API: {api}</p>
    </main>
  );
}
```
`src/App.test.tsx`
```tsx
import { cleanup, render, screen } from '@testing-library/react';
import { afterEach, describe, it, vi } from 'vitest';
import { App } from './App';

afterEach(() => {
  cleanup();
  vi.unstubAllGlobals();
});

describe('App', () => {
  it('shows the API as ok when /api/health answers ok', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({ json: async () => ({ status: 'ok' }) }));
    render(<App />);
    await screen.findByText('API: ok');
  });

  it('shows the API as down when the request fails', async () => {
    vi.stubGlobal('fetch', vi.fn().mockRejectedValue(new Error('offline')));
    render(<App />);
    await screen.findByText('API: down');
  });
});
```
`nginx.conf`
```nginx
server {
  listen 80;
  root /usr/share/nginx/html;
  index index.html;
  location /api/ { proxy_pass http://api:3000/; }
  location / { try_files $uri /index.html; }
}
```
`Dockerfile`
```dockerfile
FROM node:24-alpine AS build
WORKDIR /repo
COPY package.json package-lock.json tsconfig.base.json ./
COPY apps/api/package.json apps/api/
COPY apps/dashboard/package.json apps/dashboard/
COPY packages/shared/package.json packages/shared/
RUN npm ci
COPY packages/shared packages/shared
COPY apps/dashboard apps/dashboard
RUN npm run build -w @agora/shared && npm run build -w @agora/dashboard

FROM nginx:alpine
COPY apps/dashboard/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /repo/apps/dashboard/dist /usr/share/nginx/html
```

## Change log
| Version | Date | Note |
|---|---|---|
| 2.1 | 2026-10-22 | Added the Docker `workspace` service: no installs on the owner's PC (Sponsor rule). |
| 2.0 | 2026-10-22 | Updated for ADR-006: Express, npm workspaces, Tailwind, GHCR publish job, owner checklist, Hostinger research. ADR-002 assumption removed. |
| 1.0 | 2026-10-21 | First proposal (NestJS, pnpm). Superseded. |
