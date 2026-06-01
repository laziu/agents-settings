---
name: architecture-decision
description: Record hard-to-reverse decisions in Plans or ADRs
---

# Architecture Decision

Record costly-to-reverse choices.

Use for architecture, platform, dependency, data ownership, public API, compatibility, or migration choices. Use inline rationale when the decision is local, obvious, or cheap to change.

## Plan Decision
- Default location: active Plan `## Decisions`
- Fields: status, context, decision, rejected alternatives, consequences, follow-ups

## Promote To ADR
Create `docs/decisions/ADR-<YYMMDD>-<Title>.md` only when the decision outlives the current Plan and:
- Affects multiple Plans or subsystems
- Defines platform, dependency, public API, data ownership, or compatibility policy
- Needs supersede/deprecate history after the Plan is completed

ADR fields: status, date, context, decision, alternatives, consequences.

## Verification
- Decision boundary and reversal cost are explicit
- Rejected alternatives have reasons
- ADR promotion is justified or ruled out
