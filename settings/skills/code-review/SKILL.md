---
name: code-review
description: Review code for merge or release readiness
---

# Code Review and Quality

Review for merge or release blockers. Do not block on personal style.

## Review Axes
- Correctness: spec match, edge/error paths, races, state consistency, useful tests
- Readability: names, control flow, organization, simplicity, no dead artifacts
- Architecture: existing patterns, boundaries, dependencies, appropriate abstraction
- Security: input validation, output encoding, auth/authz, secrets, external data, dependency risk
- Performance: N+1, unbounded work, sync hot paths, unnecessary renders, pagination

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
- Flag silent fallbacks/defaults/retries/broad catches that hide bugs, data loss, or unexpected errors
- Flag duplicate parameter validation below a validated public/boundary entry point unless it names a repeated semantic rule
- Flag abstractions, generic helpers, configuration, or extra features not required by the current use case
- Identify unreachable/unused code; ask before deleting uncertain code
- For new dependencies, check existing alternatives, size, maintenance, vulnerabilities, and license

## Verification
- Findings include severity, file:line, impact, and fix
- Verification gaps are documented
- No files edited unless fixes were requested
