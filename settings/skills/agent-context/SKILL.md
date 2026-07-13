---
name: agent-context
description: Agent context placement, cleanup, and durable behavior updates
---

# Agent Context

Use for Agent instructions, Skills, profiles, routing, and Agent-facing references.

## Ownership

- Profile `AGENTS.md` or `CLAUDE.md`: user-wide permissions and hard boundaries
- Project `AGENTS.md` or `CLAUDE.md`: repo-local commands, structure, conventions, boundaries, and verification
- Skill: reusable conditional workflow, tool integration, or non-obvious domain guardrail
- Reference: detail loaded only from a named owner
- Project docs: project knowledge and user-facing sources of truth

## Change Gate

- A direct context-update request approves that scope
- For inferred durable changes, first identify a repeated high-impact failure, target, behavior change, and verification
- Do not create durable rules from speculative preferences or one-off low-impact mistakes

## Retain

- Rules the model cannot infer from source, tools, tests, or higher-priority instructions
- Exact commands, paths, permission boundaries, tool contracts, and observed failure recovery

## Remove

- General best practices, model-default behavior, tool documentation, and generic process loops
- Repeated, stale, contradictory, unrelated, or unenforced instructions
- Checks better enforced by scripts, hooks, CI, schemas, or tests

## Verification

- Every retained rule changes local behavior or prevents a concrete local failure
- Each rule has one owner
- Skill metadata and references are valid
- Removed content does not weaken hard permission or safety boundaries
