---
name: using-agent-skills
description: Discovers and invokes agent skills. Use when starting a session or choosing which workflow applies.
---

# Using Agent Skills

Use the smallest skill set that matches the task. Skills are workflows; follow their steps and verification gates.

## Skill Map
- Vague idea: `idea-refine`
- New project/feature/change or unclear requirements: `spec-driven-development`
- Task breakdown: `planning-and-task-breakdown`
- Implementation: `incremental-implementation`
- Tests/behavior change/bug proof: `test-driven-development`
- Browser runtime/UI verification: `browser-testing-with-devtools`
- Unexpected failure: `debugging-and-error-recovery`
- Review: `code-review-and-quality`
- Security: `security-and-hardening`
- Performance: `performance-optimization`
- API/interface: `api-and-interface-design`
- UI: `frontend-ui-engineering`
- Docs/ADRs: `documentation-and-adrs`
- Git/commits/branches: `git-workflow-and-versioning`
- CI/CD: `ci-cd-and-automation`
- Launch: `shipping-and-launch`
- Context setup/drift: `context-engineering`
- Doc-verified framework work: `source-driven-development`

## Core Rules
- Surface assumptions before non-trivial work
- Stop on conflicts or unclear requirements; name the issue and ask
- Push back on approaches with concrete downside; propose alternatives
- Prefer simple, boring solutions; abstractions must earn complexity
- Touch only requested scope
- Never remove code/comments you do not understand
- Verify with evidence; "seems right" is not complete

## Lifecycle
```text
idea-refine -> spec-driven-development -> planning-and-task-breakdown
-> context/source-driven-development -> incremental-implementation
-> test-driven-development -> code-review-and-quality
-> git-workflow-and-versioning -> documentation-and-adrs
-> shipping-and-launch
```

Use only the needed subset. Bug fixes often need only debugging -> TDD -> review.

## Failure Modes
- Silent assumptions
- Guessing through confusion
- Scope creep
- Over-engineering
- Building without acceptance criteria
- Skipping verification
