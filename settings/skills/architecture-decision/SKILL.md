---
name: architecture-decision
description: Capture durable architecture decisions and rationale
---

# Architecture Decision

Capture why an expensive-to-reverse decision was made, what alternatives were rejected, and what consequences remain.

## Process
1. Identify the decision boundary and why it is hard to reverse
2. Capture constraints, requirements, and forces
3. Compare realistic alternatives
4. State the chosen decision plainly
5. Record consequences, follow-up work, and migration impact
6. Link related specs, docs, code, or previous records

## Output
- Prefer existing project convention; use inline rationale when a standalone record is unnecessary
- If no convention exists and a record is needed, use `docs/decisions/ADR-NNN-title.md`
- Keep sections minimal: status, date, context, decision, alternatives, consequences
- Supersede old records with a new record or note; do not delete history

## Verification
- Decision is explicit
- Alternatives, rejection reasons, consequences, and follow-ups are captured
- Status and date are current when a record exists
- Superseded decisions link forward
