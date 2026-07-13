# Profile Format

Use this file as the output contract for both generators.

## Rules

- Cache one currently selected method per task.
- Include only cross-project choices that avoid repeated probing or failed commands.
- Probe software to resolve decisions; do not emit an inventory or versions.
- Do not list unused alternatives. If a selection fails, rerun the generator and replace it with the newly resolved method.
- Exclude project-specific tools, credentials, services, environment values, and volatile state.
- Let project instructions and current observations override the cache.

## Example

```markdown
# Local Environment

Generated: `2026-07-13T19:32:24+09:00`; project/session context wins.

## Host

- Platform: Windows X64 (Windows paths)
- Shell: `pwsh`
- POSIX shell: WSL `bash` (translate paths)

## Tasks

- Text search: `rg`
- Files: `rg --files`
- JSON: PowerShell (`ConvertFrom-Json`, `ConvertTo-Json`)
- VCS: `git`
- Scripting: `python`
- JavaScript: `node`
- Raster: `magick`
- Media: `ffmpeg`
```
