# Codex CLI Invocation

Verified local surface: `codex-cli 0.135.0`. Re-check `codex --version` and help after upgrades.

## Preflight

- Run `codex --version`
- Confirm the parent can start the process; child sandbox flags cannot fix a parent process-spawn denial
- Use `codex exec` for a non-interactive task
- Pass generated or large prompts through stdin with `-`

## Permissions

- Read-only work: `--sandbox read-only`
- Project-root edits: `--sandbox workspace-write -C "<repo>"`
- Extra writable root: add only the required `--add-dir "<path>"`
- Put `-a never` or `--ask-for-approval never` before `exec` and pair it with a restrictive sandbox
- Never use `danger-full-access` or `--dangerously-bypass-approvals-and-sandbox`

## Commands

Read-only session with progress events:

```powershell
$prompt | codex -a never exec -C "<repo>" --ephemeral --json --sandbox read-only -
```

Workspace-write session with a final output file:

```powershell
$prompt | codex -a never exec -C "<repo>" --ephemeral --sandbox workspace-write --output-last-message "<tmp-output>" -
```

## Review

- Use `codex review` for a simple local review
- Use `codex exec review` when model selection, JSON events, ephemeral mode, or final-output capture is required
- Scope with `--uncommitted`, `--base <branch>`, or `--commit <sha>`
- Do not add `--sandbox` to `codex exec review`

```powershell
$prompt | codex review --uncommitted -
```

## Persona And Results

- `codex exec` has no direct `--agent` flag in the verified help
- Put the persona contract in the prompt, or use an intentionally configured `--profile`
- Do not assume `agents/*.toml` is selected automatically
- Inspect changed files and verify claims before accepting the result
- Remove temporary final-output files after consuming them
