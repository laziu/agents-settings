---
name: spec-driven-development
description: Creates specs before coding for new projects, features, significant changes, or unclear requirements.
---

# Spec-Driven Development

Write the shared source of truth before code. A spec defines what, why, and done.

## Use When
- New project/feature/significant change
- Requirements are ambiguous
- Multiple files/modules affected
- Architectural decision needed
- Work likely exceeds ~30 minutes

## Skip When
Single-line fixes, typos, or self-contained unambiguous changes.

## Gated Workflow
```text
SPECIFY -> PLAN -> TASKS -> IMPLEMENT
```

Do not advance until the current phase is reviewed/validated when the change is non-trivial.

## Phase 1: Specify
- Ask clarifying questions until target user, success, scope, and constraints are concrete
- Reframe vague asks as testable success criteria

Spec format: localized titles in reading order.
1. Goals: user, problem, goals, non-goals, scope, success metrics
2. Definitions: terms, actors, constraints, assumptions
3. Analysis: context, options, tradeoffs, decisions, conclusions
4. Specification: functional behavior, non-functional requirements, use cases, acceptance criteria, operational boundaries
5. Other: project context, stack, commands, structure, style, testing, open questions, references

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
- Commit spec with code
- Reference spec sections in PRs

## Verification
- Spec covers required areas
- Success criteria are testable
- Boundaries defined
- Spec saved in repo
- Human reviewed when required
