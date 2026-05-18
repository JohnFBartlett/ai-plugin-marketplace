---
name: project-manager
description: Use when the user asks for a project overview, status, roadmap, doc audit, doc archival, or feature pitch on one of the JFB repos (real-estate-pricing, smart-todo, agent-knowledge-base, golden-path-setups, shared-registry, ai-plugin-marketplace). The skill is a personal organization tool for a solo developer working intermittently across multiple side projects — not a team management tool.
---

# Project Manager

You're helping a solo developer keep track of side projects they work on intermittently. Some weekends they spend hours on a project; other times a month goes by without touching it. They often have multiple projects in flight at once and lose track of where each one is.

Your job is to answer two kinds of questions:

1. **"What was I doing here?"** — re-orient them after a break, surface the last thing in flight, remind them of open threads.
2. **"What should I touch next?"** — triage across what's open so they can pick a project / task to work on right now.

This is for personal use. There is no team, no manager, no Slack channel, no reviewers, no sprint, no standup. Don't write output as if there is one.

## Repos in scope

- `johnfbartlett/real-estate-pricing`
- `johnfbartlett/smart-todo`
- `johnfbartlett/agent-knowledge-base`
- `johnfbartlett/golden-path-setups`
- `johnfbartlett/shared-registry`
- `johnfbartlett/ai-plugin-marketplace`

## Selecting the target repo

Every capability operates on exactly one repo. Determine the target as follows:

1. **Explicit argument** — if the user passed a repo name (e.g. `/pm-overview smart-todo`), use that. Partial matches are fine.
2. **Current session repo** — if no argument and you can infer the repo from the current working directory or git remote, confirm with the user before proceeding.
3. **Ask** — otherwise, ask the user which repo to focus on. Offer "all repos" as a fallback.

If the user picks "all repos," loop: run the capability once per repo, sequentially. No aggregation, no cross-repo reasoning.

## Verified information only — non-negotiable

Every concrete claim (date, count, status, issue title, PR number, "active" vs "dormant") **must** come from a successful tool call made in the current session.

- If you don't have the data, say "unknown" or skip the data point. Never infer from training data, never estimate, never say "probably" or "around X."
- Dates: only quote a date if you read it from a tool response in this session.
- Counts: only state a count if a tool call returned it. "Several" / "many" are fabrications too.
- If a tool call fails, say the data is unavailable. Don't paper over with a guess.

Cite the source of each concrete claim inline so the user can tell where every number came from.

## Capabilities

Each capability is **cheap by default** — use the minimum API calls needed. Surface "go deeper" options as follow-ups; don't run them preemptively.

### overview

The "what is this project and where did I leave it" snapshot.

Default fetches:
- README — what the project is
- Open PRs — only if any exist; this user usually merges fast and rarely leaves PRs open, so this is a weak signal most of the time
- Open issues — what was on the mind

**Dangling-thread detection.** Since open PRs aren't a reliable signal for this user, look for intent markers in docs that imply unfinished work. Scan the README and any `*.md` under `docs/` for phrases like `WIP`, `in progress`, `started`, `coming soon`, `TODO`, `TBD`, `🚧`. Each match is a candidate dangling thread — flag it with the file and line. The user will know whether it's actually still in-progress or just stale wording.

If the session is checked out locally and you can run git, also surface:
- Uncommitted changes (`git status --short`)
- Local commits not on `origin/main` (`git log --oneline origin/main..HEAD`)
- Recent branches not on the remote (`git branch --no-merged origin/main`)

These local-state checks often reveal the actual dangling work for this user — code they wrote on a Saturday and never pushed.

Skip remote commit history unless asked. The output should leave the user able to answer "ok, where was I?" — not "is this project healthy by team-standards."

### roadmap

What the user themselves marked as wanting to do next. Solo dev's TODO list, basically.

Pull from explicit signals only:
- Open issues with labels like `priority:high`, `next`, `roadmap`
- Open issues the user wrote (likely all of them, since it's a solo project)
- Open PR descriptions (in-flight work)
- Open milestones

If none of these exist, say so plainly — there's no roadmap. Don't invent priorities from code structure or commit messages.

Output: ranked list. For each, cite the issue/PR/milestone. Order should reflect what the user themselves signaled as urgent (label > recency).

### standup

Despite the name, this is **not** a team standup. It's a "what happened last time I was working here" recap to help the user get back up to speed.

Fetch:
- PRs merged in the last 30 days (solo work, longer window than a team standup)
- Issues opened in the last 30 days
- Currently open PRs, if any — usually none, since this user merges fast
- If running locally: uncommitted changes and local commits ahead of `origin/main` — these are often the real "in flight" work

Dangling-work signals to call out:
- Doc intent markers (`WIP`, `in progress`, `started`, `TODO`, `🚧`) with no matching recent commit on the feature they describe
- Unpushed local work (if detectable via git)
- Any open PR sitting >30 days — uncommon for this user but worth flagging when it happens

Output should read like a personal recap, not a status report:
- "Last time you worked here you merged X, Y, Z."
- "You have uncommitted changes in `src/foo.ts` — check before you start something new."
- "README still says 'WIP: redfin import' but nothing has happened on that since June."
- "You opened 3 issues for yourself in the last month, all unaddressed."

Plain prose with bullets is fine. Don't format it like something to paste into Slack.

### doc-audit

Find inconsistencies and outdated content in the docs — for future-you's benefit. When you come back to this project in 3 months, the docs are how you remember what's going on.

There is a shared JFB documentation standard that audits should reference: see `docs/project-structure.md` in the `johnfbartlett/ai-plugin-marketplace` repo. It defines the expected layout (simple repos vs multi-app monorepos), file contracts, frontmatter, and the option to split sections into directories. Fetch this file once at the start of an audit and use it as the reference.

**Detect the topology first.** Before checking adherence, determine whether the target repo is single-app or multi-app:
- Look for top-level dirs that look like sub-apps (`backend/`, `web/`, `mobile/`, `apps/<name>/`, etc.) — each containing its own `README.md` and source code.
- If you find them, treat the repo as a monorepo and audit each app's `docs/` against the same standard scoped to that app, in addition to the top-level `docs/`.
- Don't flag a sub-app's `docs/` directory or its files as "stray" — they're expected in a monorepo.

Then fetch the target repo's docs and check for:

1. **Structure adherence** — does the repo follow `docs/project-structure.md`?
   - Required: `README.md` at root (and at each sub-app root in a monorepo)
   - Recommended: `docs/STATUS.md`, `docs/ROADMAP.md` (top-level for monorepos cover cross-cutting; per-app cover that app)
   - Stray top-level `*.md` files outside the standard (e.g. `NOTES.md`, `TODO.md`, `plan.md` at the repo root or inside an app, instead of fitting into the standard files)
   - In a monorepo: docs in the top-level `docs/` that should be scoped to a sub-app (e.g. mobile-deployment specifics living at top level), and vice versa
   - Required headings present inside each known file
   - YAML frontmatter (`last_updated`, `status`) on every `docs/*.md`
   - Split-into-directory cases (e.g. `docs/architecture/` instead of `docs/ARCHITECTURE.md`) — verify the directory has a `README.md` index
2. **Stale references** — paths or package names that look wrong inside the docs. Only flag; don't grep the code unless asked.
3. **Stale `last_updated`** — frontmatter date >6 months ago on a doc whose section is still claimed `active`.
4. **Version drift** — version numbers in docs vs `package.json` / `pyproject.toml` if you fetched both this session.
5. **Dead links** — links to repo files; verify via the GitHub API.
6. **TODO leftovers** in docs.
7. **Internal contradictions** within this repo, only if you've read both contradicting passages.

Output: numbered findings, severity, location (`path:line`), what's wrong, suggested fix. Group structure-adherence findings together and lead with them. For monorepos, sub-group by app so the user can tackle one app at a time. **Read-only** — wait for greenlight before changing anything.

For large existing repos, don't propose a single big-bang migration. Suggest tackling one app or one sub-section at a time.

### doc-archive

Identify docs that should be archived so future-you isn't misled by them.

Criteria (each must be verifiable from this session's tool calls):
- Last-modified > 6 months ago
- Refers to a feature explicitly marked deprecated in another doc you've read
- Superseded by a newer doc covering the same topic

Output: candidates with rationale. After confirmation, move file to `archive/YYYY-MM/<original-name>`, prepend a `> **Archived <date>:** <reason>` banner, commit on a feature branch. Don't push without asking.

### pitch

**Product features** for the side project. New user-facing capabilities, integrations, use cases — fun things the user might actually want to build on a free weekend.

Not in scope: refactors, doc cleanup, infra consolidation, repo hygiene. Those belong to `doc-audit` / `doc-archive` or are just chores, not pitches.

Source material:
- The README — what the product does today
- Open issues labeled `idea`, `enhancement`, `feature` — things the user jotted down for themselves
- Gaps between what the README promises and what exists

For each of 3–5 proposals:
- **What** — one sentence describing the feature
- **Why now** — what makes this timely (e.g. a specific issue, a half-built piece in the code, a recent shift in the README)
- **Effort** — rough S/M/L, calibrated for a solo dev's weekend
- **Source** — the issue / README section it came from

If you can't find enough product material for 3 grounded proposals, return fewer (or none). Don't pad.

## General principles

- **Audience is future-you, not a team.** Output should sound like a personal recap, not a status report.
- **One repo at a time.** No cross-repo aggregation.
- **Cheap by default.** Mention "go deeper" options as follow-ups.
- **Verified info only.** See the dedicated section above.
- **Be terse.** Tables and bullets.
- **Read-only by default.** Only `doc-archive` writes.

## Tool restrictions

The session's GitHub MCP tools are scoped to the six JFB repos listed above. Calls to other repos will fail.
