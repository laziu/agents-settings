---
name: task-breakdown
description: Split plans into ordered executable tasks
---

# Task Breakdown

Turn a spec and technical plan into small, ordered, verifiable implementation tasks.

Use after `planning` or when requirements and technical approach are already clear. Stay read-only and stop before implementation unless asked to continue.

## Rules
- Use spec, plan, and relevant design artifacts as inputs
- Create phases: setup, foundation, one phase per user story, then polish
- Put blocking shared work before story work
- Keep each story independently implementable and testable
- Mark parallel tasks with `[P]` only when they touch different files and have no dependency
- Add checkpoints after foundation and each user story

## Artifact
- Default path: append to the active `docs/plans/PLAN-0001-type-title.md`
- Sections: `## Tasks`, `## Progress`, `## Verification`, and `## Outcome`
- Separate `tasks.md` only when project convention requires it or the Plan would become too large
- Task format: `- [ ] T001 [P?] [US?] Action in path/to/file`
- Include dependencies, parallel opportunities, independent test criteria, and MVP scope
- Include exact file paths when known
- Generate test tasks only when tests are requested, required by project policy, or needed as regression proof

## Split Heuristic
Split further when a task exceeds one focused session, has many acceptance points, mixes independent subsystems, or crosses unstable shared contracts.

## Verification
- Dependencies are ordered
- Parallel markers are safe
- Each user story has independent verification
- Checkpoints exist before implementation
