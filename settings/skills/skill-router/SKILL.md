---
name: skill-router
description: Route tasks to appropriate skills
---

# Skill Router

Load explicit user-named skills and every triggered skill. Use the smallest set that adds domain rules, workflow, or verification; combine triggered domain/workflow skills.

## Core Rules
- Ask only for outcome-changing ambiguity; otherwise state an assumption and proceed
- Push back with concrete downside + alternative
- Verify with evidence

## Workflow Order
Order triggered skills as listed; skip satisfied stages. Do not add earlier stages just because they appear earlier.

1. `ideate`: before unclear concepts become requirements
2. `specification`: before large or significant implementation
3. `planning`: before multi-step or dependency-ordered implementation
4. `implementation`: before proof or release
5. `testing`: before release when behavior can regress
6. `shipping`: after proof and release prep

## Routing Table

### Define
- `ideate`: vague idea
- `specification`: new/significant work or unclear requirements
- `planning`: large, vague, or dependency-ordered work

### Design
- `interface-design`: API/interface boundary
- `ui-design`: UI/product surface

### Build
- `implementation`: scoped build, refactor, wiring, migration, or fix
- `debugging`: unexpected failure
- `migration`: replace, remove, sunset, or consolidate legacy systems/APIs/features
- `code-simplify`: simplify working code without behavior changes

### Prove
- `testing`: behavior change, bug, edge case, or regression proof
- `code-review`: review
- `source-check`: framework/API docs needed
- `code-security`: security-sensitive boundaries, auth, PII, payments, uploads, external APIs, or storage
- `performance-optimization`: performance
- `browser-test`: browser/UI runtime verification

### Ship
- `ci-cd`: CI/CD
- `shipping`: launch/release

### Knowledge
- `documentation`: docs, README, API docs, changelog, comments, specs, or gotchas
- `context-engineering`: AI context files that affect agent behavior, rules, `settings/**/*.md`, routing, or drift
- `architecture-decision`: significant architecture, platform, API, dependency, or public contract decision

### VCS
- `vcs-workflow`: Git/Perforce, tracked files, commits, branches, conflicts, or parallel work

### Project Types
- `ue5-dev`: implementation, troubleshooting, validation, architecture, logs, assets, packaging, or general UE work
- `ue5-pcg`: PCG building generation
