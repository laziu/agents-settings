---
name: skill-router
description: Route work to the smallest useful set of skills
---

# Skill Router

Load explicitly named skills and all triggered skills. Use the smallest set that adds domain rules, workflow, or verification.

## Task Phases
Route by phase and trigger. Do not force a fixed skill order.

- Plan: define scope, requirements, acceptance, and Not Doing; design approach, interfaces, data, risks, decisions, and verification strategy; sequence into ordered tasks
- Build: implement, debug, migrate, simplify, review, test, and verify
- Deliver: configure gates, deployment, rollout, monitoring, and rollback
- Cross-cutting: use Knowledge, Version Control, and Domain Overlay skills whenever triggered

## Workflow Reference
- Read `settings/references/define-design-workflow.md` when specs, decisions, or numbered plans are created or updated
- Use it to classify plan type as `define`, `feature`, `change`, or `refactor`

## Routing Table

### Plan
- `specification`: standalone requirements, durable current truth, unclear scope, acceptance, MVP, or Not Doing
- `planning`: unstructured idea to Plan, technical approach, repository structure, data flow, contracts, risks, verification strategy, or durable plan
- `interface-design`: API/schema/command/event/file-format boundary
- `architecture-decision`: costly-to-reverse decision log or ADR promotion
- `source-check`: current framework/API docs needed
- `task-breakdown`: workflow or 작업 과정 from a stable plan, ordered executable tasks, dependencies, parallel work, checkpoints, likely files, or task artifacts

### Build
- `debugging`: unexpected failure
- `migration`: replace, remove, sunset, or consolidate legacy systems/APIs/features
- `code-simplify`: simplify working code without behavior changes

### Prove
- `testing`: behavior change, bug, edge case, or regression proof
- `code-review`: review
- `code-security`: security-sensitive boundaries, auth, PII, payments, uploads, external APIs, or storage
- `performance-optimization`: performance
- `browser-verification`: browser-rendered UI/runtime evidence

### Deliver
- `delivery`: CI/CD, required checks, deployment automation, launch readiness, rollout, monitoring, rollback, or production gate

### Knowledge
- `documentation`: docs, README, API docs, changelog, comments, specs, or gotchas
- `context-engineering`: AI context files that affect agent behavior, rules, `settings/**/*.md`, routing, or drift
- `context-improvement`: repeated friction, recovered failure, missed verification, routing drift, or approved context-update
- `project-context-bootstrap`: install shared repo AI context

### Version Control
- `version-control`: VCS state, diffs, tracked files, branches/streams, commits/changelists, conflicts, or history
- Commit/changelist creation requires an explicit user request

### Domain Overlays
- `ui-design`: UI/product surface
- `ue5-dev`: implementation, troubleshooting, validation, architecture, logs, assets, packaging, or general UE work
- `ue5-pcg`: PCG building generation
