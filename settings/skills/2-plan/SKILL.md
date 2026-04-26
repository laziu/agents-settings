---
name: 2-plan
description: Wrapper workflow for explicit invocation. Use when the user calls 2-plan or wants step 2 of the agent workflow to convert a spec or clear requirements into ordered, verifiable tasks.
---

# 2 Plan

Invoke `planning-and-task-breakdown`.

Read the spec and relevant code in read-only mode. Do not edit implementation files.

Output:
- Technical design borrowing TRD shape where useful
- ERD notes when persistent/domain data changes
- Dependency graph
- Vertical slices with acceptance criteria
- Verification steps
- Checkpoints
- Risks and open questions

Save task docs when the project has no better local convention:
- `tasks/plan.md`
- `tasks/todo.md`
