---
description: Recap of what happened on one JFB repo the last time you worked on it. Helps you get back up to speed.
argument-hint: "[repo-name]"
---

Run the **standup** capability from the `project-manager` skill against a single repo.

Target repo:
- If `$ARGUMENTS` is non-empty, use that repo (partial match OK).
- Else infer from the current session if possible and confirm with the user.
- Else ask the user which repo to focus on, offering "all repos" as a fallback.

The output is a personal recap to help you (or anyone returning to the project) pick up where things were left, not a formal status report.
