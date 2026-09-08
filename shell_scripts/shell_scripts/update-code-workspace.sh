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

if [[ ! -f "$WORKSPACE_FILE" ]]; then
  echo "Workspace file not found: $WORKSPACE_FILE" >&2
  exit 1
fi

# Strip trailing commas (JSONC -> JSON) for jq parsing
clean_json() {
  perl -0777 -pe 's/,(\s*[}\]])/$1/g' "$WORKSPACE_FILE"
}

# Get current folder names (preserving order)
mapfile -t existing_folders < <(clean_json | jq -r '.folders[].name')

# Get all directories in ~/git/
mapfile -t all_dirs < <(find "$GIT_DIR" -mindepth 1 -maxdepth 1 -type d ! -name '.*' -printf '%f\n' | sort)

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
settings=$(clean_json | jq 'del(.folders)')

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
