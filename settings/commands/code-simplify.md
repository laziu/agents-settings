---
description: Simplify code without behavior changes.
---

Invoke `code-simplification`.

Scope: recently changed code unless the user specifies broader scope.

Process:
1. Read project rules and neighboring patterns
2. Understand purpose, callers, edge cases, and tests
3. Simplify deep nesting, long functions, nested ternaries, generic names, duplication, and confirmed dead code
4. Apply changes incrementally
5. Run tests after each meaningful simplification
6. Verify build/lint and review the diff

If tests fail, revert that simplification and re-evaluate.
