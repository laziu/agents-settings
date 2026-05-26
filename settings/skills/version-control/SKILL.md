---
name: version-control
description: Manage VCS state, diffs, branches, commits, and history
---

# Version Control

Use VCS for scoped state, isolation, reviewable diffs, and durable change records.

Commit or create changelists only when the user explicitly asks. Never push, submit, publish, upload shelves, amend, reset, force, delete, revert, clean, force sync, or rewrite history without explicit request and confirmation.

## Workflow
1. Detect the repository/tool before commands; do not assume a specific VCS
2. Inspect dirty/opened state and preserve unrelated user work
3. Checkout/edit/open only scoped files when the VCS requires it
4. Review candidate diffs before sharing or recording changes
5. Scan diffs for secrets with `password|secret|api_key|token`
6. Run the smallest relevant check when practical
7. Report changed files, verification, and remaining risk

## Guardrails
- If no VCS is detected, keep edits scoped and report VCS verification unavailable
- For lock/checkout VCS, use the native checkout/edit/open flow
- Stop and report exact command/error on checkout/edit/open failure
- Leave unrelated, generated, exploratory, or ambiguous files untouched
- Stop on mixed unit scope, unsafe hunk split, conflicts, secrets, whitespace errors, or destructive/history requests
- Use existing workspace/client/stream unless creation is requested

## Change Records
- One logical thing per commit, changelist, shelf, or patch
- Split formatting, refactors, features, tests, docs, and dependency changes when practical
- Preserve explicit units: Git staged index, Perforce numbered changelist, SVN changelist
- Without explicit unit, group worktree/opened changes by logical change
- Include only files or hunks for the current group
- Use patch staging for mixed Git files

## Explicit Commit Flow
1. Confirm the user explicitly requested a commit or local change record
2. Inspect status: `git status --short`, `p4 opened`/`p4 diff -du`, or `svn status`
3. Inspect candidate diff
4. Run whitespace/conflict checks where supported and scan for secrets
5. Git: commit staged index if present; otherwise stage and commit one logical group at a time
6. Perforce: create pending changelist per group; open/add/reopen files; never submit unless explicitly requested
7. SVN: add/delete current-group files and assign changelists; commit only when explicitly requested
8. Report created unit IDs/names, files, verification, and remaining work

## Description Format

```text
<type>: <imperative summary>

<why/context/tradeoffs if useful>
```

Classify by behavior impact, not file extension. Treat `settings/**/*.md` as first-class agent source.

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`.

## Verification
- Diff contains only intended files
- Secret scan covers staged/opened diffs
- Smallest relevant check passes or failure is reported
- No unintended opened/checked-out files remain in lock-based VCS
