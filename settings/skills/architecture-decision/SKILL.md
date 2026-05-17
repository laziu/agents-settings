---
name: architecture-decision
description: Record ADRs for hard-to-reverse architecture/API choices
---

# Architecture Decision

Record durable rationale for decisions that are costly to reverse.

Use for architecture, platform, dependency, data ownership, public API, compatibility, or migration choices. Use inline rationale instead of an ADR when the decision is local, obvious, or cheap to change.

## Process
1. Identify the decision boundary and why it is hard to reverse
2. Capture constraints, requirements, and forces
3. Compare realistic alternatives, including the rejected default
4. State the decision plainly
5. Record consequences, migration impact, follow-ups, and review date if needed
6. Link related specs, Plans, code, or previous ADRs

## Output
- Prefer project convention; otherwise use `docs/decisions/ADR-0001-title.md`
- Sections: status, date, context, decision, alternatives, consequences
- Status: proposed, accepted, superseded, deprecated
- Supersede with a new ADR or forward link; do not delete history

## Verification
- Decision is explicit
- Rejected alternatives have reasons
- Consequences, migration impact, and follow-ups are captured
- Status and date are current
- Superseded decisions link forward
