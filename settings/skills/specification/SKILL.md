---
name: specification
description: Durable requirements, scope, acceptance criteria, and non-goals
---

# Specification

Use when requirements need a durable source of truth before design or implementation.

## Artifact

- Store a durable subsystem specification at `docs/specs/<subsystem>.md`
- Use `docs/specs/README.md` only as an index or cross-system overview
- Update the intended current state instead of appending clarification logs
- Record goals, non-goals, scope, actors, constraints, assumptions, required behavior, acceptance criteria, and unresolved questions that affect scope

## Boundary

- Stop after the spec for spec-only work
- Keep technical approach in `planning`
- Keep executable ordering in `task-breakdown`
- For implementation requests, create a separate spec only when the requirements need durable clarification

## Verification

- Scope and non-goals are explicit
- Acceptance criteria are testable
- Resolved questions are incorporated or removed
