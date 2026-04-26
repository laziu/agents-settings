---
name: code-review-and-quality
description: Conducts multi-axis code review before merging code from humans or agents.
---

# Code Review and Quality

Approve when the change improves code health and has no blocking risk. Do not block on personal style.

## Use When
- Before merge
- After feature, refactor, or bug fix
- Reviewing agent/model output

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

## Severity
- Critical: blocks merge; security, data loss, broken functionality
- Required/no prefix: must address before merge
- Nit/Optional/Consider: optional
- FYI: informational

## Change Size
See `skills/version-control-workflow/SKILL.md`. Keep refactors separate from feature/bug behavior; accept large automated refactors or pure deletions only when intent is easy to verify.

## Commit/PR Description
- First line: short imperative summary
- Body: why, context, tradeoffs, links to issues/benchmarks/docs
- Avoid vague messages: `fix`, `update`, `phase 1`, `misc`

## Dead Code
After changes, identify unreachable/unused code. Ask before deleting anything uncertain.

## Dependency Review
Before adding a dependency, check:
- Existing stack alternative
- Size/bundle impact
- Maintenance activity
- Known vulnerabilities
- License compatibility

## Output

```markdown
## Review Summary
**Verdict:** APPROVE | REQUEST CHANGES

### Critical
- file:line — Issue. Impact. Fix.

### Required
- file:line — Issue. Impact. Fix.

### Optional
- file:line — Suggestion.

### Verification Gaps
- [tests/build/manual checks missing]
```

## Verification
- Critical fixed
- Required fixed or explicitly deferred
- Tests/build pass
- Verification story documented
