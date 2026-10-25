---
name: explain
description: Invoked as /explain <question>. Answers the question in the terminal, then saves that same answer as its own HTML note under ./notes/<subfolder>/.
argument-hint: <question or concept to explain>
---

# /explain → saved note

The user is learning e-commerce system design in this workspace (see `MISSION.md`, `NOTES.md`). When they run `/explain <question>`, they want the answer **and** a permanent copy of it to review later. The question is the text passed after `/explain` (the skill's arguments). If no question was passed, ask what they want explained.

## Steps

1. **Answer in the terminal first**, the normal way: clear and grounded in The Edit where relevant. Cite sources, and prefer the ones in `RESOURCES.md`. Verify claims you're unsure of. Don't rely on memory alone.
2. **Pick the subfolder.** List the folders in `./notes/` and choose the one whose topic fits best:
   - `concepts/`: general software/engineering concepts and vocabulary (e.g. migrations, idempotency, ORMs).
   - If none fits, create a new kebab-case subfolder for the topic area (e.g. `payments/`, `nextjs/`, `business/`). Prefer an existing folder over making a new one with only one note.
3. **Name the file** after the concept in kebab-case: `notes/<subfolder>/<concept>.html` (e.g. `database-migrations.html`). If a note on the same concept already exists, update it: merge in the new material and bump the "Updated" date. Don't create a duplicate.
4. **Write the note as HTML** using the template below. The content must be the answer you gave in the terminal: the same explanation, examples, rules and sources. You may tidy it into HTML structure, but don't summarise it into something thinner or add new claims.
5. **Link it up**: link to any related lesson in `./lessons/` or reference doc in `./reference/`.
6. **Tell the user** the saved path in one closing line, e.g. `Saved to notes/concepts/database-migrations.html`.

## Template

Reuse the shared stylesheet. Don't inline styles that belong in `assets/course.css`.

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{Concept Name}</title>
<link rel="stylesheet" href="../../assets/course.css">
</head>
<body>
<main>
<p class="kicker">Note · {subfolder}</p>
<h1>{Concept name}</h1>
<p class="subtitle">{One-sentence definition}</p>
<div class="meta"><span>Asked: "{the user's question, shortened}"</span><span>Updated {YYYY-MM-DD}</span></div>

<!-- The explanation: h2 sections, code in <pre><code>, callouts with .note / .win / .ask -->

<h2>Sources</h2>
<ul class="sources"><li><a href="…">…</a></li></ul>

<nav class="lesson-nav"><span>Related: <a href="../../lessons/…">…</a></span></nav>
</main>
</body>
</html>
```
