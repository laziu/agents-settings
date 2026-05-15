---
name: code-simplify
description: Simplify code without behavior changes
---

# Code Simplification

Reduce complexity while preserving exact behavior. Simpler means faster to understand, not fewer lines.

## Principles
- Preserve inputs, outputs, side effects, ordering, and error behavior
- Follow project conventions and neighboring patterns
- Prefer explicit clarity over dense cleverness
- Do not optimize for line count
- Scope to requested/recently changed code
- Skip code already clear, not understood, about to be replaced, or hot-path slower after simplification

## Process
1. Understand responsibility, callers, callees, edge cases, tests, and history when needed
2. Identify opportunities
3. Apply one scoped simplification at a time
4. Run relevant tests and review the diff after meaningful changes
5. Revert and re-evaluate if tests fail, behavior changes, or clarity worsens

## Opportunities
- Deep nesting -> guard clauses or helpers
- Long functions -> split by responsibility
- Nested ternaries -> `if`/`switch`/lookup
- Generic/misleading names -> domain names
- Comments explaining "what" -> remove; comments explaining "why" -> keep
- Duplication, empty wrappers, speculative abstraction -> remove when it reduces real complexity
- Dead code -> remove only after confirmation

Use automation/codemods instead of hand edits when touching >500 lines.

## Verification
- Existing tests pass unchanged
- Build/lint pass
- Diff is scoped and reviewable
- No behavior or error handling weakened
- No unrelated churn
