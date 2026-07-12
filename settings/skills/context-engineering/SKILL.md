---
name: context-engineering
description: AGENTS, CLAUDE, skills, routing, and context ownership
---

# Context Engineering

Use for agent instructions, Skills, profiles, routing, and agent-facing references.

## Ownership

- Profile `AGENTS.md` or `CLAUDE.md`: user-wide bootstrap, routing, permissions, and hard boundaries
- Project `AGENTS.md` or `CLAUDE.md`: repo-local commands, structure, conventions, boundaries, and verification
- Skill: reusable conditional workflow, domain guardrail, artifact contract, or non-obvious verification
- Reference: detail loaded only from a named owner
- README, specs, and plans: project knowledge and user-facing sources of truth

## Keep

- Local rules the model cannot infer from source, tools, tests, or higher-priority instructions
- Exact commands, paths, artifact contracts, permission boundaries, routing, and domain-specific failure handling
- Skill metadata that distinguishes when the Skill must load

## Remove

- General best practices, model-default behavior, tool documentation, and generic inspect/edit/test loops
- Repeated, stale, contradictory, or unenforced instructions
- Detail unrelated to the Skill's trigger
- Prompt checks better enforced by scripts, hooks, CI, schemas, or tests

## Verification

- Every retained rule changes local behavior or prevents a concrete local failure
- Each rule has one owner
- Skill descriptions remain short and contain no colon
- Removed content does not weaken hard permission or safety boundaries
