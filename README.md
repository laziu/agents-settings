# AI Agent Harness

Shared personal settings for Codex CLI, Claude Code, and GitHub Copilot CLI.

Install scripts create symlinks from `settings/` into each tool profile. The repo stores canonical files only; no symlinks are stored in OneDrive.

## Layout

```text
settings/
  AGENTS.md                 shared global instructions
  skills/*/SKILL.md         shared skills
  agents/shared/*.agent.md  Claude/Copilot agent profiles
  agents/codex/*.toml       Codex custom agents
  references/*.md           skill checklists
install.ps1|install.sh
install-project.ps1|install-project.sh
uninstall.ps1|uninstall.sh
uninstall-project.ps1|uninstall-project.sh
```

## Link Targets

### Global (tool profile)

| Tool | Installed links |
| --- | --- |
| Codex CLI | `%CODEX_HOME%\AGENTS.md`, `%AGENTS_HOME%\skills`, `%CODEX_HOME%\agents` |
| Claude Code | `%CLAUDE_CONFIG_DIR%\CLAUDE.md`, `%CLAUDE_CONFIG_DIR%\skills`, `%CLAUDE_CONFIG_DIR%\agents` |
| GitHub Copilot CLI | `%COPILOT_HOME%\copilot-instructions.md`, `%COPILOT_HOME%\skills`, `%COPILOT_HOME%\agents` |

`settings/AGENTS.md` is installed as each tool's global instruction file. Reusable directories are linked as directories, so new files under `settings/skills/`, `settings/agents/shared/`, and `settings/agents/codex/` appear without reinstalling. Skills are kept as reusable domain workflows, while normal agent behavior handles obvious planning, implementation, testing, and review steps. Codex custom agents remain TOML under `~/.codex/agents/` or `.codex/agents/`.

### Per-project (JetBrains IDE)

JetBrains AI features have no global instruction file; instructions are read from each project directory. Run `install-project` from a project root to add the links below.

| Tool | Installed link |
| --- | --- |
| GitHub Copilot (IDE plugin) | `<project>/.github/copilot-instructions.md` |
| Junie | `<project>/.junie/guidelines.md` |
| JetBrains AI Chat | `<project>/.ai/rules/harness.md` |

All three link to `settings/AGENTS.md`.

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

### Per-project (JetBrains IDE)

Run from the project root, or pass `-ProjectDir`/`--project-dir`.

```powershell
.\install-project.ps1 -DryRun
.\install-project.ps1
.\install-project.ps1 -Force
.\install-project.ps1 -ProjectDir C:\path\to\project
.\install-project.ps1 -Targets copilot,junie
```

```bash
./install-project.sh --dry-run
./install-project.sh
./install-project.sh --force
./install-project.sh --project-dir /path/to/project
./install-project.sh --targets copilot,junie
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

### Per-project uninstall (JetBrains IDE)

```powershell
.\uninstall-project.ps1 -DryRun
.\uninstall-project.ps1
.\uninstall-project.ps1 -ProjectDir C:\path\to\project
```

```bash
./uninstall-project.sh --dry-run
./uninstall-project.sh
./uninstall-project.sh --project-dir /path/to/project
```

Uninstall removes only links pointing to this repository.
