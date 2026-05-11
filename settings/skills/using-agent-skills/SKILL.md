---
name: using-agent-skills
description: Chooses whether a skill adds value. Use when the user asks about skill routing or a task needs explicit workflow selection.
---

# Using Agent Skills

Use skills only when they add task-specific knowledge, a durable workflow, or verification gates. Explicit user invocation wins. Load every triggered skill; domain and workflow skills can be combined.

## Skill Map
- Vague idea: `idea-refine`
- New project/feature/significant change or materially unclear requirements: `spec-driven-development`
- Large/vague work or implementation ordering: `planning-and-task-breakdown`
- Multi-file, risky, staged, or dependency-ordered implementation: `incremental-implementation`
- Behavior change, bug fix, edge case, or regression proof: `test-driven-development`
- Browser runtime/UI verification: `browser-testing-with-devtools`
- Unexpected failure: `debugging-and-error-recovery`
- Review: `code-review-and-quality`
- Security: `security-and-hardening`
- Performance: `performance-optimization`
- API/interface: `api-and-interface-design`
- UI: `frontend-ui-engineering`
- Docs/ADRs: `documentation-and-adrs`
- Version control: Git/Perforce checkout/edit/open, read-only tracked files, commits, submits, shelves, branches, streams, conflicts, or parallel work: `version-control-workflow`
- CI/CD: `ci-cd-and-automation`
- Launch: `shipping-and-launch`
- Context setup/rules/drift: `context-engineering`
- Doc-verified framework work: `source-driven-development`
- UE5 implementation, troubleshooting, validation, or architecture: `ue5-development`; add workflow skills when their triggers also apply

## Core Rules
- If ambiguity affects the outcome, propose a reasonable assumption, explain why, tradeoffs, and limits, then ask whether to proceed with that assumption
- Push back on approaches with concrete downside; propose alternatives
- Verify with evidence; "seems right" is not complete

Use the smallest skill set that covers every triggered condition. Skip only unrelated lifecycle skills.
