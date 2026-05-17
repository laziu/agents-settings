---
name: skill-router
description: Route work to the smallest useful set of skills
---

# Skill Router

Load explicitly named skills and all triggered skills. Use the smallest set that adds domain rules, workflow, or verification.

## Core Rules
- Ask only for outcome-changing ambiguity; otherwise state an assumption and proceed
- Push back with concrete downside + alternative
- Verify with evidence

## Task Phases
Route by phase and trigger. Do not force a fixed skill order.

- Planning: use Define and Design skills to clarify direction, specs, interfaces, decisions, and numbered plans
- Implementation: use Build and Prove skills to change code, debug, migrate, simplify, test, review, and verify
- Release: use Ship skills after implementation is proven
- Cross-cutting: use Knowledge, VCS, and Project Type skills whenever triggered

## Workflow Reference
- Read `settings/references/define-design-workflow.md` when specs, ADRs, or numbered plans are created or updated
- Use it to classify plan type as `define`, `feature`, `change`, or `refactor`

## Routing Table

### Define
- `ideate`: vague idea
- `specification`: new/significant work or unclear requirements
- `planning`: large, numbered, vague, or dependency-ordered work

### Design
- `interface-design`: API/schema/command/event/file-format boundary
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
- `architecture-decision`: significant architecture, platform, API, dependency, or public interface decision

### VCS
- `vcs-workflow`: VCS state, tracked files, commits/changelists, branches/streams, conflicts, or parallel work

### Project Types
- `ue5-dev`: implementation, troubleshooting, validation, architecture, logs, assets, packaging, or general UE work
- `ue5-pcg`: PCG building generation
