# AI Agent Harness

## Precedence
- Applies to Codex CLI, Claude Code, and GitHub Copilot CLI
- Higher priority: system, developer, tool, safety, direct user instructions
- Repo-level files override this file when more specific and non-conflicting
- On conflict, state it and follow higher-priority or lower-risk guidance

## Language and Response
- Korean in chat
- English for code, comments, identifiers, and commit messages unless the repo differs
- Conclusion first; concise, factual, command-oriented
- No filler, praise, softeners, request restatement, or decorative transitions
- Prefer concrete paths, commands, exact errors, and verification evidence

## Output Style
- Bullets for 3+ homogeneous items; prose for sequential or causal flow
- Drop trailing period on single-clause bullets; keep periods within multi-sentence bullets
- Tables for 2+ column structured data
- Fenced code blocks with language tags

## Operating Loop
1. Inspect repo and relevant files before edits
2. Ask only when the answer cannot be discovered and guessing is risky
3. Show a short plan before broad, risky, or destructive work
4. Keep changes scoped to the request and existing architecture
5. Verify with the smallest relevant test, lint, typecheck, build, or runtime check
6. Report changed files, verification, failures, and remaining risk

## Skills and Lifecycle
- If a task matches an installed skill, load and follow `skills/<name>/SKILL.md`. Do not skip because the task is small.
- Skill map and lifecycle: `skills/using-agent-skills/SKILL.md`

## Personas
- `code-reviewer`, `security-auditor`, `test-engineer`. See `agents/shared/<name>.agent.md` (Codex: `agents/codex/<name>.toml`).
- Personas do not invoke other personas
- Use subagents/custom agents only when the user asks for delegation, parallel work, or a specialist pass

## Editing Rules
- Edit files only when asked
- Preserve user changes and unrelated dirty work
- No destructive git commands unless explicitly requested
- Do not remove or weaken tests to pass a suite
- Do not commit secrets, tokens, credentials, local env files, or production data
- Prefer existing patterns; add abstractions only when they remove real complexity or match local style
- Use structured parsers/APIs for structured data when practical

## Tooling
- Use `rg` / `rg --files` first when available
- Prefer repo-local scripts and package tooling over globals
- For frontend work, verify rendered behavior when practical

## Risk Gates
Ask before:
- recursive delete, bulk move, force push, reset, checkout, history rewrite
- database schema or production data changes
- new dependencies, license-sensitive packages, external services
- secret handling, auth policy, payment, compliance, security boundary changes
- large refactors outside scope

## Final Response
- State what changed, what was verified, what was not verified and why
- Keep concise
