---
name: version-control-workflow
description: Structures Git and Perforce workflow for code changes, commits/submits, branches/streams, conflicts, and parallel work.
---

# Version Control Workflow

Use the project's version control system as save points, isolation, and durable change documentation.

## Use When
Any code change, commit, submit, changelist, branch, stream, conflict, or parallel work is involved.

## Detect VCS
Identify the project VCS before running VCS commands.
- Git: detect `.git` or use `git rev-parse --show-toplevel`
- Perforce: use `p4 info`, `p4 client -o`, and `p4 where <path>`; respect `P4CLIENT`, `P4PORT`, and `P4CONFIG`
- If no VCS is detected, keep file edits scoped and report that VCS verification was not available
- Do not assume Git just because a directory is a project

## Principles
- Prefer trunk-based development: deployable main/default branch or stream, short-lived feature branches/streams when supported
- Save each verified increment as a Git commit, Perforce pending changelist, or shelf when requested or appropriate
- Each commit/changelist does one logical thing
- Separate formatting, refactors, features, tests, and dependency changes where practical
- Feature flags are better than long-lived branches for incomplete work
- Preserve user/unrelated dirty work

## Change Size
- ~100 lines: ideal
- ~300 lines: acceptable if one logical change
- ~1000 lines: split

## Description
```text
<type>: <imperative summary>

<why/context/tradeoffs if useful>
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`.

## Branches and Streams
Git branches:
- `feature/<short-description>`
- `fix/<short-description>`
- `chore/<short-description>`
- `refactor/<short-description>`

Perforce:
- Prefer the existing client/workspace and stream
- Do not create streams, branches, or workspaces unless requested
- Use shelves for review or handoff when commits are not available

Keep branches and streams short-lived when the project uses them.

## Parallel Work
- Git: use worktrees for isolated parallel branches when multiple agents/sessions work independently
- Perforce: use separate clients/workspaces or shelved changelists for isolated parallel work

## Pre-Commit/Pre-Submit Hygiene
Git:
```bash
git diff --staged
git diff --staged | grep -i "password\|secret\|api_key\|token"
npm test
npm run lint
npx tsc --noEmit
```

Perforce:
```bash
p4 opened
p4 diff -du
p4 diff -du | grep -Ei "password|secret|api_key|token"
npm test
npm run lint
npx tsc --noEmit
```

Use project-specific equivalents.

## Generated Files
- Commit/submit lockfiles, migrations, or generated files only if the project expects them
- Do not commit build output, `.env`, local IDE state, secrets, `node_modules`
- `.gitignore` or `P4IGNORE` should cover common secrets/build artifacts

## Debugging Commands
Git:
- `git bisect` for regressions
- `git log --oneline -20` for recent history
- `git diff HEAD~N..HEAD -- path` for scoped changes
- `git blame path` for historical context

Perforce:
- `p4 changes -m 20 ...` for recent history
- `p4 filelog path` for file history
- `p4 annotate path` for line history
- `p4 diff -du path` for local opened changes

## Change Summary
After work, report:
- Changed files and purpose
- Intentionally untouched related items
- Verification run
- Risks/gaps

## Verification
- Commit/changelist/shelf is atomic when created
- Description explains why
- Tests/checks pass
- No secrets
- No mixed unrelated changes
- No unintended opened files in Perforce
