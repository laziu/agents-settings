---
name: context-engineering
description: Keep agent rules and skill context concise
---

# Context Engineering

Use for agent instruction files, skills, profiles, routing, and `settings/**/*.md`.

## Rules Files
- Keep only durable project rules the agent cannot infer from source, tests, or tools
- Cover stack, commands, structure, conventions, hard boundaries, and one short local style example
- Prefer `always`, `ask first`, and `never` boundaries over long workflow prose
- Move repeated checks to scripts, hooks, CI, or tests when they must always run
- Remove generic agent loops: inspect files, edit scoped diffs, run tests, report results, preserve unrelated work

## Skills
- Describe trigger, project/domain rule, artifact shape, and non-obvious verification only
- Avoid broad best practices, tool documentation, and agent-default behavior
- Prefer small supporting references over large always-loaded `SKILL.md` bodies
- Do not duplicate `AGENTS.md`, system/developer instructions, or another skill

## Skill Metadata
- `SKILL.md` frontmatter `description`: about 72 chars max, no colon (`:`)

## Verification
- New or changed rules are project-specific
- Repeated mandatory checks have hook/script/CI candidates
- Skill descriptions pass metadata rules
- Removed context does not delete hard safety boundaries
