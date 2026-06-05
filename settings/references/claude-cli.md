# Claude CLI Review

Use only when the user explicitly asks for Claude review or delegation.

## Invocation

- Check `claude --version`; report skip on failure
- Generate a UUID; reuse it for the entire session
- Pipe prompts via stdin: `claude -p --session-id <uuid> --permission-mode plan`
- Use scoped paths with `--add-dir`; do not place positional prompts after variadic options
- Prefer Claude `Read` over embedding file contents; raw embedding can fail silently and wastes tokens
- Avoid expandable PowerShell here-strings for markdown fences, backticks, or large text
- Delete `$HOME/.claude/projects/*/<uuid>.jsonl` after completion, failure, timeout, or abort

## Prompt

- State the call is non-interactive; ask for final text only
- Ask for skeptical critique within original scope
- Provide changed paths, user intent, Codex assumptions, verification run, and known residual risks

## After

- Apply actionable feedback within original scope; flag out-of-scope suggestions
- Report review status, changes, invocation path, and skip reason
