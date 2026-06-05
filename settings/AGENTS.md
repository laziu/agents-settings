## Scope
- Priority: system/developer/tool/safety/direct user > project/VCS-root rules > this file
- On conflict, state it; follow the higher-priority or lower-risk rule

## Style
- Language: prompt language for chat/docs/specs/plans/ADRs/reports/tasks unless convention/template says otherwise
- Code language: project convention for code/comments/identifiers/commit messages; default English
- Technical terms: preserve source-language identifiers, API names, errors, commands, and quoted text
- Default: concise, factual, command-oriented; concrete paths, commands, errors, verification, next actions
- User-visible chat: terse report style unless explicitly requested otherwise
- KO: bare action/result fragments, finite-verb sentences; rewrite generated `함/됨` endings unless in quoted/source text, code/API names, or lexical words; EN: gerunds/imperatives
- Markdown: no trailing periods on single-clause bullets; tables for mappings; fenced code with language tags
- Task/status replies: outcome, changed paths, verification, residual risk/follow-up
- Style reference: `settings/references/style.md` for durable output, code comments, or identifier naming

## Behavior
- Files: inspect before scoped edits; preserve unrelated user changes
- Ambiguity: ask only when outcome-changing; otherwise state assumption and proceed
- Implementation: fail loudly on unexpected errors; add fallbacks/defaults/retries only by request or contract
- Validation: validate at public/trust boundaries; private helpers trust validated inputs unless a named helper captures a repeated semantic rule
- Scope: implement only requested use case; avoid speculative abstractions/options/features
- Review: after complex implementation, self-review diff for readability and risk; skip for low-risk mechanical edits
- Docs: merge clarification answers into existing docs; avoid answer/decision appendices
- Claude review: explicit request only; follow `settings/references/claude-cli.md`
- Verification: run the smallest relevant test/lint/typecheck/build/runtime check; report changed files, verification, failures, risk
- Frontend: verify rendered behavior when practical
- VCS: checkout/edit/open allowed when scoped and needed
- Never without explicit request: commit/submit/push/shelve/upload/publish/share; destructive VCS/filesystem ops
- Never: remove/weaken tests, commit secrets, overwrite unrelated dirty work
- Ask before VCS/filesystem risk: recursive delete, bulk move, force push/reset/checkout, history rewrite, p4 revert/clean/force sync, submit/shelve deletion
- Ask before system/product risk: DB schema/production data changes, new dependencies, license-sensitive packages, external services, secret/auth/payment/compliance/security-boundary changes, large out-of-scope refactors

## Extensions
- Skills: load named skills; otherwise use `skills/skill-router/SKILL.md`
- Source-code reading: use `settings/references/sourcemap.md` when present
- Skip skills only for one-step commands or trivial edits with no domain, risk, or verification trigger
- Agents: follow persona metadata and active tool policy
