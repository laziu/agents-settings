---
name: git-workflow-and-versioning
description: Structures git workflow for code changes, commits, branches, conflicts, and parallel work.
---

# Git Workflow and Versioning

Use git as save points, isolation, and durable change documentation.

## Use When
Any code change, commit, branch, conflict, or parallel work is involved.

## Principles
- Prefer trunk-based development: deployable main/default branch, short-lived feature branches.
- Commit each verified increment.
- Each commit does one logical thing.
- Separate formatting, refactors, features, tests, and dependency changes where practical.
- Feature flags are better than long-lived branches for incomplete work.
- Preserve user/unrelated dirty work.

## Commit Size
- ~100 lines: ideal.
- ~300 lines: acceptable if one logical change.
- ~1000 lines: split.

## Commit Message
```text
<type>: <imperative summary>

<why/context/tradeoffs if useful>
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`.

## Branches
- `feature/<short-description>`
- `fix/<short-description>`
- `chore/<short-description>`
- `refactor/<short-description>`

Keep branches short-lived and delete after merge.

## Worktrees
Use git worktrees for isolated parallel branches when multiple agents/sessions work independently.

## Pre-Commit Hygiene
Before commit:
```bash
git diff --staged
git diff --staged | grep -i "password\|secret\|api_key\|token"
npm test
npm run lint
npx tsc --noEmit
```

Use repo-specific equivalents.

## Generated Files
- Commit lockfiles, migrations, or generated files only if the repo expects them.
- Do not commit build output, `.env`, local IDE state, secrets, `node_modules`.
- `.gitignore` should cover common secrets/build artifacts.

## Debugging Commands
- `git bisect` for regressions.
- `git log --oneline -20` for recent history.
- `git diff HEAD~N..HEAD -- path` for scoped changes.
- `git blame path` for historical context.

## Change Summary
After work, report:
- changed files and purpose
- intentionally untouched related items
- verification run
- risks/gaps

## Verification
- Commit is atomic.
- Message explains why.
- Tests/checks pass.
- No secrets.
- No mixed unrelated changes.
