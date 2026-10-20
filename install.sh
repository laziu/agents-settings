#!/usr/bin/env bash
set -euo pipefail

# Git Bash copies instead of linking unless native symlinks are forced.
export MSYS=winsymlinks:nativestrict

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
TARGETS_CSV="codex,claude,copilot,antigravity,opencode"
FORCE=0
DRY_RUN=0
INSTALL_CODEX_LEGACY_SKILLS=0
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

usage() {
  cat <<'USAGE'
Usage: ./install.sh [options]

Options:
  --targets LIST                  Comma-separated targets: codex,claude,copilot,antigravity,opencode,all
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
    all|codex|claude|copilot|antigravity|opencode)
      REQUESTED+=("$target")
      ;;
    *)
      echo "Unknown target: $target. Valid targets: codex, claude, copilot, antigravity, opencode, all" >&2
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

is_settings_link() {
  local destination="$1"
  local current_abs

  [ -L "$destination" ] || return 1
  current_abs="$(resolve_link_target "$destination" "$(readlink "$destination")")"
  case "$current_abs" in
    "$SETTINGS_ROOT"/*) return 0 ;;
  esac
  return 1
}

# Link each child separately so tool-managed entries can share the directory.
link_children() {
  local source_dir="$1"
  local destination_dir="$2"
  local entry

  if [ -L "$destination_dir" ]; then
    if ! is_settings_link "$destination_dir" && [ "$FORCE" -ne 1 ]; then
      echo "Existing link points elsewhere: $destination_dir. Use --force to replace it." >&2
      exit 1
    fi

    printf 'UNLINK  %s\n' "$destination_dir"
    if [ "$DRY_RUN" -eq 1 ]; then
      for entry in "$source_dir"/*; do
        [ -e "$entry" ] || continue
        printf 'LINK    %s -> %s\n' "$destination_dir/$(basename "$entry")" "$(abs_path "$entry")"
      done
      return
    fi
    rm "$destination_dir"
  fi

  if [ -d "$destination_dir" ] && [ ! -L "$destination_dir" ]; then
    for entry in "$destination_dir"/*; do
      if is_settings_link "$entry" && [ ! -e "$entry" ]; then
        printf 'REMOVE  %s\n' "$entry"
        if [ "$DRY_RUN" -ne 1 ]; then
          rm "$entry"
        fi
      fi
    done
  fi

  for entry in "$source_dir"/*; do
    [ -e "$entry" ] || continue
    link_path "$entry" "$destination_dir/$(basename "$entry")"
  done
}

PROFILE_HOME="${HOME:?HOME is required}"
CODEX_HOME="${CODEX_HOME:-$PROFILE_HOME/.codex}"
CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$PROFILE_HOME/.claude}"
COPILOT_HOME="${COPILOT_HOME:-$PROFILE_HOME/.copilot}"
GEMINI_CONFIG_DIR="${GEMINI_CONFIG_DIR:-$PROFILE_HOME/.gemini}"
OPENCODE_CONFIG_HOME="${XDG_CONFIG_HOME:-$PROFILE_HOME/.config}/opencode"
AGENTS_HOME="${AGENTS_HOME:-$PROFILE_HOME/.agents}"

SETTINGS_ROOT="$ROOT/settings"
POLICY_SOURCE="$ROOT/settings/AGENTS.md"
CLAUDE_POLICY_SOURCE="$ROOT/settings/CLAUDE.md"
SKILLS_SOURCE="$ROOT/settings/skills"
REFERENCES_SOURCE="$ROOT/settings/references"
SHARED_AGENTS_SOURCE="$ROOT/settings/agents/shared"
CODEX_AGENTS_SOURCE="$ROOT/settings/agents/codex"
LOCAL_ENVIRONMENT_GENERATOR="$SKILLS_SOURCE/local-environment/scripts/generate.sh"

LOCAL_ENVIRONMENT_PROFILE="$AGENTS_HOME/context/local-environment.md"

if [ ! -f "$LOCAL_ENVIRONMENT_GENERATOR" ]; then
  echo "Local environment generator not found: $LOCAL_ENVIRONMENT_GENERATOR" >&2
  exit 1
fi

if [ "$DRY_RUN" -eq 1 ]; then
  bash "$LOCAL_ENVIRONMENT_GENERATOR" --output "$LOCAL_ENVIRONMENT_PROFILE" --dry-run
else
  bash "$LOCAL_ENVIRONMENT_GENERATOR" --output "$LOCAL_ENVIRONMENT_PROFILE"
fi

if has_target codex; then
  link_path "$POLICY_SOURCE" "$CODEX_HOME/AGENTS.md"
  link_path "$REFERENCES_SOURCE" "$CODEX_HOME/references"
  link_children "$CODEX_AGENTS_SOURCE" "$CODEX_HOME/agents"

  if [ "$INSTALL_CODEX_LEGACY_SKILLS" -eq 1 ]; then
    link_children "$SKILLS_SOURCE" "$CODEX_HOME/skills"
  fi
fi

if has_target claude; then
  link_path "$POLICY_SOURCE" "$CLAUDE_CONFIG_DIR/AGENTS.md"
  if [ -L "$CLAUDE_CONFIG_DIR/CLAUDE.md" ] &&
    [ "$(resolve_link_target "$CLAUDE_CONFIG_DIR/CLAUDE.md" "$(readlink "$CLAUDE_CONFIG_DIR/CLAUDE.md")")" = "$(abs_path "$POLICY_SOURCE")" ]; then
    printf 'RELINK  %s -> %s\n' "$CLAUDE_CONFIG_DIR/CLAUDE.md" "$(abs_path "$CLAUDE_POLICY_SOURCE")"
    if [ "$DRY_RUN" -eq 1 ]; then
      printf 'LINK    %s -> %s\n' "$CLAUDE_CONFIG_DIR/CLAUDE.md" "$(abs_path "$CLAUDE_POLICY_SOURCE")"
    else
      rm "$CLAUDE_CONFIG_DIR/CLAUDE.md"
      link_path "$CLAUDE_POLICY_SOURCE" "$CLAUDE_CONFIG_DIR/CLAUDE.md"
    fi
  else
    link_path "$CLAUDE_POLICY_SOURCE" "$CLAUDE_CONFIG_DIR/CLAUDE.md"
  fi
  link_path "$REFERENCES_SOURCE" "$CLAUDE_CONFIG_DIR/references"
  link_children "$SKILLS_SOURCE" "$CLAUDE_CONFIG_DIR/skills"
  link_children "$SHARED_AGENTS_SOURCE" "$CLAUDE_CONFIG_DIR/agents"
fi

if has_target copilot; then
  link_path "$POLICY_SOURCE" "$COPILOT_HOME/copilot-instructions.md"
  link_path "$REFERENCES_SOURCE" "$COPILOT_HOME/references"
  link_children "$SKILLS_SOURCE" "$COPILOT_HOME/skills"
  link_children "$SHARED_AGENTS_SOURCE" "$COPILOT_HOME/agents"
fi

if has_target antigravity; then
  link_path "$POLICY_SOURCE" "$GEMINI_CONFIG_DIR/GEMINI.md"
  link_path "$REFERENCES_SOURCE" "$GEMINI_CONFIG_DIR/references"
  link_children "$SKILLS_SOURCE" "$GEMINI_CONFIG_DIR/skills"
fi

if has_target opencode; then
  link_path "$POLICY_SOURCE" "$OPENCODE_CONFIG_HOME/AGENTS.md"
fi

if has_target codex || has_target opencode; then
  link_children "$SKILLS_SOURCE" "$AGENTS_HOME/skills"
fi
