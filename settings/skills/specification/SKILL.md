---
name: specification
description: Define what to build, why, scope, and acceptance
---

# Specification

Write or update the current source of truth: what, why, users, scope, boundaries, and done.

Use when an idea, feature, product, process, or project direction needs durable requirements before planning or implementation.

## Scope
- Stop after the spec for spec-only work
- For implementation work, keep the spec lightweight
- Leave technical design to `planning`
- Leave execution order and implementation tasks to `task-breakdown`

## Specify
- Reframe vague asks as a crisp problem, user, goal, constraint, and success target
- Consider 2-3 directions only when direction is genuinely unclear
- Choose a recommended direction with MVP scope and explicit Not Doing items
- Turn vague asks into testable user stories, requirements, and success criteria
- Use `docs/specs/README.md` plus `docs/specs/<subsystem>.md` when multiple subsystems or durable project docs are needed

Use localized titles in reading order:
1. Goals: user, problem, goals, non-goals, scope, success metrics
2. Definitions: terms, actors, constraints, assumptions
3. Analysis: context, options, tradeoffs, decisions, conclusions
4. Specification: functional behavior, non-functional requirements, use cases, acceptance criteria, operational boundaries
5. Other: project context, stack, commands, structure, style, testing, open questions, references

Fold conclusions, assumptions, and scope into the relevant sections.

## Handoff
- Do not design task sequences inside the spec
- Use `planning` for technical approach, structure, data, contracts, risks, and decision candidates
- Use `interface-design` for public API, schema, command, event, or document-format sections/specs
- Use `references/framing-lenses.md` only when problem framing or option selection is stuck

## Keep Spec Alive
- Update spec before implementing changed decisions/scope
- Merge clarification answers into relevant sections; remove resolved open questions
- Reference spec sections in PRs

## Verification
- Spec covers required areas
- Success criteria are testable
- Spec saved and linked from relevant Plans
