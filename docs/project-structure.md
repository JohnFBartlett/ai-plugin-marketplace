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

### Simple repos (single app)

```
<repo-root>/
├── README.md              REQUIRED — what the project is, how to run it
├── CLAUDE.md              OPTIONAL — instructions for AI agents working in the repo
└── docs/
    ├── STATUS.md          RECOMMENDED — current state at a glance
    ├── ROADMAP.md         RECOMMENDED — what's next
    ├── ARCHITECTURE.md    OPTIONAL — how it's built
    ├── DECISIONS.md       OPTIONAL — decision log
    └── archive/
        └── YYYY-MM/       Archived docs, grouped by archival month
```

No other top-level `*.md` files. If a doc doesn't fit one of these, it probably belongs in one of them or in `archive/`.

### Multi-app / monorepo repos

For repos with multiple distinct sub-apps (e.g. `backend/`, `web/`, `mobile/`), the standard nests: the top-level `docs/` covers cross-cutting concerns, and each sub-app has its own `docs/` with the same file contracts scoped to that app.

```
<repo-root>/
├── README.md              REQUIRED — index to the sub-apps + top-level docs
├── CLAUDE.md              OPTIONAL
├── docs/                  Cross-cutting concerns
│   ├── STATUS.md          Project-wide status (per-app status lives under each app)
│   ├── ROADMAP.md         Cross-cutting roadmap (per-app roadmap lives under each app)
│   ├── ARCHITECTURE.md    How the apps fit together — topology, shared services
│   ├── DECISIONS.md       Project-wide decisions
│   └── archive/
└── <app-name>/            e.g. backend/, web/, mobile/
    ├── README.md          App-specific overview
    └── docs/
        ├── STATUS.md      App-specific status
        ├── ROADMAP.md     App-specific roadmap
        ├── ARCHITECTURE.md
        ├── DECISIONS.md
        ├── RELEASES.md    OPTIONAL — release / deployment process (e.g. app store builds)
        └── archive/
```

**Where to put what:**
- **App-specific** content (a backend domain's data model, a mobile app's deployment steps) goes under that app's `docs/`.
- **Cross-cutting** content (how the backend talks to the mobile app, payment-system design that spans services) goes in the top-level `docs/`.
- If you're unsure, prefer the more specific location and link to it from the top level.

**Top-level docs act as an index.** Top-level `STATUS.md` and `ROADMAP.md` shouldn't restate per-app status — they should link to it and only add cross-cutting bullets. Top-level `ARCHITECTURE.md` describes the system topology, not the internals of any one app.

### Splitting a section across multiple files

When a single file gets unwieldy (especially `ARCHITECTURE.md` or `DECISIONS.md`), split it into a directory:

```
docs/architecture/
├── README.md              Index — one paragraph + links to the sub-files
├── data-model.md
├── auth.md
└── deployment.md
```

The same applies to `decisions/` (one file per decision) or any other section. The index file (`README.md` inside the directory) acts as a TOC and follows the same frontmatter conventions. Sub-files don't need the standard top-level headings — they have their own.

### What's deliberately out of scope (for now)

A separate structured doc-DB (e.g. SQLite or JSON index of all docs across all repos, queryable by AI agents) would speed up cross-repo lookups, but it adds a second source of truth that has to stay in sync. The current approach — known filenames + known headings + YAML frontmatter — covers most agent-parsing needs without that maintenance burden. Revisit if frontmatter-based parsing proves insufficient.

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

Optional. Use when the project has enough surface area that future-you needs a map. May be split into `docs/architecture/` if a single file gets too long.

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

In a multi-app repo, the top-level `ARCHITECTURE.md` covers topology and shared concerns; each app's own `ARCHITECTURE.md` covers that app's internals.

### docs/RELEASES.md (optional)

For apps with non-trivial release/deployment process — mobile app store builds, multi-step deploys, signing keys, etc.

```markdown
## Process

<step-by-step release procedure>

## Targets

<each target with its own subsection: app stores, environments, etc.>

## Credentials & secrets

<where credentials live, NOT the credentials themselves>

## Recent releases

<reverse-chronological log of releases with version + date + notes>
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

1. **Identify the topology.** Is this a single-app repo or a monorepo? If monorepo, list the sub-apps.
2. Create `docs/` at the top level (and under each sub-app for monorepos) and stub `STATUS.md` + `ROADMAP.md`.
3. For monorepos: identify which existing docs are cross-cutting vs app-specific, and place each at the right level.
4. Move planning/roadmap content out of the README into `ROADMAP.md`.
5. Move status/changelog content into `STATUS.md`.
6. Add frontmatter to every doc.
7. Move clearly-outdated docs to the nearest `archive/YYYY-MM/`.
8. Update the README's `## Docs` section to link to the top-level docs (and, for monorepos, to each sub-app's README).

For large existing repos with many docs (e.g. `smart-todo` with backend / web / mobile), don't try to do this in one pass. Migrate one sub-app at a time and let `/pm-doc-audit` keep flagging remaining gaps.
