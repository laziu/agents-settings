#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
PROJECT_DIR="$(pwd -P)"
TARGETS_CSV="copilot,junie,ai"
DRY_RUN=0

usage() {
  cat <<'USAGE'
Usage: ./uninstall-project.sh [options]

Options:
  --project-dir PATH    Project directory to uninstall from (default: current directory)
  --targets LIST        Comma-separated targets: copilot,junie,ai,all
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

POLICY_SOURCE="$ROOT/settings/AGENTS.md"

if has_target copilot; then
  remove_link_if_owned "$POLICY_SOURCE" "$PROJECT_DIR/.github/copilot-instructions.md"
fi

if has_target junie; then
  remove_link_if_owned "$POLICY_SOURCE" "$PROJECT_DIR/.junie/guidelines.md"
fi

if has_target ai; then
  remove_link_if_owned "$POLICY_SOURCE" "$PROJECT_DIR/.ai/rules/harness.md"
fi
