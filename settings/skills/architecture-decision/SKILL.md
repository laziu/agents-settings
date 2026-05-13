---
name: architecture-decision
description: Record architecture decisions as ADRs
---

# Architecture Decision

Record why an expensive-to-reverse decision was made, what alternatives were rejected, and what consequences remain.

## Use When
- Significant architectural decision
- Framework, data model, auth, API style, build/deploy platform, or major dependency choice
- Public contract or user-facing behavior change needs durable rationale
- Existing ADR or major decision must be superseded, deprecated, or revisited

## Skip When
- Routine README, API docs, changelog, or comment updates with no architecture decision
- Small implementation choices that are easy to reverse
- Throwaway prototypes

## ADRs
Store ADRs in `docs/decisions/ADR-NNN-title.md` unless the project already has a different convention.

Template:
```markdown
# ADR-NNN: [Decision]

## Status
Proposed | Accepted | Superseded by ADR-NNN | Deprecated

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

Do not delete old ADRs. Supersede with a new ADR.

## Process
1. Identify the decision boundary and why it is hard to reverse
2. Capture constraints, requirements, and forces
3. Compare realistic alternatives
4. State the chosen decision plainly
5. Record consequences, follow-up work, and migration impact
6. Link related specs, docs, code, or previous ADRs

## Verification
- Decision is explicit
- Alternatives and rejection reasons are captured
- Consequences and follow-up work are listed
- Status and date are current
- Superseded decisions link to the newer ADR
