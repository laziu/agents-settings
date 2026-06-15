# Claude CLI Review

Use only when the user explicitly asks for Claude review or delegation.

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
- Generate a UUID; reuse it for the entire session
- Pipe prompts via stdin: `claude -p --session-id <uuid> --permission-mode plan --model <model> --effort <level> --output-format stream-json --include-partial-messages --verbose`
- For non-interactive web/source verification, add `--allowedTools WebFetch,WebSearch` or a scoped rule such as `WebFetch(domain:docs.github.com)`; headless `plan` mode can read and research, but web tools may still block on permission prompts unless explicitly allowed
- Set both `--model` and `--effort` explicitly; never rely on user defaults
- Use scoped paths with `--add-dir`; do not place positional prompts after variadic options
- Verify changed file paths locally before invocation; pass actual repo-relative paths, not expected template paths
- For subagent wrappers, parse line-delimited `stream-json`; treat valid assistant, tool, result, and partial-message events as progress
- Prefer an idle watchdog over a wall-clock timeout; abort only after no valid progress events for the configured stall window unless the caller set an explicit hard budget
- Prefer Claude `Read` over embedding file contents; raw embedding can fail silently and wastes tokens
- Avoid expandable PowerShell here-strings for markdown fences, backticks, or large text
- Delete `$HOME/.claude/projects/*/<uuid>.jsonl` after completion, failure, idle timeout, or abort

## Prompt

- State the call is non-interactive; ask for final text only
- Ask for skeptical critique within original scope
- Provide changed paths, user intent, Codex assumptions, verification run, and known residual risks

## After

- Apply actionable feedback within original scope; flag out-of-scope suggestions
- Report status, applied changes, skip/failure reason, and nonstandard details only
