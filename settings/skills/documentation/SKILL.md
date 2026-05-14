---
name: documentation
description: Maintain project documentation
---

# Documentation

Document useful context, not the obvious what. Use `architecture-decision` for ADRs and expensive-to-reverse design choices.

## Use When
- User asks for documentation, README updates, API docs, changelog notes, or explanatory comments
- Public API change
- User-facing behavior change
- Repeated explanations
- Onboarding humans
- Specs, gotchas, or project context need to stay current

## Avoid
- AI context files that affect agent behavior, such as agent instructions, skills, profiles, routing, or `settings/**/*.md`; use `context-engineering`
- Comments that restate code
- TODOs that should be done now
- Commented-out code
- Docs for throwaway prototypes

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

## Project Context
Keep specs, ADRs, and gotchas current so readers do not rediscover decisions.
- Integrate clarification answers into existing sections; avoid standalone answer logs unless the template requires them

## Verification
- README can boot the project
- Public APIs are documented
- Known gotchas are near relevant code
- No stale TODO/commented-out code
- Docs match current conventions
