---
name: commit
description: Create VCS commits or changelists on explicit request
disable-model-invocation: true
---

# Commit

Invocation permits local change units only. Never push, submit, upload shelves, amend, reset, force, delete, checkout/revert, or rewrite history.

## Rules
- Preserve unrelated dirty work
- Detect VCS first: Git, Perforce, SVN, etc.
- Existing explicit unit: Git staged index, Perforce numbered changelist, or SVN changelist gets preserved as-is
- No explicit unit: group worktree/opened changes by logical change; create one commit/changelist per clear group
- Include only files/hunks for the current group; use patch staging for mixed Git files
- Leave unrelated, generated, exploratory, or ambiguous files untouched
- Stop on mixed unit scope, unsafe hunk split, conflicts, secrets, whitespace errors, or destructive/history requests

## Workflow
1. Inspect status: `git status --short`, `p4 opened`/`p4 diff -du`, or `svn status`
2. Inspect candidate diff before creating each unit
3. Run whitespace/conflict checks where supported and scan diff with `rg -i "password|secret|api_key|token"`
4. Git: commit staged index if present; otherwise stage each group and commit it
5. Perforce: create pending changelist per group; open/add/reopen files into it; never `p4 submit`
6. SVN: add/delete only current-group files as needed, then `svn changelist <name> <paths>`; never `svn commit` unless explicitly requested
7. Choose type by behavior impact, not file extension:
   - `feat`: new product/agent behavior, capability, route, skill, policy, or output rule
   - `fix`: incorrect, missing, unsafe, or conflicting behavior
   - `refactor`: behavior-preserving restructure, rename, compaction, or deduplication
   - `test`: verification code/data only
   - `docs`: human-facing documentation with no product/agent behavior impact
   - `chore`: packaging, installation, metadata, repository maintenance, or operations
8. Name/describe units as `<type>: <imperative summary>`; add body only for why/context/tradeoffs
9. Report created unit IDs/names, files, verification, and remaining work
