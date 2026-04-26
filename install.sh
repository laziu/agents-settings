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

link_skills() {
  local source_dir="$1"
  local destination_dir="$2"
  local source

  for source in "$source_dir"/*; do
    [ -d "$source" ] || continue
    link_path "$source" "$destination_dir/$(basename "$source")"
  done
}

link_markdown_agents() {
  local source_dir="$1"
  local destination_dir="$2"
  local extension="$3"
  local source
  local name

  for source in "$source_dir"/*.md; do
    [ -f "$source" ] || continue
    name="$(basename "$source")"
    [ "$name" != "README.md" ] || continue
    link_path "$source" "$destination_dir/$(basename "$source" .md)$extension"
  done
}

link_commands() {
  local source_dir="$1"
  local destination_dir="$2"
  local source

  for source in "$source_dir"/*.md; do
    [ -f "$source" ] || continue
    link_path "$source" "$destination_dir/$(basename "$source")"
  done
}

link_codex_agents() {
  local source_dir="$1"
  local destination_dir="$2"
  local source

  for source in "$source_dir"/*.toml; do
    [ -f "$source" ] || continue
    link_path "$source" "$destination_dir/$(basename "$source")"
  done
}

PROFILE_HOME="${HOME:?HOME is required}"
CODEX_HOME="${CODEX_HOME:-$PROFILE_HOME/.codex}"
CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$PROFILE_HOME/.claude}"
COPILOT_HOME="${COPILOT_HOME:-$PROFILE_HOME/.copilot}"
AGENTS_HOME="${AGENTS_HOME:-$PROFILE_HOME/.agents}"

POLICY_SOURCE="$ROOT/settings/AGENTS.md"
SKILLS_SOURCE="$ROOT/settings/skills"
AGENTS_SOURCE="$ROOT/settings/agents"
CODEX_AGENTS_SOURCE="$ROOT/settings/agents/codex"
COMMANDS_SOURCE="$ROOT/settings/commands"

if has_target codex; then
  link_path "$POLICY_SOURCE" "$CODEX_HOME/AGENTS.md"
  link_skills "$SKILLS_SOURCE" "$AGENTS_HOME/skills"
  link_codex_agents "$CODEX_AGENTS_SOURCE" "$CODEX_HOME/agents"
  link_commands "$COMMANDS_SOURCE" "$CODEX_HOME/commands"
  link_commands "$COMMANDS_SOURCE" "$CODEX_HOME/prompts"

  if [ "$INSTALL_CODEX_LEGACY_SKILLS" -eq 1 ]; then
    link_skills "$SKILLS_SOURCE" "$CODEX_HOME/skills"
  fi
fi

if has_target claude; then
  link_path "$POLICY_SOURCE" "$CLAUDE_CONFIG_DIR/CLAUDE.md"
  link_skills "$SKILLS_SOURCE" "$CLAUDE_CONFIG_DIR/skills"
  link_markdown_agents "$AGENTS_SOURCE" "$CLAUDE_CONFIG_DIR/agents" ".md"
  link_commands "$COMMANDS_SOURCE" "$CLAUDE_CONFIG_DIR/commands"
fi

if has_target copilot; then
  link_path "$POLICY_SOURCE" "$COPILOT_HOME/copilot-instructions.md"
  link_skills "$SKILLS_SOURCE" "$COPILOT_HOME/skills"
  link_markdown_agents "$AGENTS_SOURCE" "$COPILOT_HOME/agents" ".agent.md"
fi
