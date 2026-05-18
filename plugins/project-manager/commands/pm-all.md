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

One markdown report with a level-1 heading per section. Insert a `---` rule between sections. At the very top, include a TL;DR — three to five bullets pulled from the sections.

## Execution

- **Cheap by default.** Don't fetch commit history or other deep data beyond what each capability explicitly needs. Surface "go deeper" options as follow-ups the user can request.
- **Verified info only.** Every concrete claim must come from a tool call in this session. No inferred dates, counts, or activity assertions.
- Gather each piece of data once and reuse across sections.
- **Read-only.** Do not run `doc-archive`; mention candidates and refer to `/pm-doc-archive`.
- If a section has no data, include the heading with a one-line "nothing to report."
