#!/bin/zsh

open_tmux() {
    if [ -n "${TMUX}" ]; then
        echo "Detach current session then re-run tmux command"
        return
    fi

    tmux has-session -t $1 2>/dev/null

    if [ $? = 0 ]; then
        tmux a -t $1
        return
    fi

    tmux new -d -s $1 -c $1
    tmux rename-window "nvim"
    tmux send-keys -t $1 "nvim ." Enter
    tmux neww -t $1 -c $1
    tmux rename-window "run"
    tmux a -t $1:0
}
lfzf() {
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
    rootPaths=()
    while IFS= read -r line; do
        for d in ${filterParent[@]}; do
            if [[ "$line" == */$d ]]; then
                # Remove the matching subdir from the line
                rootPath="${line%/$d}"
                rootPaths+=("$rootPath")
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
        open_tmux $selected
    fi
}
