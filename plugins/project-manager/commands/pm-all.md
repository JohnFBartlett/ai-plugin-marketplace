---
description: Run the full PM sweep on one JFB repo - overview, standup, roadmap, doc-audit, pitch.
argument-hint: "[repo-name]"
---

Run every read-only capability from the `project-manager` skill against a single repo:

1. **overview**
2. **standup**
3. **roadmap**
4. **doc-audit** (findings only, no edits)
5. **pitch**

Target repo:
- If `$ARGUMENTS` is non-empty, use that repo (partial match OK).
- Else infer from the current session if possible and confirm with the user.
- Else ask the user which repo to focus on, offering "all repos" as a fallback. If they pick "all repos," loop and run this whole sweep once per repo, sequentially.

## Output format

Render as one markdown report with a level-1 heading per section. Insert a `---` rule between sections. At the very top, include a TL;DR — three to five bullets pulled from across the sections.

## Execution

- **Cheap by default.** Don't fetch commit history or other deep data beyond what each capability explicitly needs. If a capability suggests "go deeper," surface that as a follow-up the user can request — don't run it.
- Gather each piece of data once and reuse across sections (e.g. don't fetch the README twice).
- This command is **read-only**. Do not run `doc-archive`. If the audit surfaces archival candidates, mention them and tell the user to run `/pm-doc-archive`.
- If a section turns up no data, still include the heading with a one-line "nothing to report."
