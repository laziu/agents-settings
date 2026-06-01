---
name: context-engineering
description: Keep agent rules and skill context concise
---

# Context Engineering

Use for agent instruction files, skills, profiles, routing, and `settings/**/*.md`.

## Ownership
- `AGENTS.md`: bootstrap, routing, hard boundaries
- Policy/reference files: durable local rules
- Skills: conditional workflow, domain guardrails, non-obvious verification
- README/specs: project facts and user-facing context

## Keep
- Rules local to the project, tooling, domain, or risk profile
- Content the agent cannot infer from source, tests, tools, higher-priority instructions, or normal agent behavior
- Stack, commands, structure, conventions, hard boundaries, and one local style example
- Skill trigger, domain rule, artifact shape, and verification that is not obvious
- `SKILL.md` frontmatter `description`: about 72 chars max, no colon (`:`)

## Remove
- Broad best practices, generic advice, tool documentation, and agent-default behavior
- Natural defaults: inspect before editing, preserve unrelated work, keep scope small, use clear names, run relevant checks, report outcomes, ask when blocked
- Rules that only say to be careful, concise, simple, robust, readable, or thorough without adding a local constraint
- Generic loops such as inspect, edit, and test cycles
- Rules repeated across `AGENTS.md`, policy files, skills, system/developer instructions, or nearby bullets
- Stale paths, repeated triggers, and full paths replaceable by root convention plus name
- Mandatory checks better enforced by scripts, hooks, CI, or tests
- Content true for most repos, tools, or agents unless it changes local behavior, risk, routing, or verification

## Optimize
- After editing context files, run a duplicated, verbose, and generic information pass
- Run a natural-default pass: remove any rule a competent agent would follow without repo-specific instruction
- Keep one owner for each rule
- Prefer shorter labels and tables over repeated full sentences when meaning stays clear

## Verification
- New or changed rules are local and not inferable
- Touched context files have a final duplicated/verbose/generic pass
- Repeated mandatory checks have hook/script/CI candidates
- Skill descriptions pass metadata rules
- Removed context does not delete hard safety boundaries
