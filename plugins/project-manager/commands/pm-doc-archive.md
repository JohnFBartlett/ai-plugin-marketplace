---
description: Identify and archive outdated docs in JFB repos. Asks before writing.
argument-hint: "[repo-name]"
---

Run the **doc-archive** capability from the `project-manager` skill.

If `$ARGUMENTS` is non-empty, narrow to that repo (partial match OK). Otherwise cover all JFB repos.

First propose archival candidates. Wait for confirmation before moving any files. When archiving, work on a feature branch and do not push without explicit approval.
