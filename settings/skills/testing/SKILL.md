---
name: testing
description: Behavior change, bug fix, edge case, regression proof
---

# Testing

Use when behavior changes, bug fixes, edge cases, or regressions need proof.

## Rules
- Prefer a failing behavior test before implementation; state why when impractical
- If the user asked only for tests or proof, do not fix production code unless asked
- Mock only slow, nondeterministic, or side-effecting boundaries
- Use `browser-verification` for rendered behavior, console, network, screenshot, accessibility, or browser performance
- Avoid tests that pass before implementation, bug fixes without failing reproduction, snapshot abuse, mocked business logic, shared mutable state, skipped tests, vague names, and async tests without `await`

## Verification
- No skipped/disabled tests
- Coverage not decreased when tracked
