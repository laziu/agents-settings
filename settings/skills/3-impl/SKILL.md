---
name: 3-impl
description: Wrapper workflow for explicit invocation. Use when the user calls 3-impl or wants step 3 of the agent workflow to implement the next task incrementally with tests and verification.
---

# 3 Impl

Invoke `incremental-implementation` and `test-driven-development`.

For the next pending task or user-specified slice:
1. Read acceptance criteria and relevant code
2. Write a failing behavior test when behavior changes
3. Implement the minimum passing change
4. Run targeted tests, then relevant full checks
5. Run build/typecheck when applicable
6. Update task status or docs when the project tracks them
7. Save the completed increment to VCS only when requested or clearly appropriate

If a check fails, invoke `debugging-and-error-recovery`.
