---
description: Find doc inconsistencies and stale references in one JFB repo. Read-only.
argument-hint: "[repo-name]"
---

Run the **doc-audit** capability from the `project-manager` skill against a single repo.

Target repo:
- If `$ARGUMENTS` is non-empty, use that repo (partial match OK).
- Else infer from the current session if possible and confirm with the user.
- Else ask the user which repo to focus on, offering "all repos" as a fallback.

Do not edit any files. Present findings and wait for the user to decide what to fix.
