---
name: code-review
description: Review code for merge or release readiness
---

# Code Review and Quality

Approve when the change improves code health and has no blocking risk. Do not block on personal style.

## Review Axes
- Correctness: spec match, edge/error paths, races, state consistency, useful tests
- Readability: names, control flow, organization, simplicity, no dead artifacts
- Architecture: existing patterns, boundaries, dependencies, appropriate abstraction
- Security: input validation, output encoding, auth/authz, secrets, external data, dependency risk
- Performance: N+1, unbounded work, sync hot paths, unnecessary renders, pagination

## Process
1. Understand task/spec and expected behavior
2. Read tests first
3. Review implementation file by file
4. Check verification story
5. Categorize findings by severity

Do not edit files during review unless the user asks for fixes.

## Output
- Critical: block merge for security, data loss, or broken functionality
- Required: must fix before merge
- Optional/Nit/FYI: non-blocking

```markdown
**Verdict:** APPROVE | REQUEST CHANGES

## Critical
- file:line — Issue. Impact. Fix.

## Required
- file:line — Issue. Impact. Fix.

## Optional
- file:line — Suggestion.

## Verification Gaps
- [tests/build/manual checks missing]
```

## Extra Checks
- Keep refactors separate from feature/bug behavior
- Flag silent fallbacks that hide bugs, data loss, or unexpected errors
- Identify unreachable/unused code; ask before deleting uncertain code
- For new dependencies, check existing alternatives, size, maintenance, vulnerabilities, and license
- Avoid vague commit/PR summaries: `fix`, `update`, `phase 1`, `misc`

## Verification
- Critical fixed
- Required fixed or explicitly deferred
- Tests/build pass
- Verification story documented
