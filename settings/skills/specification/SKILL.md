---
name: specification
description: Create durable specs from ambiguous requirements
---

# Spec-Driven Development

Write the shared source of truth before code. A spec defines what, why, and done.

Use after `ideate` when direction exists but requirements, boundaries, or acceptance need durable form.

## Gated Workflow
```text
SPECIFY -> PLAN -> TASKS -> IMPLEMENT
```

For explicit spec-only work, stop after the spec unless the user asks to continue. For normal implementation work, keep the spec lightweight and continue only after outcome-changing assumptions are accepted.

## Specify
- Ask clarifying questions only when a reasonable assumption would materially change the result
- When proposing an assumption, explain why, tradeoffs, and limits, then ask whether to use it
- Reframe vague asks as testable success criteria

Spec format: localized titles in reading order.
1. Goals: user, problem, goals, non-goals, scope, success metrics
2. Definitions: terms, actors, constraints, assumptions
3. Analysis: context, options, tradeoffs, decisions, conclusions
4. Specification: functional behavior, non-functional requirements, use cases, acceptance criteria, operational boundaries
5. Other: project context, stack, commands, structure, style, testing, open questions, references

No standalone Conclusion/Assumptions/Scope; fold into Analysis/Definitions/Goals.
Style: follow `AGENTS.md` Output Style; one idea per bullet; testable criteria.

## Plan and Tasks
- Plan components, dependencies, implementation order, risks, parallel/sequential work, verification checkpoints
- Tasks fit one focused session, have acceptance and verification, follow dependencies, and touch <=~5 files when possible

Use `implementation`, `testing`, and focused context loading.

## Keep Spec Alive
- Update spec before implementing changed decisions/scope
- Merge clarification answers into relevant sections; remove resolved open questions
- Reference spec sections in PRs

## Verification
- Spec covers required areas
- Success criteria are testable
- Boundaries defined
- Spec saved in repo
- Human reviewed when required
