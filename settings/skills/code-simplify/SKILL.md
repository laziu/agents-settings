---
name: code-simplify
description: Simplify code without behavior changes
---

# Code Simplification

Reduce complexity while preserving exact behavior. Simpler means faster to understand, not fewer lines.

## Use When
- Working code is harder to read, test, or maintain than needed
- Review flags complexity
- Recent changes introduced duplication or awkward structure

## Do Not Use When
- Code is already clear
- You do not understand behavior
- The simpler version would be measurably slower in a hot path
- The code is about to be replaced

## Principles
- Preserve inputs, outputs, side effects, ordering, and error behavior
- Follow project conventions and neighboring patterns
- Prefer explicit clarity over dense cleverness
- Do not optimize for line count
- Scope to requested/recently changed code

## Process
1. Understand responsibility, callers, callees, edge cases, tests, and history when needed
2. Identify opportunities
3. Scope to requested or recently changed code unless the user specifies broader scope
4. Apply one simplification at a time
5. Run relevant tests after each meaningful change
6. Review the diff after each meaningful simplification
7. Revert that simplification and re-evaluate if tests fail, behavior changes, or clarity gets worse

## Opportunities
- Deep nesting -> guard clauses or helpers
- Long functions -> split by responsibility
- Nested ternaries -> `if`/`switch`/lookup
- Boolean flag arguments -> options object or separate functions
- Generic/misleading names -> domain names
- Comments explaining "what" -> remove; comments explaining "why" -> keep
- Duplication -> shared helper when it removes real complexity
- Dead code -> remove only after confirmation
- Wrapper with no value -> inline
- Speculative abstraction -> delete

## Scale Rule
If refactor touches >500 lines, use automation/codemods instead of hand edits.

## Red Flags
- Tests need changes to pass
- Error handling removed
- Preferences replacing project conventions
- Many unrelated simplifications in one diff
- Adjacent cleanup outside scope

## Verification
- Existing tests pass unchanged
- Build/lint pass
- Diff is scoped and reviewable
- No behavior or error handling weakened
- No unrelated churn
