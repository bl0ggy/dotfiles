#!/bin/bash
set -euo pipefail

QUIET=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    -q|--quiet) QUIET=true; shift ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

WORKSPACE_FILE="$HOME/git/work.code-workspace"
GIT_DIR="$HOME/git"

DEFAULT_WORKSPACE='{ "folders": [], "settings": {} }'

if [[ ! -s "$WORKSPACE_FILE" ]]; then
  echo "$DEFAULT_WORKSPACE" > "$WORKSPACE_FILE"
fi

# Strip trailing commas (JSONC -> JSON) for jq parsing
clean_json() {
  perl -0777 -pe 's/,(\s*[}\]])/$1/g' "$WORKSPACE_FILE"
}

if ! clean_json | jq empty 2>/dev/null; then
  echo "Warning: $WORKSPACE_FILE contains invalid JSON, resetting" >&2
  echo "$DEFAULT_WORKSPACE" > "$WORKSPACE_FILE"
fi

# Get current folder names (preserving order)
mapfile -t existing_folders < <(clean_json | jq -r '.folders[].name')

# Recursively find git repos, stopping descent once .git is found
find_git_repos() {
  local dir="${1%/}"
  for entry in "$dir"/*/; do
    [[ ! -d "$entry" ]] && continue
    entry="${entry%/}"
    [[ "$(basename "$entry")" == .* ]] && continue
    if git -C "$entry" rev-parse --git-dir &>/dev/null; then
      printf '%s\n' "${entry#"$GIT_DIR/"}"
    else
      find_git_repos "$entry"
    fi
  done
}
mapfile -t all_dirs < <(find_git_repos "$GIT_DIR" | sort)

# Build ordered list: existing entries first (if still present), then new ones
ordered_folders=()
for name in "${existing_folders[@]}"; do
  if [[ -d "$GIT_DIR/$name" ]]; then
    ordered_folders+=("$name")
  fi
done

for name in "${all_dirs[@]}"; do
  if [[ ! " ${ordered_folders[*]} " =~ " ${name} " ]]; then
    ordered_folders+=("$name")
  fi
done

# Extract settings (everything except folders)
settings=$(clean_json | jq 'del(.folders) // {}' 2>/dev/null)
[[ -z "$settings" ]] && settings='{}'

# Build new folders array as JSON
folders_json=$(printf '%s\n' "${ordered_folders[@]}" | jq -R '{name: ., path: .}' | jq -s '.')
# Assemble final workspace file and add trailing commas for JSONC style
jq -n \
  --argjson rest "$settings" \
  --argjson folders "$(
    printf '%s\n' "${ordered_folders[@]}" |
    jq -Rn '
      [inputs | {
        name: .,
        path: .
      }]
    '
  )" \
  '{folders: $folders} + $rest' |
  perl -0777 -pe '
    # Add trailing comma after value before closing } or ]
    s/("(?:[^"\\]|\\.)*")\s*\n(\s*[}\]])/$1,\n$2/g;
    s/(\})\s*\n(\s*\])/$1,\n$2/g;
    s/(\})\s*\n(\s*\{)/$1,\n$2/g;
    s/(\])\s*\n(\s*\})/$1,\n$2/g;
  ' > "$WORKSPACE_FILE"

if [[ "$QUIET" == false ]]; then
  echo "Updated $WORKSPACE_FILE with ${#ordered_folders[@]} folders"
fi
