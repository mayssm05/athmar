# Kanz Bakery

A web app for a family-run neighborhood bakery: browsable menu with categories and ratings, customer reviews, and a catering/bulk-order request form.

## Run & Operate

- `pnpm --filter @workspace/api-server run dev` — run the API server (port 5000)
- `pnpm --filter @workspace/kanz-bakery run dev` — run the bakery web app
- `pnpm run typecheck` — full typecheck across all packages
- `pnpm run build` — typecheck + build all packages
- `pnpm --filter @workspace/api-spec run codegen` — regenerate API hooks and Zod schemas from the OpenAPI spec
- `pnpm --filter @workspace/db run push` — push DB schema changes (dev only)
- Required env: `DATABASE_URL` — Postgres connection string

## Stack

- pnpm workspaces, Node.js 24, TypeScript 5.9
- API: Express 5
- DB: PostgreSQL + Drizzle ORM
- Validation: Zod (`zod/v4`), `drizzle-zod`
- API codegen: Orval (from OpenAPI spec)
- Build: esbuild (CJS bundle)
- Frontend: React + Vite, wouter routing, TanStack Query, shadcn/radix UI, react-hook-form + zod

## Athmar (أثمر) — Flutter app

- `artifacts/athmar/app/` — Flutter (Dart) app replicating Alinma bank login & services screens (RTL Arabic), foundation for the أثمر savings service. Design copied pixel-faithfully from the user's Figma screenshots — do NOT change visuals without the user's explicit permission.
- Rebuild after Dart changes: `cd artifacts/athmar/app && flutter build web --base-href /athmar/ --release --pwa-strategy=none && cd .. && node postbuild.mjs`
- Served as a static Flutter web build by `artifacts/athmar/server.mjs` (workflow `artifacts/athmar: web`), preview path `/athmar/`.
- Only interactive elements: login username/password fields (expected "hadeel" / "123456789"), login button → services screen, أثمر card → blank placeholder screen. Everything else is static by design.
- Font: bundled IBM Plex Sans Arabic (`app/assets/fonts/`).

## Where things live

- `lib/api-spec/openapi.yaml` — source of truth for the API contract (menu, reviews, catering endpoints/schemas)
- `lib/db/src/schema/` — Drizzle tables: `menu-items.ts` (menu items + reviews), `catering-requests.ts`
- `artifacts/api-server/src/routes/` — Express routers: `menu.ts` (menu items, categories, reviews), `catering.ts`
- `artifacts/kanz-bakery/` — the customer-facing web app (pages under `src/pages`)
- `artifacts/kanz-bakery/public/menu-images/` — generated product photography referenced by seeded `menu_items.image_url`

## Architecture decisions

- No auth/admin panel — scope is public browsing, reviewing, and submitting catering requests only. Catering requests are write-only (`POST` with no listing endpoint) to avoid exposing customer data without auth.
- Menu categories are a plain string column on `menu_items`, not a separate table; `/menu-categories` computes counts via `GROUP BY`.
- Ratings are a separate `menu_item_reviews` table; `averageRating`/`reviewCount` are computed via SQL aggregation and embedded directly in `MenuItem` API responses rather than aggregated client-side.

## Product

- Home: bakery story/identity, featured items, catering CTA
- Menu (`/menu`): filterable by category, search, shows rating + review count per item
- Menu item detail (`/menu/:id`): full description, reviews list, star-rating review submission form
- Catering (`/catering`): bulk order/catering request form with confirmation
- About (`/about`): bakery story and values

## User preferences

_Populate as you build — explicit user instructions worth remembering across sessions._

## Gotchas

- This workspace's zod catalog version does not support `format: email` in the OpenAPI spec (emits `zod.email()`, unavailable) — use a plain string with `minLength` instead of an email format.
- Drizzle date columns with `{ mode: "string" }` expect a `YYYY-MM-DD` string on insert; convert any `Date` from a coerced request body with `.toISOString().slice(0, 10)` before inserting.

## Pointers

- See the `pnpm-workspace` skill for workspace structure, TypeScript setup, and package details
