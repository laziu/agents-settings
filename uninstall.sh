#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
TARGETS_CSV="codex,claude,copilot"
DRY_RUN=0
INCLUDE_CODEX_LEGACY_SKILLS=0

usage() {
  cat <<'USAGE'
Usage: ./uninstall.sh [options]

Options:
  --targets LIST                    Comma-separated targets: codex,claude,copilot,all
  --dry-run                         Print actions without changing files
  --codex-legacy-skills             Also remove links from $CODEX_HOME/skills
  --include-codex-legacy-skills     Alias for --codex-legacy-skills
  -h, --help                        Show this help
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --targets|--target)
      shift
      TARGETS_CSV="${1:?Missing value for --targets}"
      ;;
    --all)
      TARGETS_CSV="all"
      ;;
    --dry-run)
      DRY_RUN=1
      ;;
    --codex-legacy-skills|--include-codex-legacy-skills)
      INCLUDE_CODEX_LEGACY_SKILLS=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

normalize_target() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]'
}

IFS=',' read -r -a REQUESTED_RAW <<< "$TARGETS_CSV"
REQUESTED=()
for target in "${REQUESTED_RAW[@]}"; do
  target="$(normalize_target "$target")"
  [ -n "$target" ] || continue
  case "$target" in
    all|codex|claude|copilot)
      REQUESTED+=("$target")
      ;;
    *)
      echo "Unknown target: $target. Valid targets: codex, claude, copilot, all" >&2
      exit 1
      ;;
  esac
done

if [ "${#REQUESTED[@]}" -eq 0 ]; then
  echo "No targets selected" >&2
  exit 1
fi

has_target() {
  local needle="$1"
  local target
  for target in "${REQUESTED[@]}"; do
    if [ "$target" = "all" ] || [ "$target" = "$needle" ]; then
      return 0
    fi
  done
  return 1
}

abs_path() {
  local path="$1"
  local dir
  local base

  if [ -d "$path" ]; then
    (cd "$path" && pwd -P)
    return
  fi

  dir="$(dirname "$path")"
  base="$(basename "$path")"
  (cd "$dir" && printf '%s/%s\n' "$(pwd -P)" "$base")
}

resolve_link_target() {
  local link_path="$1"
  local target="$2"

  case "$target" in
    /*|[A-Za-z]:*)
      abs_path "$target"
      ;;
    *)
      abs_path "$(dirname "$link_path")/$target"
      ;;
  esac
}

remove_link_if_owned() {
  local source="$1"
  local destination="$2"
  local source_abs
  local current
  local current_abs

  if [ ! -e "$destination" ] && [ ! -L "$destination" ]; then
    printf 'MISS    %s\n' "$destination"
    return
  fi

  if [ ! -L "$destination" ]; then
    printf 'SKIP    %s is not a link\n' "$destination"
    return
  fi

  source_abs="$(abs_path "$source")"
  current="$(readlink "$destination")"
  current_abs="$(resolve_link_target "$destination" "$current")"

  if [ "$current_abs" != "$source_abs" ]; then
    printf 'SKIP    %s points elsewhere: %s\n' "$destination" "$current_abs"
    return
  fi

  printf 'REMOVE  %s\n' "$destination"
  if [ "$DRY_RUN" -ne 1 ]; then
    rm "$destination"
  fi
}

child_link_specs() {
  local source_dir="$1"
  local kind="$2"
  local pattern="${3:-*}"
  local source

  [ -d "$source_dir" ] || return 0

  if [ "$kind" = "file" ]; then
    for source in "$source_dir"/$pattern; do
      [ -f "$source" ] || continue
      printf '%s\t%s\n' "$(basename "$source")" "$source"
    done
    return
  fi

  for source in "$source_dir"/*; do
    [ -d "$source" ] || continue
    printf '%s\t%s\n' "$(basename "$source")" "$source"
  done
}

shared_agent_legacy_specs() {
  local source_dir="$1"
  local legacy_source_dir="$2"
  local extension="$3"
  local source
  local name

  [ -d "$source_dir" ] || return 0

  for source in "$source_dir"/*.agent.md; do
    [ -f "$source" ] || continue
    name="$(basename "$source" .agent.md)"
    printf '%s%s\t%s/%s.md\n' "$name" "$extension" "$legacy_source_dir" "$name"
  done
}

remove_directory_links() {
  local source_dir="$1"
  local destination_dir="$2"
  local legacy_specs="${3-}"
  local destination_name
  local source_path

  if [ ! -e "$destination_dir" ] && [ ! -L "$destination_dir" ]; then
    printf 'MISS    %s\n' "$destination_dir"
    return
  fi

  if [ -L "$destination_dir" ]; then
    remove_link_if_owned "$source_dir" "$destination_dir"
    return
  fi

  if [ ! -d "$destination_dir" ]; then
    printf 'SKIP    %s is not a link\n' "$destination_dir"
    return
  fi

  while IFS=$'\t' read -r destination_name source_path; do
    [ -n "$destination_name" ] || continue
    remove_link_if_owned "$source_path" "$destination_dir/$destination_name"
  done <<< "$legacy_specs"
}

PROFILE_HOME="${HOME:?HOME is required}"
CODEX_HOME="${CODEX_HOME:-$PROFILE_HOME/.codex}"
CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$PROFILE_HOME/.claude}"
COPILOT_HOME="${COPILOT_HOME:-$PROFILE_HOME/.copilot}"
AGENTS_HOME="${AGENTS_HOME:-$PROFILE_HOME/.agents}"

POLICY_SOURCE="$ROOT/settings/AGENTS.md"
SKILLS_SOURCE="$ROOT/settings/skills"
AGENTS_SOURCE="$ROOT/settings/agents"
SHARED_AGENTS_SOURCE="$ROOT/settings/agents/shared"
CODEX_AGENTS_SOURCE="$ROOT/settings/agents/codex"
COMMANDS_SOURCE="$ROOT/settings/commands"

LEGACY_SKILL_LINKS="$(child_link_specs "$SKILLS_SOURCE" directory)"
LEGACY_COMMAND_LINKS="$(child_link_specs "$COMMANDS_SOURCE" file "*.md")"
LEGACY_CODEX_AGENT_LINKS="$(child_link_specs "$CODEX_AGENTS_SOURCE" file "*.toml")"
LEGACY_CLAUDE_AGENT_LINKS="$(shared_agent_legacy_specs "$SHARED_AGENTS_SOURCE" "$AGENTS_SOURCE" ".md")"
LEGACY_COPILOT_AGENT_LINKS="$(shared_agent_legacy_specs "$SHARED_AGENTS_SOURCE" "$AGENTS_SOURCE" ".agent.md")"

if has_target codex; then
  remove_link_if_owned "$POLICY_SOURCE" "$CODEX_HOME/AGENTS.md"
  remove_directory_links "$SKILLS_SOURCE" "$AGENTS_HOME/skills" "$LEGACY_SKILL_LINKS"
  remove_directory_links "$CODEX_AGENTS_SOURCE" "$CODEX_HOME/agents" "$LEGACY_CODEX_AGENT_LINKS"
  remove_directory_links "$COMMANDS_SOURCE" "$CODEX_HOME/commands" "$LEGACY_COMMAND_LINKS"
  remove_directory_links "$COMMANDS_SOURCE" "$CODEX_HOME/prompts" "$LEGACY_COMMAND_LINKS"

  if [ "$INCLUDE_CODEX_LEGACY_SKILLS" -eq 1 ]; then
    remove_directory_links "$SKILLS_SOURCE" "$CODEX_HOME/skills" "$LEGACY_SKILL_LINKS"
  fi
fi

if has_target claude; then
  remove_link_if_owned "$POLICY_SOURCE" "$CLAUDE_CONFIG_DIR/CLAUDE.md"
  remove_directory_links "$SKILLS_SOURCE" "$CLAUDE_CONFIG_DIR/skills" "$LEGACY_SKILL_LINKS"
  remove_directory_links "$SHARED_AGENTS_SOURCE" "$CLAUDE_CONFIG_DIR/agents" "$LEGACY_CLAUDE_AGENT_LINKS"
  remove_directory_links "$COMMANDS_SOURCE" "$CLAUDE_CONFIG_DIR/commands" "$LEGACY_COMMAND_LINKS"
fi

if has_target copilot; then
  remove_link_if_owned "$POLICY_SOURCE" "$COPILOT_HOME/copilot-instructions.md"
  remove_directory_links "$SKILLS_SOURCE" "$COPILOT_HOME/skills" "$LEGACY_SKILL_LINKS"
  remove_directory_links "$SHARED_AGENTS_SOURCE" "$COPILOT_HOME/agents" "$LEGACY_COPILOT_AGENT_LINKS"
fi
