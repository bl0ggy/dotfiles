#!/bin/zsh

# Dirs to ignore from search
listIgnoredPaths=(".cache" ".git" ".github" ".godot" ".metadata" ".next" "build" "dist" "node_modules" "src")
# `find` command to ignore those dirs
ignoredPaths=()
first=true
for i in ${listIgnoredPaths[@]}; do
    if [ "$first" = true ]; then
        first=false
    else
        ignoredPaths+=("-o")
    fi
    ignoredPaths+=("-name" "$i" "-print")
done

# Run find on workspace
ws="$HOME/Workspace/"
allPaths=$(
    find $ws -type d \( ${ignoredPaths[@]} \) -prune -o -type d -print
)

# Find all paths ending with .git
filterParent=(".git" ".metadata")
ignoreParent=("$ws/Obsidian/My vault") # allow those directly do be
rootPaths=()
while IFS= read -r line; do
    for filtered in ${filterParent[@]}; do
        if [[ "$line" == */$filtered ]]; then
            isIgnored=0
            for ignored in ${ignoreParent[@]}; do
                if [[ "$line" == "$ignored"/* ]]; then
                    # Remove the matching subdir from the line
                    isIgnored=1
                fi
            done
            if [ "$isIgnored" = "0" ]; then
                # Remove the matching subdir from the line
                rootPath="${line%/$filtered}"
                rootPaths+=("$rootPath")
            fi
        fi
    done
done <<<"$allPaths"

# Remove all paths found starting with oen of rootPath's paths
newPaths=""
while IFS= read -r line; do
    # Check if this line starts with any rootPath
    for rootPath in "${rootPaths[@]}"; do
        if [[ "$line" == "$rootPath"/* || "$line" == "$rootPath" ]]; then
            line="$rootPath"
        fi
    done

    if [[ -z "$newPaths" ]]; then
        newPaths="$line"
    else
        newPaths+=$'\n'"$line"
    fi
done <<<"$allPaths"
# Update allPaths with the new content sorted and cleared from duplicates
allPaths=$(echo "$newPaths" | sort -u)

fzfArg="$1"
if [ -n "$fzfArg" ]; then
    fzfArg="-q $fzfArg"
fi

# Run fzf and open tmux in the selected path
selected=$(echo $allPaths | fzf $fzfArg)
if [ $? = 0 ]; then
    if [ -n "${TMUX}" ]; then
        echo "Detach current session then re-run tmux command"
        return
    fi

    # `-t="$selected"` instead of `-t "$selected"` is important for exact match (the later matches prefixes also)
    tmux has-session -t="$selected" 2>/dev/null

    if [ $? = 0 ]; then
        tmux a -t $selected
        return
    fi

    tmux new -d -s $selected -c $selected
    tmux rename-window "nvim"
    tmux send-keys -t $selected "nvim ." Enter
    tmux neww -t $selected -c $selected
    tmux rename-window "run"
    tmux a -t $selected:0
fi
