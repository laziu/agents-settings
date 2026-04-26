---
name: 4-test
description: Wrapper workflow for explicit invocation. Use when the user calls 4-test or wants step 4 of the agent workflow to prove behavior with tests, bug reproductions, and regression checks.
---

# 4 Test

Invoke `test-driven-development`.

New behavior:
1. Write a failing behavior test
2. Implement the minimum code to pass only if the user asked for fixes
3. Refactor with tests green

Bug fix:
1. Write a failing reproduction
2. Confirm failure
3. Fix only if the user asked for fixes
4. Confirm pass
5. Run regression checks

For browser behavior, also invoke `browser-testing-with-devtools`.
