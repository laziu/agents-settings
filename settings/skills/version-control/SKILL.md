---
name: version-control
description: VCS diffs, branches, commits, merges, and history risk
---

# Version Control

Use for explicit VCS change records, lock-based checkout flows, branch/history risk, and user-requested commits or changelists.

Commit or create changelists only when the user explicitly asks. Never push, submit, publish, upload shelves, amend, reset, force, delete, revert, clean, force sync, or rewrite history without explicit request and confirmation.

## Rules
- For lock/checkout VCS, use the native checkout/edit/open flow
- Stop and report the exact command/error on checkout/edit/open failure
- Use existing workspace/client/stream unless creation is requested
- Preserve unrelated dirty work and explicit units such as Git staged index, Perforce numbered changelist, or SVN changelist
- Stop on mixed unit scope, unsafe hunk split, conflicts outside an explicit merge flow, secrets, whitespace errors, or destructive/history requests
- Put recurring secret, whitespace, and conflict checks in hooks, scripts, or CI when possible

## Change Records
- One logical thing per commit, changelist, shelf, or patch
- Split formatting, refactors, features, tests, docs, and dependency changes when practical
- Without explicit unit, group worktree/opened changes by logical change
- Include only files or hunks for the current group
- Use patch staging for mixed Git files

## Explicit Commit Flow
1. Confirm the user explicitly requested a commit or local change record
2. Inspect status and candidate diff
3. Stage/open only the current logical unit
4. Git: commit staged index if present; otherwise stage and commit one logical group at a time
5. Perforce: create pending changelist per group; open/add/reopen files; never submit unless explicitly requested
6. SVN: add/delete current-group files and assign changelists; commit only when explicitly requested
7. Report created unit IDs/names, files, verification, and remaining work

## Explicit Merge Flow
Use when the user requests merging a source branch into a target branch:
1. Treat the request as permission for the merge commit and source-branch conflict-fix commits
2. Record the source and target branches; stop on out-of-scope dirty or staged work
3. Checkout the target; run `git merge --no-ff --no-commit <source>`
4. If clean, commit the merge; never fast-forward
5. If conflicts occur, abort the merge and checkout the source branch
6. Commit source-branch fixes only; do not take content from the target branch
7. Report fixes and stop on the source branch for user interactive rebase; retry the target merge only on explicit follow-up

## Description Format

```text
<type>: <imperative summary>

<why/context/tradeoffs if useful>
```

Classify by behavior impact, not file extension. Treat `settings/**/*.md` as first-class agent source.

Type selection:
| Type | Use |
| --- | --- |
| `feat` | Add agent capability, workflow, command, or user-facing behavior |
| `fix` | Correct agent behavior, routing, safety, verification, or boundaries |
| `refactor` | Reshape context with the same behavior |
| `test` | Add or correct verification assets |
| `docs` | User-facing docs with no agent behavior change |
| `chore` | Packaging, install, metadata, or mechanical maintenance |

For `AGENTS.md`, skills, policies, and references, avoid `docs` unless the change is purely explanatory.
