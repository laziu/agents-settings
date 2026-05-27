---
name: task-breakdown
description: Create semantic implementation steps from plans
---

# Task Breakdown

Turn a spec and technical plan into ordered, verifiable implementation steps.

Use after `planning` or when requirements and technical approach are already clear. Stay read-only and stop before implementation unless asked to continue.

## Rules
- Use spec, plan, and relevant design artifacts as inputs
- Group similar work into semantic steps with names that fit the work
- Put blocking shared work before dependent work
- Keep each step independently understandable and verifiable
- Keep file-level tasks inside the step as detailed actions, not separate top-level task IDs
- Add manual work only when the user must do something outside code or docs

## Artifact
- Default path: append to the active `docs/plans/PLAN-0001-type-title.md`
- Sections: `## Tasks`, `## Progress`, `## Verification`, and `## Outcome`
- Separate `tasks.md` only when project convention requires it or the Plan would become too large
- Step format: `### T01 <semantic step name> [ ]`
- Step body: goal, detailed actions, optional manual work, verification
- Include exact file paths in detailed actions when known
- Include dependencies, MVP scope, and independent test criteria
- Generate test tasks only when tests are requested, required by project policy, or needed as regression proof

## Split Heuristic
Split into another top-level step only when work has a distinct semantic goal, dependency boundary, manual checkpoint, or verification path.
Do not split merely because different files are touched.
Merge adjacent tiny steps when they are usually implemented and verified together.

## Verification
- Dependencies are ordered
- Detailed actions remain nested under semantic steps
- Each step has verification
- Manual work is explicit when needed
