# Athmar (أثمر)

An Arabic RTL savings app. Phone-mockup style Flutter web frontend with an Express/TypeScript AI advisor backend (المزارع الذكي — powered by OpenAI via Replit AI proxy).

## Run & Operate

- `pnpm --filter @workspace/api-server run dev` — API server (port 8080)
- `pnpm --filter @workspace/athmar run dev` — Flutter web static server (port 19115, preview `/athmar/`)
- `pnpm run typecheck` — full typecheck across all packages
- `pnpm run build` — build all packages
- `pnpm --filter @workspace/api-spec run codegen` — regenerate API hooks and Zod schemas from OpenAPI spec
- Required env: `AI_INTEGRATIONS_OPENAI_API_KEY`, `AI_INTEGRATIONS_OPENAI_BASE_URL`, `SESSION_SECRET`

## Flutter rebuild cycle (after any Dart/asset change)

```
cd artifacts/athmar/app
flutter build web --base-href /athmar/ --release --pwa-strategy=none
# if "Error reading .pub-cache" → run flutter pub get first
cd .. && node postbuild.mjs
```
Then restart workflow `artifacts/athmar: web`. A failed build silently serves the stale bundle — always grep for `✓ Built` to confirm.

Preview paths use hash routing: `/#/athmar/tracker`, `/#/athmar/advisor`, etc.

## Stack

- pnpm workspaces, Node.js 24, TypeScript 5.9
- Frontend: Flutter 3.x (Dart) — compiled to static web, served by `artifacts/athmar/server.mjs`
- API: Express 5, esbuild bundle
- AI: OpenAI via Replit AI Integrations proxy (`AI_INTEGRATIONS_OPENAI_BASE_URL`)
- DB: PostgreSQL + Drizzle ORM (schema in `lib/db/src/schema/`)
- API codegen: Orval (from OpenAPI spec in `lib/api-spec/openapi.yaml`)
- Validation: Zod (`zod/v4`), `drizzle-zod`

## App structure

All UI in `artifacts/athmar/app/lib/main.dart`. Routes:
- `/` — login screen
- `/services` — services screen
- `/athmar` — welcome screen
- `/athmar/journey` — sliders setup (goal amount + months)
- `/athmar/goal` — goal tile picker
- `/athmar/plant` — plant naming screen
- `/athmar/advisor` — AI chat (المزارع الذكي)
- `/athmar/tracker` — savings tracker (demo args: goal:'طوارئ', amount:10000, months:2)

Real flow: journey → GoalScreen → PlantScreen → TrackerScreen

Shared constants: `kNavy`, `kCream`, `kPill`, `kSalmon`, `kBlushHelp`, `kBlushCard`, `kTileGray`
Shared widgets: `StatusBar(time:'2:12')`, `_BottomNav`, `HadeelBadge`, `BackChip`, `RawAssetImage`

## Where things live

- `lib/api-spec/openapi.yaml` — source of truth for the API (health + advisor endpoints)
- `artifacts/api-server/src/routes/` — Express routers: `health.ts`, `advisor.ts`
- `artifacts/athmar/app/` — Flutter (Dart) source
- `artifacts/athmar/app/assets/images/` — plant stage images (`stage1..6.png`)
- `artifacts/athmar/app/assets/fonts/` — IBM Plex Sans Arabic

## User preferences

- BackChip arrow must point LEFT (`textDirection: TextDirection.ltr`) on all screens.
- Do NOT change any screen visuals without the user's explicit permission — designs are pixel-faithful copies of Figma mockups.
- User is a novice — replies must be in simple Arabic (Saudi dialect).
- Batch work efficiently; no emojis in replies.

## Gotchas

- `.pub-cache` can disappear; run `flutter pub get` inside `artifacts/athmar/app/` before building if you see "Error reading .pub-cache".
- This workspace's zod catalog version does not support `format: email` in the OpenAPI spec — use a plain string with `minLength` instead.
- Drizzle date columns with `{ mode: "string" }` expect `YYYY-MM-DD`; convert `Date` from coerced request body with `.toISOString().slice(0, 10)`.
- Plant stage images are trimmed PNGs with transparent backgrounds. Display sizes (w,h): stage1(101,52), stage2(44,130), stage3(99,165), stage4(129,190), stage5(245,200), stage6(257,210).

## Pointers

- See the `pnpm-workspace` skill for workspace structure, TypeScript setup, and package details.
