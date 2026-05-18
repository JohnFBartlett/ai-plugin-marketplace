---
description: Pitch 3-5 product-focused feature proposals for one JFB repo. User-facing only, no docs/refactors.
argument-hint: "[repo-name]"
---

Run the **pitch** capability from the `project-manager` skill against a single repo.

Target repo:
- If `$ARGUMENTS` is non-empty, use that repo (partial match OK).
- Else infer from the current session if possible and confirm with the user.
- Else ask the user which repo to focus on, offering "all repos" as a fallback.

**Product features only.** New user-facing capabilities, integrations, use cases. **Not** doc reorgs, refactors, or infra consolidation — those are out of scope. If you can't ground 3 proposals in the README or open `idea`/`enhancement` issues, return fewer rather than padding with infra work.
