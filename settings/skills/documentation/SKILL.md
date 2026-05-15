---
name: documentation
description: Maintain human-facing documentation
---

# Documentation

Document useful context, not the obvious what. Use `architecture-decision` for expensive-to-reverse design choices.

## Use When
- User asks for documentation, README updates, API docs, changelog notes, or explanatory comments
- Public API or user-facing behavior changed and docs should reflect it
- Repeated explanations should become durable project docs
- Specs, gotchas, onboarding, or project context need to stay current

## Avoid
- AI context files that affect agent behavior, such as agent instructions, skills, profiles, routing, or `settings/**/*.md`; use `context-engineering`
- Comments that restate code
- TODOs that should be done now
- Commented-out code
- Docs for throwaway prototypes

## Comments
- Comment non-obvious intent, constraints, invariants, and gotchas
- Do not comment self-explanatory operations
- Link complex gotchas to decision records when useful

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
- Links to decision records/specs

## Changelog
For releases, record Added/Changed/Fixed and issue/PR references.

## Project Context
Keep specs, decision links, and gotchas current so readers do not rediscover context.
- Integrate clarification answers into existing sections; avoid standalone answer logs unless the template requires them

## Verification
- README can boot the project
- Public APIs are documented
- Known gotchas are near relevant docs or code
- No stale TODO/commented-out examples in touched docs
- Docs match current conventions
