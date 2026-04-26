---
name: 6-review
description: Wrapper workflow for explicit invocation. Use when the user calls 6-review or wants step 6 of the agent workflow to review changes for correctness, quality, security, and performance before merge.
---

# 6 Review

Invoke `code-review-and-quality`.

Review staged/open changes, shelved changelists, recent commits, or the user-specified diff.

Check:
- Correctness
- Readability
- Architecture
- Security
- Performance

Output findings first with exact `file:line`, impact, and recommended fix. Do not edit files unless the user asks for fixes.
