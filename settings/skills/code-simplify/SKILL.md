---
name: code-simplify
description: Simplify code without behavior changes
---

# Code Simplification

Use as a behavior-preserving implementation mode.

## Rules
- Preserve inputs, outputs, side effects, ordering, and error behavior
- Follow project conventions and neighboring patterns
- Prefer explicit clarity over dense cleverness
- Do not optimize for line count
- Scope to requested/recently changed code
- Skip code already clear, not understood, about to be replaced, or hot-path slower after simplification
- Favor guard clauses, responsibility splits, clearer names, simpler conditionals, and removal of real duplication
- Keep comments that explain why; remove comments that only restate what
- Remove dead code only after confirmation
- Use automation/codemods instead of hand edits when touching more than 500 lines
