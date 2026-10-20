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
- For inferred durable changes, require either an observed recurring or high-impact failure, or a documented or evaluated method that adds non-obvious domain knowledge, decision steps, or evidence gates
- Popularity alone is insufficient; identify the scope, trigger, intended behavior, conflicts or side effects, and evaluation method
- Prefer evaluating a maintained Skill or plugin in its original form before distilling or forking it
- Do not create durable rules from speculative preferences or one-off low-impact mistakes

## Retain

- Rules the model cannot infer from source, tools, tests, or higher-priority instructions
- Methods that materially change decisions, actions, or verification and can be narrowly triggered
- Exact commands, paths, permission boundaries, tool contracts, and observed failure recovery

## Remove

- Generic advice that does not change a concrete decision, action, or check; redundant model-default behavior; tool documentation; and generic process loops
- Repeated, stale, contradictory, unrelated, or unenforced instructions
- Checks better enforced by scripts, hooks, CI, schemas, or tests

## Commit Type

- Classify by agent behavior impact, not file type: `feat` adds behavior or rules, `fix` corrects behavior, `refactor` preserves behavior
- Use `docs` only for purely explanatory changes with no agent behavior impact

## Verification

- Every retained rule changes local behavior or prevents a concrete local failure
- Each rule has one owner
- Skill metadata and references are valid
- Imported methods have bounded triggers, compatible side effects, and a practical evaluation path
- Removed content does not weaken hard permission or safety boundaries
