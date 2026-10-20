#!/usr/bin/env bash
# Output contract and capability selection rationale:
# ../references/profile-format.md

set -euo pipefail

output_path=""
dry_run=0

usage() {
  cat <<'USAGE'
Usage: generate.sh [--output PATH] [--dry-run]
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --output)
      shift
      output_path="${1:?Missing value for --output}"
      ;;
    --dry-run)
      dry_run=1
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

agents_home="${AGENTS_HOME:-${HOME:?HOME is required}/.agents}"
if [ -z "$output_path" ]; then
  output_path="$agents_home/context/local-environment.md"
fi

case "$output_path" in
  /*) ;;
  *) output_path="$PWD/$output_path" ;;
esac

output_dir="$(dirname "$output_path")"
owned_keys="Platform|Shell|Bash|POSIX shell|Text search|Files|JSON|VCS|Scripting|JavaScript|Raster|Media"

existing_keys() {
  tr -d '\r' < "$output_path" | sed -n -E 's/^- ([^:]+):.*/\1/p'
}

action="GENERATE"
if [ -s "$output_path" ]; then
  action="MERGE"
  merge_error=""
  for heading in "# Local Environment" "## Host" "## Tasks"; do
    if ! tr -d '\r' < "$output_path" | grep -qxF "$heading"; then
      merge_error="missing '$heading'"
      break
    fi
  done
  if [ -z "$merge_error" ]; then
    duplicate_key="$(existing_keys | grep -xE "$owned_keys" | sort | uniq -d | head -n 1)"
    if [ -n "$duplicate_key" ]; then
      merge_error="duplicate '- $duplicate_key:'"
    fi
  fi
  if [ -n "$merge_error" ]; then
    echo "Cannot merge existing $output_path: $merge_error. Move it to $output_dir/local-environment.save.md and rerun." >&2
    exit 1
  fi
fi

if [ "$dry_run" -eq 1 ]; then
  printf '%s %s\n' "$action" "$output_path"
  exit 0
fi

probe_first_line() {
  local command_name="$1"
  local output

  command -v "$command_name" >/dev/null 2>&1 || return 1
  if ! output=$("$@" 2>&1); then
    return 1
  fi

  printf '%s\n' "$output" | sed -n '/[^[:space:]]/{s/\r$//;p;q;}'
}

os_name="$(uname -s)"
kernel_release="$(uname -r)"
architecture="$(uname -m)"
shell_name="$(basename "${SHELL:-bash}")"

if [[ "$kernel_release" == *microsoft* || "$kernel_release" == *Microsoft* ]]; then
  platform="Linux under WSL $architecture"
else
  platform="$os_name $architecture"
fi

bash_probe="$(probe_first_line bash --version || true)"
rg_probe="$(probe_first_line rg --version || true)"
fd_probe="$(probe_first_line fd --version || true)"
jq_probe="$(probe_first_line jq --version || true)"
git_probe="$(probe_first_line git --version || true)"
node_probe="$(probe_first_line node --version || true)"
bun_probe="$(probe_first_line bun --version || true)"
ffmpeg_probe="$(probe_first_line ffmpeg -version || true)"

python_command=""
for candidate in python3 python; do
  probe="$(probe_first_line "$candidate" --version || true)"
  if [ -n "$probe" ]; then
    python_command="$candidate"
    break
  fi
done

pillow_probe=""
if [ -n "$python_command" ]; then
  pillow_probe="$(probe_first_line "$python_command" -c 'import PIL; print(PIL.__version__)' || true)"
fi

image_magick_command="magick"
image_magick_probe="$(probe_first_line magick -version || true)"
if [ -z "$image_magick_probe" ]; then
  convert_probe="$(probe_first_line convert -version || true)"
  if [[ "$convert_probe" == *ImageMagick* ]]; then
    image_magick_command="convert"
    image_magick_probe="$convert_probe"
  fi
fi

lines=(
  "# Local Environment"
  ""
  "Generated: \`$(date '+%Y-%m-%dT%H:%M:%S%z')\`; project/session context wins."
  ""
  "## Host"
  ""
  "- Platform: $platform (Unix paths)"
  "- Shell: \`$shell_name\`"
)

if [ -z "$bash_probe" ]; then
  lines+=("- Bash: unavailable")
else
  lines+=("- Bash: \`bash\`")
fi

lines+=("")
lines+=("## Tasks")
lines+=("")

if [ -z "$rg_probe" ]; then
  lines+=("- Text search: \`grep -R\`")
else
  lines+=("- Text search: \`rg\`")
fi

if [ -n "$rg_probe" ]; then
  lines+=("- Files: \`rg --files\`")
elif [ -n "$fd_probe" ]; then
  lines+=("- Files: \`fd\`")
else
  lines+=("- Files: \`find\`")
fi

if [ -n "$jq_probe" ]; then
  lines+=("- JSON: \`jq\`")
elif [ -n "$python_command" ]; then
  lines+=("- JSON: \`$python_command\` (json)")
else
  lines+=("- JSON: unresolved")
fi

if [ -z "$git_probe" ]; then
  lines+=("- VCS: unresolved")
else
  lines+=("- VCS: \`git\`")
fi

if [ -z "$python_command" ]; then
  lines+=("- Scripting: \`$shell_name\`")
else
  lines+=("- Scripting: \`$python_command\`")
fi

if [ -n "$node_probe" ]; then
  lines+=("- JavaScript: \`node\`")
elif [ -n "$bun_probe" ]; then
  lines+=("- JavaScript: \`bun\`")
else
  lines+=("- JavaScript: unresolved")
fi

if [ -n "$image_magick_probe" ]; then
  lines+=("- Raster: \`$image_magick_command\`")
elif [ -n "$pillow_probe" ]; then
  lines+=("- Raster: \`$python_command\` (Pillow)")
else
  lines+=("- Raster: unresolved")
fi

if [ -z "$ffmpeg_probe" ]; then
  lines+=("- Media: unresolved")
else
  lines+=("- Media: \`ffmpeg\`")
fi

# Replace owned lines in place, append missing ones to their section, and keep every other line.
merge_profile() {
  awk -v owned="$owned_keys" -v present="$(existing_keys | paste -sd '|' -)" '
    BEGIN {
      n = split(owned, list, "|"); for (i = 1; i <= n; i++) is_owned[list[i]] = 1
      n = split(present, list, "|"); for (i = 1; i <= n; i++) is_present[list[i]] = 1
    }
    function line_key(line) { return substr(line, 3, index(line, ":") - 3) }
    function flush(   n, i, keys) {
      n = split(missing[section], keys, "|")
      for (i = 1; i <= n; i++) if (keys[i] != "") print emitted[keys[i]]
      for (; blanks > 0; blanks--) print ""
    }
    { sub(/\r$/, "") }
    FNR == NR {
      if ($0 ~ /^## /) section = $0
      else if ($0 ~ /^Generated: /) generated = $0
      else if ($0 ~ /^- [^:]+:/) {
        key = line_key($0); emitted[key] = $0
        if (!(key in is_present)) missing[section] = missing[section] key "|"
      }
      next
    }
    FNR == 1 { section = "" }
    /^## / { flush(); section = $0; print; next }
    /^$/ { blanks++; next }
    {
      for (; blanks > 0; blanks--) print ""
      if ($0 ~ /^Generated: /) { print generated; next }
      if ($0 ~ /^- [^:]+:/ && line_key($0) in is_owned) {
        if (line_key($0) in emitted) print emitted[line_key($0)]
        next
      }
      print
    }
    END { flush() }
  ' - "$output_path"
}

mkdir -p "$output_dir"
temporary_path="$(mktemp "$output_dir/.local-environment.XXXXXX")"
trap 'rm -f "$temporary_path"' EXIT
if [ "$action" = "MERGE" ]; then
  printf '%s\n' "${lines[@]}" | merge_profile > "$temporary_path"
else
  printf '%s\n' "${lines[@]}" > "$temporary_path"
fi
mv -f "$temporary_path" "$output_path"
trap - EXIT

printf '%sD %s\n' "$action" "$output_path"
