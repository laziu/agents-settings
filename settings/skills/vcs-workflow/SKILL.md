---
name: vcs-workflow
description: Manage VCS state, change records, branches, shelves, and history
---

# VCS Workflow

Use VCS as scoped save points, isolation, and durable change records.

## Workflow
1. Detect the repository/tool before commands; do not assume a specific VCS
2. Inspect dirty/opened state and preserve unrelated user work
3. Checkout/edit/open only scoped files when the VCS requires it
4. Keep every change record atomic
5. Before sharing, review diff, scan secrets, run project checks
6. Report changed files, verification, and remaining risk

## Guardrails
- If no VCS is detected, keep edits scoped and report VCS verification unavailable
- No commit, submit, push, branch publish, shelf upload, or other sharing without explicit request
- No destructive reset/clean/revert/sync, forced update, or history rewrite without explicit request and confirmation
- For lock/checkout VCS, use the native checkout/edit/open flow; do not bypass locks or read-only attributes
- If checkout/edit/open fails, stop and report the exact command/error
- Prefer trunk-based work, short-lived branches/streams, and feature flags over long-lived isolation

## Command Selection
Use project-native commands. Examples, not an exhaustive VCS list:
- Detect: `.git`, `git rev-parse --show-toplevel`, `p4 info`, `p4 client -o`, `p4 where <path>`, SVN metadata
- State/diff: `git status --short`, `git diff`, `git diff --staged`, `p4 opened`, `p4 diff -du`, `svn status`
- History/debug: native log/blame/annotate/bisect/filelog commands
- Parallel work: branches/worktrees/clones, clients/workspaces, or requested shelves

## Change Units
- One logical thing per commit/changelist/shelf/patch
- Split formatting, refactors, features, tests, and dependency changes when practical
- Size guide: ~100 lines ideal, ~300 acceptable, ~1000 split
- Branch names when no project convention exists: `feature/`, `fix/`, `chore/`, or `refactor/<short-description>`
- Use existing workspace/client/stream unless creation is requested

## Description Format
```text
<type>: <imperative summary>

<why/context/tradeoffs if useful>
```

Classify by behavior impact, not file extension. Treat `settings/**/*.md` as first-class agent source.
Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`.

## Generated Files
- Include lockfiles, migrations, or generated files only when the project expects them
- Exclude build output, `.env`, local IDE state, secrets, and dependency directories
- Update the VCS ignore file when a recurring generated/secret artifact is relevant

## Verification
- Diff contains only intended files and one logical change
- Secret scan covers staged/opened diffs: `password|secret|api_key|token`
- Smallest relevant test/lint/typecheck passes or failure is reported
- No unintended opened/checked-out files remain in lock-based VCS
