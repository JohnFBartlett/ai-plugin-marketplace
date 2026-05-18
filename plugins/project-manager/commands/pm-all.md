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

After every other section, output a final `# Focus` section that answers two questions for a solo developer who picks up this project intermittently:

1. **If I were going to spend an hour on this right now, what's the best use of that time?**
2. **What dangling thread is most likely to bite me if I forget about it?**

This is the only synthesis-across-sections allowed in the report — everything above is per-capability output.

Rules:
- **Prescriptive, for future-you.** Frame items like personal reminders, not work assignments.
- **Ranked.** Lead with the single best thing to do next. Then 2–4 more, in order. Stop when nothing else is genuinely actionable.
- **Grounded in the sections above.** Every Focus item must trace to a specific finding from overview / standup / roadmap / doc-audit. Don't invent new concerns.
- **Cross-cutting is encouraged.** If doc-audit flagged a stale README section and roadmap shows that feature is what you wanted to build next — the Focus item is "fix the README first so you don't get confused when you start building." That kind of stitching is the whole point of this section.
- **Skip if nothing's urgent.** If nothing actionable came up, write "Focus: nothing pressing. If you spend time here, pick from the roadmap." — don't pad.

Example tone (do NOT use these literally, just calibrate):
- "PR #14 has been open for 2 months — either finish it or close it before you forget what it was about."
- "You opened issue #22 ('add CSV export') 6 weeks ago and labeled it `next`. Pick a Saturday."
- "The README still says 'WIP: redfin import' but PR #11 shipped that in March. Update the README so future-you isn't confused."
- "Nothing pressing here. If you want to dip back in, the smallest open `enhancement` issue is #19."

Focus is the section the user reads first. Make it sharp and personal.

## Execution

- **Cheap by default.** Don't fetch commit history or other deep data beyond what each capability explicitly needs. Surface "go deeper" options as follow-ups the user can request.
- **Verified info only.** Every concrete claim must come from a tool call in this session. No inferred dates, counts, or activity assertions.
- Gather each piece of data once and reuse across sections.
- **Read-only.** Do not run `doc-archive`; mention candidates and refer to `/pm-doc-archive`.
- If a section has no data, include the heading with a one-line "nothing to report."
