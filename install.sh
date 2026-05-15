#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
TARGETS_CSV="codex,claude,copilot"
FORCE=0
DRY_RUN=0
INSTALL_CODEX_LEGACY_SKILLS=0
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

usage() {
  cat <<'USAGE'
Usage: ./install.sh [options]

Options:
  --targets LIST                  Comma-separated targets: codex,claude,copilot,all
  --force                         Back up existing non-links and replace wrong links
  --dry-run                       Print actions without changing files
  --codex-legacy-skills           Also link skills into $CODEX_HOME/skills
  --install-codex-legacy-skills   Alias for --codex-legacy-skills
  -h, --help                      Show this help
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
    --force)
      FORCE=1
      ;;
    --dry-run)
      DRY_RUN=1
      ;;
    --codex-legacy-skills|--install-codex-legacy-skills)
      INSTALL_CODEX_LEGACY_SKILLS=1
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
  if [ -d "$dir" ]; then
    (cd "$dir" && printf '%s/%s\n' "$(pwd -P)" "$base")
    return
  fi

  case "$path" in
    /*|[A-Za-z]:*)
      printf '%s\n' "$path"
      ;;
    *)
      printf '%s/%s\n' "$PWD" "$path"
      ;;
  esac
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

link_path() {
  local source="$1"
  local destination="$2"
  local source_abs
  local current
  local current_abs
  local backup

  if [ ! -e "$source" ] && [ ! -L "$source" ]; then
    echo "Source not found: $source" >&2
    exit 1
  fi

  source_abs="$(abs_path "$source")"

  if [ -e "$destination" ] || [ -L "$destination" ]; then
    if [ -L "$destination" ]; then
      current="$(readlink "$destination")"
      current_abs="$(resolve_link_target "$destination" "$current")"
      if [ "$current_abs" = "$source_abs" ]; then
        printf 'OK      %s -> %s\n' "$destination" "$source_abs"
        return
      fi

      if [ "$FORCE" -ne 1 ]; then
        echo "Existing link points elsewhere: $destination -> $current_abs. Use --force to replace it." >&2
        exit 1
      fi

      printf 'RELINK  %s -> %s\n' "$destination" "$source_abs"
      if [ "$DRY_RUN" -ne 1 ]; then
        rm "$destination"
      fi
    else
      if [ "$FORCE" -ne 1 ]; then
        echo "Existing non-link path: $destination. Use --force to back it up and replace it." >&2
        exit 1
      fi

      backup="$destination.backup.$TIMESTAMP"
      printf 'BACKUP  %s -> %s\n' "$destination" "$backup"
      if [ "$DRY_RUN" -ne 1 ]; then
        mv "$destination" "$backup"
      fi
    fi
  fi

  printf 'LINK    %s -> %s\n' "$destination" "$source_abs"
  if [ "$DRY_RUN" -eq 1 ]; then
    return
  fi

  mkdir -p "$(dirname "$destination")"
  ln -s "$source_abs" "$destination"
}

remove_link_if_owned() {
  local source="$1"
  local destination="$2"
  local source_abs
  local current
  local current_abs

  if [ ! -e "$destination" ] && [ ! -L "$destination" ]; then
    return
  fi

  if [ ! -L "$destination" ]; then
    return
  fi

  source_abs="$(abs_path "$source")"
  current="$(readlink "$destination")"
  current_abs="$(resolve_link_target "$destination" "$current")"

  if [ "$current_abs" != "$source_abs" ]; then
    return
  fi

  printf 'REMOVE  %s\n' "$destination"
  if [ "$DRY_RUN" -ne 1 ]; then
    rm "$destination"
  fi
}

remove_directory_links() {
  local source_dir="$1"
  local destination_dir="$2"
  local legacy_specs="${3-}"
  local destination_name
  local source_path

  if [ ! -e "$destination_dir" ] && [ ! -L "$destination_dir" ]; then
    return
  fi

  if [ -L "$destination_dir" ]; then
    remove_link_if_owned "$source_dir" "$destination_dir"
    return
  fi

  if [ ! -d "$destination_dir" ]; then
    return
  fi

  while IFS=$'\t' read -r destination_name source_path; do
    [ -n "$destination_name" ] || continue
    remove_link_if_owned "$source_path" "$destination_dir/$destination_name"
  done <<< "$legacy_specs"
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

is_owned_legacy_dir() {
  local destination_dir="$1"
  local legacy_specs="${2-}"
  local entry
  local name
  local current
  local current_abs
  local expected_abs
  local matches
  local child_count=0
  local spec_count=0
  local destination_name
  local source_path
  declare -A expected_targets=()

  while IFS=$'\t' read -r destination_name source_path; do
    [ -n "$destination_name" ] || continue
    expected_targets["$destination_name"]+=$(printf '%s\n' "$(abs_path "$source_path")")
    spec_count=$((spec_count + 1))
  done <<< "$legacy_specs"

  [ -d "$destination_dir" ] && [ ! -L "$destination_dir" ] || return 1
  [ "$spec_count" -gt 0 ] || return 1

  while IFS= read -r -d '' entry; do
    child_count=$((child_count + 1))
    [ -L "$entry" ] || return 1
    name="$(basename "$entry")"
    [ -n "${expected_targets[$name]+set}" ] || return 1

    current="$(readlink "$entry")"
    current_abs="$(resolve_link_target "$entry" "$current")"
    matches=0
    while IFS= read -r expected_abs; do
      [ -n "$expected_abs" ] || continue
      if [ "$current_abs" = "$expected_abs" ]; then
        matches=1
        break
      fi
    done <<< "${expected_targets[$name]}"
    [ "$matches" -eq 1 ] || return 1
  done < <(find "$destination_dir" -mindepth 1 -maxdepth 1 -print0)

  [ "$child_count" -gt 0 ] || return 1
  return 0
}

remove_owned_legacy_dir() {
  local destination_dir="$1"
  local entry

  while IFS= read -r -d '' entry; do
    rm "$entry"
  done < <(find "$destination_dir" -mindepth 1 -maxdepth 1 -print0)
  rmdir "$destination_dir"
}

link_directory() {
  local source_dir="$1"
  local destination_dir="$2"
  local legacy_specs="${3-}"
  local source_abs

  if is_owned_legacy_dir "$destination_dir" "$legacy_specs"; then
    source_abs="$(abs_path "$source_dir")"
    printf 'MIGRATE %s owned legacy links\n' "$destination_dir"
    if [ "$DRY_RUN" -eq 1 ]; then
      printf 'LINK    %s -> %s\n' "$destination_dir" "$source_abs"
      return
    fi

    remove_owned_legacy_dir "$destination_dir"
  fi

  link_path "$source_dir" "$destination_dir"
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

LEGACY_SKILL_LINKS="$(child_link_specs "$SKILLS_SOURCE" directory)"
LEGACY_CODEX_AGENT_LINKS="$(child_link_specs "$CODEX_AGENTS_SOURCE" file "*.toml")"
LEGACY_CLAUDE_AGENT_LINKS="$(shared_agent_legacy_specs "$SHARED_AGENTS_SOURCE" "$AGENTS_SOURCE" ".md")"
LEGACY_COPILOT_AGENT_LINKS="$(shared_agent_legacy_specs "$SHARED_AGENTS_SOURCE" "$AGENTS_SOURCE" ".agent.md")"

if has_target codex; then
  link_path "$POLICY_SOURCE" "$CODEX_HOME/AGENTS.md"
  link_directory "$SKILLS_SOURCE" "$AGENTS_HOME/skills" "$LEGACY_SKILL_LINKS"
  link_directory "$CODEX_AGENTS_SOURCE" "$CODEX_HOME/agents" "$LEGACY_CODEX_AGENT_LINKS"

  if [ "$INSTALL_CODEX_LEGACY_SKILLS" -eq 1 ]; then
    link_directory "$SKILLS_SOURCE" "$CODEX_HOME/skills" "$LEGACY_SKILL_LINKS"
  fi
fi

if has_target claude; then
  link_path "$POLICY_SOURCE" "$CLAUDE_CONFIG_DIR/CLAUDE.md"
  link_directory "$SKILLS_SOURCE" "$CLAUDE_CONFIG_DIR/skills" "$LEGACY_SKILL_LINKS"
  link_directory "$SHARED_AGENTS_SOURCE" "$CLAUDE_CONFIG_DIR/agents" "$LEGACY_CLAUDE_AGENT_LINKS"
fi

if has_target copilot; then
  link_path "$POLICY_SOURCE" "$COPILOT_HOME/copilot-instructions.md"
  link_directory "$SKILLS_SOURCE" "$COPILOT_HOME/skills" "$LEGACY_SKILL_LINKS"
  link_directory "$SHARED_AGENTS_SOURCE" "$COPILOT_HOME/agents" "$LEGACY_COPILOT_AGENT_LINKS"
fi
