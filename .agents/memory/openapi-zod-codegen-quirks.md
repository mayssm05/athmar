---
name: OpenAPI/Zod codegen quirks
description: Gotchas hit when writing an OpenAPI spec that gets codegen'd into Zod schemas (Orval) and Drizzle inserts in this workspace's package versions.
---

## `format: email` breaks codegen
Using `format: email` on a string field in `lib/api-spec/openapi.yaml` causes Orval to emit `zod.email()` in the generated Zod schema, which is not available in this workspace's installed zod catalog version (3.25.76 lineage). Codegen succeeds but the emitted schema module fails at import/typecheck time.

**Why:** the zod version pinned in the pnpm catalog predates/excludes the top-level `zod.email()` helper that newer Orval templates assume.

**How to apply:** avoid `format: email` in OpenAPI string schemas here. Use a plain string with `minLength` (and just validate real email shape server-side if needed) instead of relying on the format keyword.

## Drizzle string-mode date columns need manual formatting
A Drizzle `date(..., { mode: "string" })` column expects a `YYYY-MM-DD` string on insert. If the corresponding Zod request-body schema uses `zod.coerce.date()` (common when an OpenAPI `format: date` field is coerced), the parsed value is a JS `Date`, not a string, and inserting it directly fails a TS overload/type error.

**Why:** the codegen'd zod schema coerces to `Date` for ergonomics, but the DB column is stored as a plain date string.

**How to apply:** convert with `value.toISOString().slice(0, 10)` before passing to `.values(...)` for any string-mode date column fed from a coerced request body.
