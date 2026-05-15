# AI Agent Harness

Compact shared context for agentic AI tools.

Install scripts create symlinks from `settings/` into each tool profile. The repo stores canonical files only; no symlinks are stored for archival purposes.

## Layout

```text
settings/
  AGENTS.md                 shared global instructions
  skills/*/SKILL.md         shared skills
  agents/shared/*.agent.md  Claude/Copilot agent profiles
  agents/codex/*.toml       Codex custom agents
  references/*.md           style guide and skill checklists
{install|uninstall}.{ps1|sh}
{install|uninstall}-project.{ps1|sh}
```

## Link Targets

### Global (tool profile)

| Tool | Installed links |
| --- | --- |
| Codex CLI | `%CODEX_HOME%\AGENTS.md`, `%AGENTS_HOME%\skills`, `%CODEX_HOME%\agents` |
| Claude Code | `%CLAUDE_CONFIG_DIR%\CLAUDE.md`, `%CLAUDE_CONFIG_DIR%\skills`, `%CLAUDE_CONFIG_DIR%\agents` |
| GitHub Copilot CLI | `%COPILOT_HOME%\copilot-instructions.md`, `%COPILOT_HOME%\skills`, `%COPILOT_HOME%\agents` |

`settings/AGENTS.md` is installed as each tool's global instruction file. Reusable directories are linked as directories, so new files under `settings/skills/`, `settings/agents/shared/`, and `settings/agents/codex/` appear without reinstalling. Skills are kept as reusable domain workflows and explicit shortcuts. Codex custom agents remain TOML under `~/.codex/agents/` or `.codex/agents/`.

### Per-project (JetBrains IDE)

JetBrains AI features have no global instruction file; instructions are read from each project directory. Run `install-project` from a project root to add the links below.

| Tool | Installed link |
| --- | --- |
| GitHub Copilot (IDE plugin) | `<project>/.github/copilot-instructions.md` |
| Junie | `<project>/.junie/guidelines.md` |
| JetBrains AI Chat | `<project>/.ai/rules/harness.md` |

All three link to `settings/AGENTS.md`.

## Install

### Windows

Global install:

```powershell
.\install.ps1 -DryRun
.\install.ps1
.\install.ps1 -Force
.\install.ps1 -InstallCodexLegacySkills
```

Per-project install:

Run from the project root, or pass `-ProjectDir`.

```powershell
.\install-project.ps1 -DryRun
.\install-project.ps1
.\install-project.ps1 -Force
.\install-project.ps1 -ProjectDir C:\path\to\project
.\install-project.ps1 -Targets copilot,junie
```

### Linux

Global install:

```bash
./install.sh --dry-run
./install.sh
./install.sh --force
./install.sh --codex-legacy-skills
```

Per-project install:

Run from the project root, or pass `--project-dir`.

```bash
./install-project.sh --dry-run
./install-project.sh
./install-project.sh --force
./install-project.sh --project-dir /path/to/project
./install-project.sh --targets copilot,junie
```

## Uninstall

### Windows

Global uninstall:

```powershell
.\uninstall.ps1 -DryRun
.\uninstall.ps1
```

Per-project uninstall:

```powershell
.\uninstall-project.ps1 -DryRun
.\uninstall-project.ps1
.\uninstall-project.ps1 -ProjectDir C:\path\to\project
```

### Linux

Global uninstall:

```bash
./uninstall.sh --dry-run
./uninstall.sh
```

Per-project uninstall:

```bash
./uninstall-project.sh --dry-run
./uninstall-project.sh
./uninstall-project.sh --project-dir /path/to/project
```

Uninstall removes only links pointing to this repository.
