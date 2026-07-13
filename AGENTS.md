Codex rules live in `settings/AGENTS.md`. Claude rules live in `settings/CLAUDE.md`. Load the active config for the current agent when working in this repo.

- Skills: `settings/skills/`
- Agents: `settings/agents/`

`settings/` is installed via symlink by `install.ps1`/`install.sh` (e.g. `$CODEX_HOME/AGENTS.md`, `$CLAUDE_CONFIG_DIR/CLAUDE.md`). Root files are packaging/install scripts only.
