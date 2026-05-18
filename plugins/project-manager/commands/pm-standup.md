---
description: Weekly standup digest for one JFB repo - merged, open, blocked. Pass a repo name, or you'll be asked.
argument-hint: "[repo-name]"
---

Run the **standup** capability from the `project-manager` skill against a single repo.

Target repo:
- If `$ARGUMENTS` is non-empty, use that repo (partial match OK).
- Else infer from the current session if possible and confirm with the user.
- Else ask the user which repo to focus on, offering "all repos" as a fallback.
