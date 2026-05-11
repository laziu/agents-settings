---
name: documentation-and-adrs
description: Records durable decisions and context. Use when the user asks for docs/ADRs or a significant decision/API/user-facing change needs documentation.
---

# Documentation and ADRs

Document the why, not the obvious what.

## Use When
- Significant architectural decision
- Public API change
- User-facing behavior change
- Repeated explanations
- Onboarding humans or agents

## Avoid
- Comments that restate code
- TODOs that should be done now
- Commented-out code
- Docs for throwaway prototypes

## ADRs
Write ADRs for expensive-to-reverse decisions: framework, data model, auth, API style, build/deploy platform, major dependency.

Store in `docs/decisions/ADR-NNN-title.md`.

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

## Comments
- Comment non-obvious intent, constraints, invariants, and gotchas
- Do not comment self-explanatory operations
- Link complex gotchas to ADRs when useful

## API Docs
- Public functions/endpoints need inputs, outputs, errors, examples
- TypeScript: prefer inline type/JSDoc near the contract
- REST: keep OpenAPI/Swagger current for public APIs

## README
For durable projects, include:
- Project purpose
- Quick start
- Commands
- Architecture overview
- Contribution/process notes
- Links to ADRs/specs

## Changelog
For releases, record Added/Changed/Fixed and issue/PR references.

## Agent Context
Keep rules files, specs, ADRs, and gotchas current so agents do not rediscover decisions.
- Integrate clarification answers into existing sections; avoid standalone answer logs unless the template requires them

## Verification
- ADRs cover significant decisions
- README can boot the project
- Public APIs are documented
- Known gotchas are near relevant code
- No stale TODO/commented-out code
- Rules files match current conventions
