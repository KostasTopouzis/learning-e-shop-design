\# Further questions to be answered at some later time.



I place here questions that occur to me during the lessons, but I do not have the time

at that moment to further investigate, or I do not want to interrupt the flow of the lesson.



1. I was exposed to a database schema where table product data are stored in a chain of multiple tables, where the chain goes: options -> values -> join table. In previous databases I had designed, I would implement the same thing with one table, e.g. variants, having the options as a column and its values as its values using, for example, an enum type for acceptable values. I suspect that one of the cons of the latter is that each product may have different options each with its own values, so we would need many `variants` (or, `products`) tables to implement all different cases. Am I right in my assumption? Explain the pros and cons of each implementation model.
2. I thought that a foreign key constraint checks that the column serving as a foreign key must have a value. But since the `NULL` value skips the check, it appears that not having any value and having `NULL` as a value, are not the same. Am I correct in my assumption? Explain in more detail what exactly are the checks performed in a foreign key constraint and to what extent they guarantee reference integrity.
3. In my migration `0001-create-catalog.sql` I used slugs only in `product\_types` and a handle only in `products`. Is that correct?
4. Explain briefly what is a recursive CTE, why it is useful, and how it is implemented.
5. What is a lookup table in a database schema?
6. Is a product type (meaning a product template) really necessary? What is its usefulness?
7. "Vercel's servers run on UTC and your customers don't. A plain TIMESTAMP stores "18:32" without saying which 18:32, so order times would display wrongly." Explain how that would happen.
8. "A judgement call: description TEXT NOT NULL. It's a reasonable rule for a curated shop like The Edit. The cost is that a merchant can't save a draft product before the copy is written. Real platforms solve this with a status column: drafts can be incomplete, but published products can't." Explain this further, particularly what do you mean by 'draft product', 'the copy is written', and 'status column'.

