---
name: local-environment
description: Use when a task will run local commands or choose among OS- or shell-specific syntax, search and data tools, language runtimes, or image and media utilities. Read the generated machine-local capability selections instead of rediscovering the current method each session.
---

# Local Environment

Resolve the profile as `$AGENTS_HOME/context/local-environment.md`, defaulting to `$HOME/.agents/context/local-environment.md` when `AGENTS_HOME` is unset.

1. Read the profile before selecting environment-sensitive commands and use its resolved method for the relevant task.
2. Treat it as a capability cache, not as permission, policy, or proof of current availability.
3. Let project instructions determine the project workflow. Let current session facts and observed command results override the generated profile.
4. Avoid probing capabilities already resolved unless exact compatibility matters or a recorded method fails.
5. If the profile is missing, run the generator from this Skill directory, then read the result:
   - PowerShell: `& "<skill-directory>\scripts\generate.ps1"`
   - Bash: `bash "<skill-directory>/scripts/generate.sh"`
6. If a recorded method is unavailable, verify the affected capability, rerun the generator, read the updated selection, and use it. If the profile cannot be refreshed, use the verified method for the current task without treating the stale entry as valid.

Do not block the task when the profile cannot be read or refreshed. Use minimal task-specific discovery.

When changing the generators or capability scope, read [profile-format.md](references/profile-format.md) and keep its output example synchronized.
