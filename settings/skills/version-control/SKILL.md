---
name: version-control
description: Create commits or changelists, merge branches, or edit files under lock-based VCS such as Perforce
---

# Version Control

## Change Records

- Commit only the staged index when it is non-empty; otherwise group the worktree into logical units and commit one unit at a time
- Split formatting, refactors, behavior changes, and dependency updates into separate units when practical; use patch staging for mixed files
- Stop on secrets, conflicts outside a merge flow, or a hunk that cannot be split safely

## Lock-Based VCS

- `p4 edit`/`add`/`delete` (or the native checkout) is allowed for files in scope; on failure, stop and report the exact command and error
- Use the existing workspace, client, and stream
- Perforce: one pending changelist per logical unit; never submit, shelve, revert, or clean unless explicitly requested

## Merge Flow

When asked to merge a source branch into a target branch:

1. Treat the request as approval for the merge commit and for conflict-fix commits on the source branch
2. Stop if out-of-scope dirty or staged work exists
3. Check out the target and run `git merge --no-ff --no-commit <source>`
4. If clean, commit the merge; never fast-forward
5. On conflicts, abort the merge, check out the source, and commit fixes there without taking content from the target
6. Stop on the source branch so the user can run an interactive rebase; retry the merge only on explicit follow-up
