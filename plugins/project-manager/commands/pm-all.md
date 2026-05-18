---
description: Run the full PM sweep - overview, standup, roadmap, doc-audit, pitch - in one go. Pass a repo to focus.
argument-hint: "[repo-name]"
---

Run every read-only capability from the `project-manager` skill, in this order:

1. **overview** — what each repo is and how healthy it looks
2. **standup** — what shipped / what's open / what's blocked in the last 7 days
3. **roadmap** — ranked priorities with rationale
4. **doc-audit** — inconsistencies and stale references (findings only, no edits)
5. **pitch** — 3-5 proposed extensions

If `$ARGUMENTS` is non-empty, narrow every section to that repo (partial match OK). Otherwise cover all JFB repos.

## Output format

Render as one markdown report with a level-1 heading per section. Between sections, insert a one-line `---` rule. At the very top, include a "TL;DR" — three to five bullets pulled from across the sections (e.g. biggest blocker, highest-priority roadmap item, most actionable doc fix, most promising pitch).

## Execution

- Fire per-repo GitHub lookups in parallel where the data is independent. Don't re-fetch the same README, issue list, or PR list twice across sections — gather once, reuse across sections.
- This command is **read-only**. Do not run `doc-archive`. If the audit surfaces archival candidates, mention them in the doc-audit section and tell the user to run `/pm-doc-archive` to act on them.
- If a section turns up no data (e.g. no open PRs in standup), still include the heading with a one-line "nothing to report" — don't silently drop sections.
