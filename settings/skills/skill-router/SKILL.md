---
name: skill-router
description: Route tasks to appropriate skills
---

# Skill Router

Use skills only when they add task-specific knowledge, a durable workflow, or verification gates. Explicit user invocation wins. Load every triggered skill; domain and workflow skills can be combined.

## Flow
Default sequence for ambiguous work: `ideate` -> `specification` -> `planning` -> `implementation`; skip stages already satisfied. Use `testing` with `implementation` when behavior can regress.

## Skill Map
- Vague idea: `ideate`
- New project/feature/significant change or materially unclear requirements: `specification`
- Large/vague work or implementation ordering: `planning`
- Scoped implementation, refactor, wiring, migration, or fix: `implementation`
- Multi-file, risky, staged, or dependency-ordered implementation: `implementation`
- Behavior change, bug fix, edge case, or regression proof: `testing`
- Browser runtime/UI verification: `browser-test`
- Unexpected failure: `debugging`
- Review: `code-review`
- Security: `code-security`
- Performance: `performance-optimization`
- API/interface: `interface-design`
- UI: `ui-design`
- Documentation, README, API docs, changelog, comments, or agent context: `documentation`
- Architecture decisions/ADRs: `architecture-decision`
- Version control: Git/Perforce checkout/edit/open, read-only tracked files, commits, submits, shelves, branches, streams, conflicts, or parallel work: `vcs-workflow`
- CI/CD: `ci-cd`
- Launch: `shipping`
- Context setup/rules/drift: `context-engineering`
- Doc-verified framework work: `source-check`
- UE5 implementation, troubleshooting, validation, or architecture: `ue5-dev`; combine workflow skills when their triggers apply; skip for PCG building-only work
- UE5 PCG building generation: `ue5-pcg`; add `ue5-dev` only when general UE implementation, logs, packaging, or assets matter

## Core Rules
- If ambiguity affects the outcome, propose a reasonable assumption, explain why, tradeoffs, and limits, then ask whether to proceed with that assumption
- Push back on approaches with concrete downside; propose alternatives
- Verify with evidence; "seems right" is not complete

Use the smallest skill set that covers every triggered condition. Skip only unrelated flow skills.
