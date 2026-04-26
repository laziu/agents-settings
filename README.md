# AI Agent Harness

Shared personal settings for Codex CLI, Claude Code, and GitHub Copilot CLI.

Install scripts create symlinks from `settings/` into each tool profile. The repo stores canonical files only; no symlinks are stored in OneDrive.

## Layout

```text
settings/
  AGENTS.md                 shared global instructions
  skills/*/SKILL.md         shared skills
  commands/*.md             shared command prompts
  agents/shared/*.agent.md  Claude/Copilot agent profiles
  agents/codex/*.toml       Codex custom agents
  references/*.md           skill checklists
install.ps1|install.sh
uninstall.ps1|uninstall.sh
```

## Link Targets

| Tool | Installed links |
|---|---|
| Codex CLI | `%CODEX_HOME%\AGENTS.md`, `%AGENTS_HOME%\skills`, `%CODEX_HOME%\agents`, `%CODEX_HOME%\commands`, `%CODEX_HOME%\prompts` |
| Claude Code | `%CLAUDE_CONFIG_DIR%\CLAUDE.md`, `%CLAUDE_CONFIG_DIR%\skills`, `%CLAUDE_CONFIG_DIR%\agents`, `%CLAUDE_CONFIG_DIR%\commands` |
| GitHub Copilot CLI | `%COPILOT_HOME%\copilot-instructions.md`, `%COPILOT_HOME%\skills`, `%COPILOT_HOME%\agents` |

`settings/AGENTS.md` is installed as each tool's global instruction file. Reusable directories are linked as directories, so new files under `settings/skills/`, `settings/commands/`, `settings/agents/shared/`, and `settings/agents/codex/` appear without reinstalling. Codex custom agents remain TOML under `~/.codex/agents/` or `.codex/agents/`.

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
