All rules live in `settings/AGENTS.md`. Load it as the active config when working in this repo.

- Skills: `settings/skills/` (router: `settings/skills/skill-router/SKILL.md`)
- Agents: `settings/agents/`
- Refs: `settings/references/`

`settings/` is installed via symlink by `install.ps1`/`install.sh` (e.g. `$CODEX_HOME/AGENTS.md`, `$CLAUDE_CONFIG_DIR/CLAUDE.md`). Root files are packaging/install scripts only.
