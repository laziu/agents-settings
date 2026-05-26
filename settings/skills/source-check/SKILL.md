---
name: source-check
description: Verify current API decisions with official docs
---

# Source Check

Use official sources when framework, runtime, browser, or API correctness depends on version or current behavior.

## Rules
- Identify exact package, runtime, or browser versions from project files
- Use narrow official docs, changelogs, migration guides, standards, or compatibility tables
- Cite full deep links for non-trivial choices
- Mark deprecated APIs, missing versions, docs/code conflicts, and unverified assumptions

## Source Order
1. Official docs
2. Official changelog, blog, or migration guide
3. Standards/platform references: MDN, web.dev, WHATWG
4. Runtime/browser compatibility data

Do not use Stack Overflow, tutorials, random blogs, AI summaries, or memory as primary authority.
