---
name: specification
description: Write durable specs for unclear or significant requirements
---

# Specification

Write or update the canonical source of truth: what, why, boundaries, and done.

Use after `ideate` when direction exists but requirements, boundaries, acceptance, or subsystem ownership need durable form.

## Scope
- Stop after the spec for spec-only work
- For implementation work, keep the spec lightweight
- Continue only after outcome-changing assumptions are accepted
- Leave task ordering and implementation slices to `planning`

## Specify
- Ask only when a reasonable assumption would materially change the result
- State assumptions with rationale, tradeoffs, and limits before using them
- Reframe vague asks as testable success criteria
- Use `docs/specs/README.md` plus `docs/specs/<subsystem>.md` when multiple subsystems or durable project docs are needed

Use localized titles in reading order:
1. Goals: user, problem, goals, non-goals, scope, success metrics
2. Definitions: terms, actors, constraints, assumptions
3. Analysis: context, options, tradeoffs, decisions, conclusions
4. Specification: functional behavior, non-functional requirements, use cases, acceptance criteria, operational boundaries
5. Other: project context, stack, commands, structure, style, testing, open questions, references

Fold conclusions, assumptions, and scope into the relevant sections.
Follow `AGENTS.md` style: one idea per bullet; testable criteria.

## Handoff
- Do not design task sequences inside the spec
- Use `planning` for numbered plans, dependencies, ordering, risks, and verification checkpoints
- Use `interface-design` for public API, schema, command, event, or document-format sections/specs
- Use `architecture-decision` for hard-to-reverse decisions and rejected alternatives

## Keep Spec Alive
- Update spec before implementing changed decisions/scope
- Merge clarification answers into relevant sections; remove resolved open questions
- Reference spec sections in PRs

## Verification
- Spec covers required areas
- Success criteria are testable
- Boundaries defined
- Spec saved and linked from relevant plans or ADRs
