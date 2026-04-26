# AI Agent Harness

Personal settings for Codex CLI, Claude Code, and GitHub Copilot CLI.

The repository keeps one canonical source per artifact. Install scripts create symbolic links only in each agent profile directory. No symbolic links are stored inside this OneDrive-managed repository.

## Layout

```text
settings/
  AGENTS.md                    # Shared global instruction policy
  skills/*/SKILL.md            # Shared skills
  commands/*.md                # Shared command prompts
  agents/*.md                  # Claude/Copilot agent profiles
  agents/codex/*.toml          # Codex custom agent profiles
  references/*.md              # Checklists used by skills
install.ps1
uninstall.ps1
install.sh
uninstall.sh
skills-original/               # Upstream examples kept for comparison
```

## What Gets Linked

| Tool | Destination |
|---|---|
| Codex CLI | `%CODEX_HOME%\AGENTS.md`, `%AGENTS_HOME%\skills\*`, `%CODEX_HOME%\agents\*.toml`, `%CODEX_HOME%\commands\*.md`, `%CODEX_HOME%\prompts\*.md` |
| Claude Code | `%CLAUDE_CONFIG_DIR%\CLAUDE.md`, `%CLAUDE_CONFIG_DIR%\skills\*`, `%CLAUDE_CONFIG_DIR%\agents\*.md`, `%CLAUDE_CONFIG_DIR%\commands\*.md` |
| GitHub Copilot CLI | `%COPILOT_HOME%\copilot-instructions.md`, `%COPILOT_HOME%\skills\*`, `%COPILOT_HOME%\agents\*.agent.md` |

`settings/AGENTS.md` is the shared instruction source. It is installed as each tool's global instruction file to avoid maintaining separate duplicate policies.

Codex custom agents stay in TOML because Codex loads custom agents from standalone TOML files under `~/.codex/agents/` or `.codex/agents/`.

## Install

```powershell
.\install.ps1 -DryRun
.\install.ps1
```

```bash
./install.sh --dry-run
./install.sh
```

If a destination already exists:

```powershell
.\install.ps1 -Force
```

```bash
./install.sh --force
```

Optional legacy Codex skill path:

```powershell
.\install.ps1 -InstallCodexLegacySkills
```

```bash
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

Uninstall removes only links that point to this repository.
