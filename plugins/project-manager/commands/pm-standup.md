---
description: Recap of what happened on one JFB repo the last time you worked on it. Helps you get back up to speed.
argument-hint: "[repo-name]"
---

Run the **standup** capability from the `project-manager` skill against a single repo.

Target repo:
- If `$ARGUMENTS` is non-empty, use that repo (partial match OK).
- Else infer from the current session if possible and confirm with the user.
- Else ask the user which repo to focus on, offering "all repos" as a fallback.

Despite the command name, this is a personal recap — not a team status report. Output should help future-you remember where things were left.
