---
name: spec-driven-development
description: Creates or updates durable specs. Use when the user asks for a spec, or when a significant change has outcome-changing ambiguity or architecture decisions.
---

# Spec-Driven Development

Write the shared source of truth before code. A spec defines what, why, and done.

## Use When
- New project/feature/significant change
- Requirements are ambiguous in a way that affects implementation or acceptance
- Multiple files/modules affected
- Architectural decision needed
- Work needs a durable written source of truth

## Skip When
Single-line fixes, typos, or self-contained unambiguous changes.

## Gated Workflow
```text
SPECIFY -> PLAN -> TASKS -> IMPLEMENT
```

For explicit spec-only work, stop after the spec unless the user asks to continue. For normal implementation work, keep the spec lightweight and continue only after outcome-changing assumptions are accepted.

## Phase 1: Specify
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

## Phase 2: Plan
- Components and dependencies
- Implementation order
- Risks and mitigations
- Parallel vs sequential work
- Verification checkpoints

## Phase 3: Tasks
Each task:
- Fits one focused session
- Has acceptance criteria
- Has verification
- Is ordered by dependencies
- Touches <=~5 files when possible

## Phase 4: Implement
Use `incremental-implementation`, `test-driven-development`, and focused context loading.

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
