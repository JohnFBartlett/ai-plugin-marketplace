---
description: Run the full PM sweep on one JFB repo - overview, standup, roadmap, doc-audit, pitch.
argument-hint: "[repo-name]"
---

Run every read-only capability from the `project-manager` skill against a single repo:

1. **overview**
2. **standup**
3. **roadmap**
4. **doc-audit** (findings only, no edits)
5. **pitch** (product-focused only)

Target repo:
- If `$ARGUMENTS` is non-empty, use that repo (partial match OK).
- Else infer from the current session if possible and confirm with the user.
- Else ask the user which repo to focus on, offering "all repos" as a fallback. If they pick "all repos," loop the entire sweep once per repo, sequentially.

## Output format

One markdown report with a level-1 heading per section. Insert a `---` rule between sections. At the very top, include a TL;DR — three to five bullets pulled from the sections. **At the very end, include a "Focus" section** (see below).

## Focus section (required, at the end)

After every other section, output a final `# Focus` section that prescribes what the user should actually act on now, based on what the other sections surfaced. This is the only synthesis-across-sections allowed in the report — everything above is per-capability output.

Rules:
- **Prescriptive, not descriptive.** "Update the README — it still references the old auth package" is good. "There are stale docs" is what doc-audit already said.
- **Ranked.** Lead with the single most important thing. Then 2–4 more, in order. Stop when nothing else is genuinely actionable.
- **Grounded in the sections above.** Every Focus item must reference a specific finding from overview / standup / roadmap / doc-audit (e.g. "from doc-audit finding #3"). Do not invent new concerns here.
- **Cross-cutting is OK and encouraged.** If doc-audit found stale references AND roadmap shows the relevant feature is now top priority, the Focus item is "update the docs before the roadmap work lands."
- **Skip if nothing's urgent.** If the report surfaced no actionable items, write "Focus: no urgent action. Project is in a steady state." — do not pad.

Focus is the section the user reads first. Make it sharp.

## Execution

- **Cheap by default.** Don't fetch commit history or other deep data beyond what each capability explicitly needs. Surface "go deeper" options as follow-ups the user can request.
- **Verified info only.** Every concrete claim must come from a tool call in this session. No inferred dates, counts, or activity assertions.
- Gather each piece of data once and reuse across sections.
- **Read-only.** Do not run `doc-archive`; mention candidates and refer to `/pm-doc-archive`.
- If a section has no data, include the heading with a one-line "nothing to report."
