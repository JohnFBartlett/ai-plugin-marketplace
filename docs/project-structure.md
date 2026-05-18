---
last_updated: 2026-05-18
status: active
---

# JFB Project Documentation Structure

Shared documentation conventions for JFB repos. Goals:

- **Predictable.** Pick up any JFB repo and know where to find the README, status, roadmap, decisions.
- **Solo-dev-sized.** Minimal required surface. Most repos won't fill out everything.
- **Human + AI parseable.** Known filenames, known headings, optional YAML frontmatter so agents can extract structured data.

The `project-manager` skill audits repos against this standard and nudges toward it via `/pm-doc-audit` and `/pm-all`.

## File layout

```
<repo-root>/
├── README.md              REQUIRED — what the project is, how to run it
├── CLAUDE.md              OPTIONAL — instructions for AI agents working in the repo
└── docs/
    ├── STATUS.md          RECOMMENDED — current state at a glance
    ├── ROADMAP.md         RECOMMENDED — what's next
    ├── ARCHITECTURE.md    OPTIONAL — how it's built (for non-trivial projects)
    ├── DECISIONS.md       OPTIONAL — decision log
    └── archive/
        └── YYYY-MM/       Archived docs, grouped by archival month
```

No other top-level `*.md` files. If a doc doesn't fit one of these, it probably belongs in one of them or in `archive/`.

## Frontmatter

Every doc under `docs/` (and ideally the README) should start with YAML frontmatter:

```yaml
---
last_updated: YYYY-MM-DD
status: active | dormant | archived
---
```

- `last_updated` is a contract with future-you: if the doc says it was updated 8 months ago, distrust it.
- `status` lets AI agents filter quickly: `dormant` = project is paused, `archived` = doc is no longer the source of truth, look elsewhere.

Archived docs additionally include the archival banner the `doc-archive` capability produces:

```
> **Archived YYYY-MM-DD:** <one-line reason>
```

## File contracts

Each file below specifies its required headings (`##`-level). Subheadings are free-form. If a section is empty, write `_None._` rather than deleting the heading — predictability beats cleanliness.

### README.md

```markdown
# <project name>

<one-paragraph elevator pitch>

## What it does

<2-5 bullets describing user-facing capability>

## Stack

<bullets: language, framework, db, deploy target>

## Quickstart

<commands to clone, install, run locally>

## Docs

- [Status](docs/STATUS.md)
- [Roadmap](docs/ROADMAP.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Decisions](docs/DECISIONS.md)
```

Don't put status, roadmap, or architecture content inline in the README. Link out.

### docs/STATUS.md

```markdown
## In flight

<bullets: what's currently being worked on, with date the bullet was added>

## Recently done

<reverse-chronological list of recently shipped work, dated>

## Blocked / stuck

<bullets for anything that needs unsticking>

## Health

<one line: active | dormant since YYYY-MM-DD>
```

Update on every work session. This is the single source of truth for "where is this project right now?"

### docs/ROADMAP.md

```markdown
## Next

<committed work — issues / specs you actually plan to do next>

## Maybe

<ideas you're considering but haven't committed to>

## Backlog

<longer-term items, lower confidence>
```

Order within each section is priority order. Link to GitHub issues where possible.

### docs/ARCHITECTURE.md

Optional. Use when the project has enough surface area that future-you needs a map.

```markdown
## Stack

<full stack with versions where they matter>

## Modules

<top-level modules, one-line each>

## Data flow

<diagram or prose describing how data moves>

## Deployment

<how it runs in production>
```

### docs/DECISIONS.md

Append-only decision log. Newest first.

```markdown
## YYYY-MM-DD: <topic>

**Decision:** <what was decided>

**Context:** <why this came up>

**Alternatives considered:** <other options>

**Why this one:** <reasoning>
```

Don't edit past entries — append a new one if a decision is revisited.

### CLAUDE.md (optional)

If the repo benefits from agent-specific instructions, put them here. Topics commonly worth covering:

- Coding conventions specific to the project
- Where tests live and how to run them
- Things to avoid (e.g. "don't touch the migration files")
- Pointers to the most useful docs for agents

Keep it short. Long CLAUDE.md files are a sign that conventions should live in the code, not in instructions.

## Adoption checklist

When applying this structure to an existing repo:

1. Create `docs/` and stub `STATUS.md` + `ROADMAP.md`.
2. Move any existing planning/roadmap content out of the README into `ROADMAP.md`.
3. Move any existing status/changelog content into `STATUS.md`.
4. Add frontmatter to every doc.
5. Move clearly-outdated docs to `docs/archive/YYYY-MM/`.
6. Update the README's `## Docs` section to link to whatever you ended up with.
