#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
PROJECT_DIR="$(pwd -P)"
TARGETS_CSV="copilot,junie,ai"
FORCE=0
DRY_RUN=0
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

usage() {
  cat <<'USAGE'
Usage: ./install-project.sh [options]

Options:
  --project-dir PATH    Project directory to install into (default: current directory)
  --targets LIST        Comma-separated targets: copilot,junie,ai,all
  --force               Back up existing non-links and replace wrong links
  --dry-run             Print actions without changing files
  -h, --help            Show this help
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --project-dir)
      shift
      PROJECT_DIR="${1:?Missing value for --project-dir}"
      ;;
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
    all|copilot|junie|ai)
      REQUESTED+=("$target")
      ;;
    *)
      echo "Unknown target: $target. Valid targets: copilot, junie, ai, all" >&2
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

POLICY_SOURCE="$ROOT/settings/AGENTS.md"

if has_target copilot; then
  link_path "$POLICY_SOURCE" "$PROJECT_DIR/.github/copilot-instructions.md"
fi

if has_target junie; then
  link_path "$POLICY_SOURCE" "$PROJECT_DIR/.junie/guidelines.md"
fi

if has_target ai; then
  link_path "$POLICY_SOURCE" "$PROJECT_DIR/.ai/rules/harness.md"
fi
