---
description: Identify and archive outdated docs in one JFB repo. Asks before writing.
argument-hint: "[repo-name]"
---

Run the **doc-archive** capability from the `project-manager` skill against a single repo.

Target repo:
- If `$ARGUMENTS` is non-empty, use that repo (partial match OK).
- Else infer from the current session if possible and confirm with the user.
- Else ask the user which repo to focus on, offering "all repos" as a fallback.

Propose archival candidates first. Wait for confirmation before moving any files. Work on a feature branch; do not push without explicit approval.
