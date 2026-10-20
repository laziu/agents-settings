# AI Agent Harness

Personal context settings for AI coding agents.

## Layout

```text
settings/
  AGENTS.md                 shared global instructions
  CLAUDE.md                 Claude entrypoint importing AGENTS.md
  skills/*/SKILL.md         shared Skills
  agents/shared/*.agent.md  Claude/Copilot agent profiles
  agents/codex/*.toml       Codex custom agents
  references/*.md           optional shared profile references
{install|uninstall}.{ps1|sh}
```

## Link Targets

| Tool | Installed links |
| --- | --- |
| Codex CLI | `$CODEX_HOME/AGENTS.md`, `$CODEX_HOME/references`, `$CODEX_HOME/agents/*`, `$AGENTS_HOME/skills/*` |
| Claude Code | `$CLAUDE_CONFIG_DIR/AGENTS.md`, `$CLAUDE_CONFIG_DIR/CLAUDE.md`, `$CLAUDE_CONFIG_DIR/references`, `$CLAUDE_CONFIG_DIR/skills/*`, `$CLAUDE_CONFIG_DIR/agents/*` |
| GitHub Copilot CLI | `$COPILOT_HOME/copilot-instructions.md`, `$COPILOT_HOME/references`, `$COPILOT_HOME/skills/*`, `$COPILOT_HOME/agents/*` |
| Antigravity | `$GEMINI_CONFIG_DIR/GEMINI.md`, `$GEMINI_CONFIG_DIR/references`, `$GEMINI_CONFIG_DIR/skills/*` |
| OpenCode | `$XDG_CONFIG_HOME/opencode/AGENTS.md`, `$AGENTS_HOME/skills/*` |

- Defaults: `~/.codex`, `~/.claude`, `~/.copilot`, `~/.gemini`, `~/.config`, `~/.agents`
- Every target receives `settings/AGENTS.md`; Claude Code loads it through `settings/CLAUDE.md`
- `*`: one link per Skill or agent file, so tool-managed entries (e.g., Claude `skills/synced`) coexist. Rerun install after adding or removing one; it also prunes dangling links
- Install also generates `$AGENTS_HOME/context/local-environment.md` for the `local-environment` Skill; reinstall keeps lines you added, and uninstall keeps the file

## Install

Windows symlinks require Developer Mode or an elevated shell.

### PowerShell

```powershell
.\install.ps1 -DryRun                    # print actions only
.\install.ps1
.\install.ps1 -Force                     # back up non-links and replace foreign links
.\install.ps1 -Targets claude,codex      # codex, claude, copilot, antigravity, opencode
.\install.ps1 -InstallCodexLegacySkills  # also link Skills into $CODEX_HOME/skills
.\uninstall.ps1 -DryRun
.\uninstall.ps1
```

### Bash

```bash
./install.sh --dry-run
./install.sh
./install.sh --force
./install.sh --targets claude,codex
./install.sh --codex-legacy-skills
./uninstall.sh --dry-run
./uninstall.sh
```

Uninstall removes only links pointing to this repository.
