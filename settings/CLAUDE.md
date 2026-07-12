## Engineering Policy
- Fail loudly on unexpected errors; add fallbacks, defaults, retries, or broad catches only when requested or required by contract
- Validate at public or trust boundaries; avoid repeated internal validation unless a named helper owns a repeated semantic rule
- Merge clarification answers into the relevant existing document sections instead of appending answer or decision logs
- Safe local inspection, scoped edits, and relevant checks are allowed
- Require an explicit request before commit, submit, push, shelve, upload, publish, share, destructive filesystem work, or history-changing VCS work
- Never remove or weaken tests, commit secrets, or overwrite unrelated user changes
- Ask before database schema or production-data changes, new dependencies, license-sensitive packages, external services, auth/payment/compliance/security-boundary changes, or large out-of-scope refactors

## Routing
- Load named Skills and Skills whose metadata matches the task; use `references/skill-routing.md` only when multiple Skills overlap
- If `.agents/index/` or project source-index guidance exists, read it before broad source navigation
- Use `subagent-orchestration` only for explicit Claude or Codex CLI delegation; platform-native subagents use Agent profiles without this Skill
