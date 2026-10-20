# AI Agent Harness

Compact shared context for agentic AI tools.

Install scripts create symlinks from `settings/` into each tool profile. The repo stores canonical files only; no symlinks are stored for archival purposes.

## Layout

```text
settings/
  AGENTS.md                 shared global instructions
  CLAUDE.md                 Claude entrypoint importing AGENTS.md
  skills/*/SKILL.md         shared skills
  agents/shared/*.agent.md  Claude/Copilot agent profiles
  agents/codex/*.toml       Codex custom agents
  references/*.md           optional shared profile references
{install|uninstall}.{ps1|sh}
```

## Link Targets

| Tool | Installed links |
| --- | --- |
| Codex CLI | `%CODEX_HOME%\AGENTS.md`, `%CODEX_HOME%\references`, `%AGENTS_HOME%\skills`, `%CODEX_HOME%\agents` |
| Claude Code | `%CLAUDE_CONFIG_DIR%\CLAUDE.md`, `%CLAUDE_CONFIG_DIR%\AGENTS.md`, `%CLAUDE_CONFIG_DIR%\references`, `%CLAUDE_CONFIG_DIR%\skills`, `%CLAUDE_CONFIG_DIR%\agents` |
| GitHub Copilot CLI | `%COPILOT_HOME%\copilot-instructions.md`, `%COPILOT_HOME%\references`, `%COPILOT_HOME%\skills`, `%COPILOT_HOME%\agents` |
| Antigravity | `%GEMINI_CONFIG_DIR%\GEMINI.md`, `%GEMINI_CONFIG_DIR%\references`, `%GEMINI_CONFIG_DIR%\skills` |
| OpenCode | `%USERPROFILE%\.config\opencode\AGENTS.md` (`XDG_CONFIG_HOME` overrides `.config`), `%AGENTS_HOME%\skills` |

`settings/AGENTS.md` is installed for Codex, Copilot, Antigravity, and OpenCode. Claude Code receives the same file as `%CLAUDE_CONFIG_DIR%\AGENTS.md`, which `settings/CLAUDE.md` imports. OpenCode and Codex share Skills through `%AGENTS_HOME%\skills`. Each Skill and agent file is linked individually into the tool's `skills` or `agents` directory, so tool-managed entries (e.g., Claude `skills/synced`, plugin-installed agents) coexist and never land in this repo; rerun install after adding or removing one, which also prunes dangling links. `settings/references/` is linked as a directory, so new files there appear without reinstalling. Skills are kept as reusable domain workflows and explicit shortcuts. Codex custom agents remain TOML under `~/.codex/agents/` or `.codex/agents/`.

Global install also generates `$AGENTS_HOME/context/local-environment.md` (default `~/.agents/context/local-environment.md`). The `local-environment` Skill reads this machine-local capability cache before choosing environment-sensitive commands. The file is refreshed on each install, is not stored in this repository, and is retained by uninstall.

## Install

### Windows

```powershell
.\install.ps1 -DryRun
.\install.ps1
.\install.ps1 -Force
.\install.ps1 -Targets opencode
.\install.ps1 -InstallCodexLegacySkills
```

### Linux

```bash
./install.sh --dry-run
./install.sh
./install.sh --force
./install.sh --targets opencode
./install.sh --codex-legacy-skills
```

## Uninstall

### Windows

```powershell
.\uninstall.ps1 -DryRun
.\uninstall.ps1
```

### Linux

```bash
./uninstall.sh --dry-run
./uninstall.sh
```

Uninstall removes only links pointing to this repository.
