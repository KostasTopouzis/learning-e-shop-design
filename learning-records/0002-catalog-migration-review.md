# Catalog migration review: the model is right, constraints are the gap

The user's first migration (`assignments/db_migrations/0001-create-catalog.sql`) got the product/variant split right: price and stock on the variant, options → values → a join table. They also brought in product types without being asked. The weak spots are **constraint discipline**: foreign keys left nullable, the wrong FK target in the join table, `ON DELETE CASCADE` used everywhere by habit, `price_cents` typed as `DECIMAL(10,2)`, invalid `CHECK` syntax, and no transaction around the migration. Future lessons should keep asking "what bad data can this table accept?"

**Evidence**: running the migration on a temporary Postgres 18 database gave 2 syntax errors and left it half-built. After fixing only the syntax, the schema still accepted variants with no product, and a link to an option value that doesn't exist. Deleting a product type also silently deleted its products and variants.

**Prior knowledge** (from their semester SQL course DB, `sql_queries.sql`): adjacency-list category trees with recursive CTEs, lookup tables for statuses, indexes on FKs measured with `EXPLAIN ANALYZE`, `generate_series` for bulk test data. Don't re-teach these. Build on them, e.g. for the categories and listing/search lessons.

**Follow-up (same day, second attempt)**: they fixed the FK target, added `BEGIN/COMMIT`, used `ON DELETE RESTRICT` on product type, `handle`, identity columns and `position`, and correctly told product types apart from categories. Still missed: column-definition order (`stock NOT NULL INTEGER`), `NOT NULL` on one FK, a `CHECK` on price, `timestamptz`, and FK columns typed `integer` against `bigint` IDs. So the concepts have landed, but they don't yet apply them consistently to every column. A per-column checklist habit would help.

**Implications**: The school DB conflates *product types* (attribute templates) with *categories* (navigation tree). Also, its `order_items` cascade from variants, which would delete order history. Both are good hooks for the orders and categories lessons.
