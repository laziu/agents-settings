---
name: architecture-decision
description: Capture durable architecture decisions and rationale
---

# Architecture Decision

Capture why an expensive-to-reverse decision was made, what alternatives were rejected, and what consequences remain.

## Use When
- Significant architectural decision
- Framework, data model, auth, API style, build/deploy platform, or major dependency choice
- Public contract or user-facing behavior change needs durable rationale
- Existing decision record or major decision must be superseded, deprecated, or revisited

## Skip When
- Routine README, API docs, changelog, or comment updates with no architecture decision
- Small implementation choices that are easy to reverse
- Throwaway prototypes

## Output
Prefer the project's existing decision record convention. If none exists and a standalone record is needed, `docs/decisions/ADR-NNN-title.md` is a reasonable default.

Fallback template:
```markdown
# [Decision]

## Status
Proposed | Accepted | Superseded | Deprecated

## Date
YYYY-MM-DD

## Context
[constraints, requirements, forces]

## Decision
[chosen approach]

## Alternatives Considered
- [option]: pros, cons, rejection reason

## Consequences
- [tradeoffs and follow-up work]
```

Do not delete old decision records. Supersede with a new record or note.

## Process
1. Identify the decision boundary and why it is hard to reverse
2. Capture constraints, requirements, and forces
3. Compare realistic alternatives
4. State the chosen decision plainly
5. Record consequences, follow-up work, and migration impact
6. Link related specs, docs, code, or previous records

## Verification
- Decision is explicit
- Alternatives and rejection reasons are captured
- Consequences and follow-up work are listed
- Status and date are current when a record exists
- Superseded decisions link to the newer record
