# Codex CLI Subagent

Use Codex as a bounded implementation or repo-work subagent for scoped edits, local code navigation, test loops, source mapping, and VCS diff review.

Verified local surface: `codex-cli 0.135.0`; re-verify on CLI upgrade.

## Invocation

- Check `codex --version`; report skip on failure
- If the parent environment cannot start `codex`, skip delegation and report the parent sandbox failure; child `--sandbox` flags cannot fix process-spawn denial
- Prefer `codex exec` for non-interactive implementation or investigation
- Use stdin by passing `-` when prompts are large or generated
- Use `-C <dir>` to set the working root and `--add-dir <dir>` only for explicit extra writable roots
- Use `--ephemeral` for subagent runs that should not persist session files
- Use `--json` when the caller needs progress events; otherwise use `--output-last-message <file>` for the final response
- For `codex exec` agent tasks, use top-level `-a never` or `--ask-for-approval never` before `exec`; combine it with a restrictive sandbox
- Do not use `--sandbox danger-full-access` or `--dangerously-bypass-approvals-and-sandbox` for subagent subprocesses

## Child Permission Presets

| Need | Use |
| --- | --- |
| Advisory, search, review without edits | `--sandbox read-only` |
| Bounded edits inside the project root | `--sandbox workspace-write -C "<repo>"` |
| Bounded edits plus explicit extra writable roots | `--sandbox workspace-write -C "<repo>" --add-dir "<extra>"` |

- `workspace-write` allows project-root writes and still protects outside paths unless extra roots are declared
- A main agent may need broad parent permissions to spawn another CLI, but that does not justify broad child permissions
- Skip delegation when the work requires project-external writes that cannot be represented with explicit `--add-dir` roots
- Codex has no plan-mode equivalent; use `--sandbox read-only` when writes must be impossible

```powershell
$prompt | codex -a never exec -C "<repo>" --ephemeral --json --sandbox read-only -
```

```powershell
$prompt | codex -a never exec -C "<repo>" --ephemeral --sandbox workspace-write --output-last-message "<tmp-output>" -
```

## Review

- Use `codex review` for simple local review when event streaming and explicit model control are not required
- Use `codex exec review` when `--model`, `--json`, `--ephemeral`, or `--output-last-message` is needed; do not add `--sandbox`, which is not accepted by this subcommand
- Scope reviews with `--uncommitted`, `--base <branch>`, or `--commit <sha>`

```powershell
$prompt | codex review --uncommitted -
```

```powershell
$prompt | codex -a never exec review --uncommitted --ephemeral --json -
```

## Persona

- `codex exec` has no direct `--agent` flag in the verified local help
- Include the selected role persona in the prompt, or use `--profile <name>` only when a matching Codex config profile exists and was intentionally created
- Do not assume profile `agents/*.toml` is selected by CLI execution unless a command or profile explicitly routes to it

## After

- Inspect changed files before accepting Codex output
- Run or report the smallest relevant verification
- Preserve unrelated user changes
- Report changed paths, verification, and residual risks
