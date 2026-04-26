# AI Agent Harness

Shared personal settings for Codex CLI, Claude Code, and GitHub Copilot CLI.

Install scripts create symlinks from `settings/` into each tool profile. The repo stores canonical files only; no symlinks are stored in OneDrive.

## Layout

```text
settings/
  AGENTS.md                 shared global instructions
  skills/*/SKILL.md         shared skills
  commands/*.md             shared command prompts
  agents/*.md               Claude/Copilot agent profiles
  agents/codex/*.toml       Codex custom agents
  references/*.md           skill checklists
install.ps1|install.sh
uninstall.ps1|uninstall.sh
```

## Link Targets

| Tool | Installed links |
|---|---|
| Codex CLI | `%CODEX_HOME%\AGENTS.md`, `%AGENTS_HOME%\skills\*`, `%CODEX_HOME%\agents\*.toml`, `%CODEX_HOME%\commands\*.md`, `%CODEX_HOME%\prompts\*.md` |
| Claude Code | `%CLAUDE_CONFIG_DIR%\CLAUDE.md`, `%CLAUDE_CONFIG_DIR%\skills\*`, `%CLAUDE_CONFIG_DIR%\agents\*.md`, `%CLAUDE_CONFIG_DIR%\commands\*.md` |
| GitHub Copilot CLI | `%COPILOT_HOME%\copilot-instructions.md`, `%COPILOT_HOME%\skills\*`, `%COPILOT_HOME%\agents\*.agent.md` |

`settings/AGENTS.md` is installed as each tool's global instruction file. Codex custom agents remain TOML under `~/.codex/agents/` or `.codex/agents/`.

## Install

```powershell
.\install.ps1 -DryRun
.\install.ps1
.\install.ps1 -Force
.\install.ps1 -InstallCodexLegacySkills
```

```bash
./install.sh --dry-run
./install.sh
./install.sh --force
./install.sh --codex-legacy-skills
```

## Uninstall

```powershell
.\uninstall.ps1 -DryRun
.\uninstall.ps1
```

```bash
./uninstall.sh --dry-run
./uninstall.sh
```

Uninstall removes only links pointing to this repository.
