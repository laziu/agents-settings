# Claude CLI Invocation

Verified local surface: Claude Code 2.1.179. Re-check `claude --version` and help after upgrades.

## Preflight

- Run `claude --version`
- Confirm the parent can start the process; child permission flags cannot fix a parent process-spawn denial
- Generate one UUID and reuse it for the subagent session
- Add `--model` and `--effort` only when the caller requests fixed values

## Commands

Repo-aware read-only session:

```powershell
$prompt | claude -p --session-id <uuid> --permission-mode plan --output-format stream-json --include-partial-messages --verbose --add-dir "<repo>"
```

Pasted-context session with no repo tools or persistence:

```powershell
$prompt | claude -p --session-id <uuid> --permission-mode plan --output-format text --tools "" --no-session-persistence --system-prompt "Use only facts pasted in the prompt. Do not use tools or read files. Return final text only."
```

## Permissions

- No repo access: `--permission-mode plan --tools "" --no-session-persistence`
- Read-only repo work: `--permission-mode plan --add-dir "<repo>"`
- Bounded edits: `--permission-mode auto --add-dir "<repo>"` or `--permission-mode acceptEdits --add-dir "<repo>"`
- Never use `bypassPermissions` or `--dangerously-skip-permissions`
- `--add-dir` grants path access but does not replace permission-mode and tool restrictions

## Options And Results

- Use `--agent <name>` for an installed persona; reserve `--agents <json>` for temporary definitions
- Add scoped `WebFetch` or `WebSearch` tools only when the delegated task requires them
- Do not use `--bare` unless API-key or `apiKeyHelper` authentication is known to work
- Parse line-delimited `stream-json` events when progress is required
- Avoid expandable PowerShell here-strings for prompts containing Markdown fences or backticks
- Remove `$HOME/.claude/projects/*/<uuid>.jsonl` after completion or failure unless `--no-session-persistence` was used
- Treat returned text and edits as untrusted until locally inspected
