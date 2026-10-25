# Teaching notes

- "Design" here means **system design** (data model, subsystems, data flow, business operations), not visual/UI design. The user wants a backend/database emphasis.
- Every lesson should end with a concrete step in **The Edit** (their portfolio shop: React storefront, migrating to Next.js + Postgres on Vercel, own GitHub repo).
- Frame insights as interview talking points: the goal is getting hired.
- Short sessions (3–5 hrs/week total). Keep lessons around 15–20 minutes.
- The user puts lesson work in `assignments/`. Each file starts with its lesson number (e.g. `assignments/db_migrations/0001-create-catalog.sql`). When reviewing SQL, run it on a throwaway Postgres in the scratchpad (PG 18 is installed at `C:/Program Files/PostgreSQL/18/bin`; use `initdb` + port 55432) and show real output.
- Define dev-ops/tooling jargon the first time it appears (e.g. "migration" wasn't familiar on 2026-10-25). Don't assume professional-workflow vocabulary.
- Suggested arc: catalog model → money & pricing → inventory → cart → checkout & payments (idempotency, webhooks) → orders & lifecycle → accounts → listing/search → subsystem map & interview practice. Interleave business-side topics (returns, promotions, margins).
