# Claude CLI Subagent

Use Claude as an advisory subagent for independent critique, architecture and requirements tradeoffs, security or correctness review, and other reasoning-heavy checks.

Verified local surface: Claude Code 2.1.159; re-verify on CLI upgrade.

## Routing

Choose the cheapest sufficient pair. Escalate for ambiguity, blast radius, repeated tool/search work, or hard-to-reverse decisions.

| Case | Use |
| --- | --- |
| Smoke, connection, quick lookup | `haiku --effort low` |
| Token/context optimization, narrow review, simple rewrite | `sonnet --effort medium` |
| Complex or correctness-sensitive review | `sonnet --effort high` |
| Bounded plan, architecture, unclear decision | `opus --effort high` |
| Exploratory planning, agentic coding, repeated tool/search work | `opus --effort xhigh` |
| Frontier problem | `opus --effort max` only on request or proven `xhigh` gap |

## Invocation

- Check `claude --version`; report skip on failure
- Generate a UUID; reuse it for the whole subagent session
- Use `--agent <name>` when a matching installed persona should own the session
- Use `--agents <json>` only for ad hoc persona definitions that should not become durable harness agents
- Pipe prompts via stdin:

```powershell
$prompt | claude -p --session-id <uuid> --permission-mode plan --model <model> --effort <level> --output-format stream-json --include-partial-messages --verbose --add-dir "<repo>"
```

- For pasted-context reviews where Claude should not inspect the repo, disable tools and persistence:

```powershell
$prompt | claude -p --session-id <uuid> --permission-mode plan --model <model> --effort <level> --output-format text --tools "" --no-session-persistence --system-prompt "Use only facts pasted in the prompt. Do not use tools or read files. Return final text only."
```

- Do not use `--bare` unless `ANTHROPIC_API_KEY` or `apiKeyHelper` auth is known to work; OAuth/keychain auth is skipped in bare mode
- For non-interactive web/source verification, add `--allowedTools WebFetch,WebSearch` or a scoped rule such as `WebFetch(domain:docs.github.com)`
- Set both `--model` and `--effort` explicitly; never rely on user defaults
- Use scoped paths with `--add-dir`; do not place positional prompts after variadic options
- Verify changed file paths locally before invocation; pass actual repo-relative paths
- For wrappers, parse line-delimited `stream-json`; treat valid assistant, tool, result, and partial-message events as progress
- Prefer an idle watchdog over a wall-clock timeout unless the caller set a hard budget
- Prefer Claude `Read` over embedding large file contents
- Avoid expandable PowerShell here-strings for markdown fences, backticks, or large text
- Delete `$HOME/.claude/projects/*/<uuid>.jsonl` after completion, failure, idle timeout, or abort unless `--no-session-persistence` was used

## After

- Treat Claude output as advisory
- Apply only actionable in-scope feedback
- Flag out-of-scope suggestions
- Report applied changes, skip/failure reason, and nonstandard flags
