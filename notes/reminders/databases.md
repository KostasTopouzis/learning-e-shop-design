# Short reminders concerning databases

- A migration runs *inside* a database that already exists. Creating that database is a separate setup step.

- Enclose migration steps inside transactions. That way, if a fail happens, no 'unfinished job' is stored in the database. Everything either succeeds together or fails together. You can also use tools like Prisma to do this for you.

- Check foreign keys reference the right table. If the fk references the wrong table, a silent error may occur, since the constraint guarantees reference integrity by checking the wrong table. This kind of bug is easy to miss because nothing fails. It can be exposed though by testing with bad data.

- Every columns should start as `NOT NULL` unless you can explain to yourself what an empty value would mean and what would be the consequences of having one. Be careful concerning foreign keys: a foreign key only checks a value if there is one. `NULL` skips the check.

- Continuing on the previous thought: check every foreign key with this question: "can a row exist without its parent?" If not, the column needs NOT NULL. Going through the columns one at a time with these questions fixes that:
1. Is it NOT NULL? If not, what does an empty value mean?
2. Is there a range of values that's always wrong? Then add a CHECK.
3. If it's a foreign key: does it point at the right table, and what should ON DELETE do?

- Do not add `ONE DELETE CASCADE` on all foreign keys out of habit. Ask this for a foreign key: *if the parent is deleted, what comes of the children?* Consider where `ON DELETE RESTRICT` is more appropriate. Be particularly careful of accidentally deleting past sales history and receipts. Sometimes it is best to follow the principle: *archive, don't delete.*

- Check the format in which your database host stores date and time objects. Make sure you use the appropriate data type for you schema to fit that.

- About position: it's the order in which options appear on the product page. Colour first (position 0), then size (position 1). Without it, Postgres doesn't guarantee any row order, so the size picker could show above the colour picker on one load and below it on the next. Add `position INTEGER NOT NULL DEFAULT 0`.

- There is a distinction (at least according to Saleor) between a product type as a template ("shirts have Size and Material") and a category tree that indicates where a product sits in the shop's navigation and that can be implemented using recursive CTEs. Always make clear to yourself which table implements which type.

- Be careful of entering default values thoughtlessly. A default should only exist if it's the right answer whenever the value is left out. Otherwise is hides an error.

- A default value only fills in the value if you don't provide one yourself. It doesn't prevent someone of entering a `NULL` value later on.

- Remember to match data types for foreign keys with their primary key columns in the reference table, particularly after migrations that apply data type changes to primary and foreign keys.

- For very large databases, prefer `BIGINT` over `INTEGER` (the latter only goes up to about 2.1 billion).