#!/bin/bash

# Exit immediately if a command fails
# set -e

# Make sure we're inside a Git repo
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Not inside a git repository."
    exit 1
fi

do-one-branch() {
    set -e
    branch=$1

    # Checkout the branch
    git switch "$branch"

    # Rebase onto origin/main
    if ! git rebase "$BASE_BRANCH"; then
        echo "⚠️  Rebase failed on $branch. Resolve conflicts and run:"
        echo "    git rebase --continue"
        return 1
    fi

    return 0
}

current_branch=$(git rev-parse --abbrev-ref HEAD)

current_dir=$(pwd)

# Update remote references and remove deleted branches
echo "Fetching and pruning..."
git fetch --all --prune

# Branch to rebase onto
BASE_BRANCH="origin/main"

# Get all local branches except main
# branches=$(git branch --format='%(refname:short)' | grep -v '^main$')
# branches+=" main tttt"
mapfile -t branches < <(git branch --format='%(refname:short)' | grep -v '^main$')
branches+=("main")

declare -A branch_paths
while read -r path _ branch; do
    # echo "* $path $branch"
    branch_name=$(echo "$branch" | sed 's/[][]//g' | xargs)
    # echo "branch_name $branch_name"
    branch_paths["$branch_name"]="$path"
    # echo "$branch_name - ${branch_paths[\"$branch_name\"]}"
done < <(git worktree list)

# echo "Paths: ${branch_paths[@]}"
# exit 0

# Iterate over branches
for branch in "${branches[@]}"; do
    echo "Branch $branch"
    # echo "${branch_paths[$branch]}"
    path=${branch_paths["$branch"]}
    if [ -n "$path" ]; then
        # echo "aaaaa"
        pushd "$path" > /dev/null
    fi
    ret=$(do-one-branch $branch 2>&1)
    if [ $? -ne 0 ]; then
        echo "$ret"
        echo "Failed to merge"
        read -p "Fix the rebase (or abort) then press ENTER" _
    else
        echo -ne "\033[1A\033[2K"
    fi
    if [ -n "$path" ]; then
        popd > /dev/null
    fi
done

git checkout "$current_branch"

echo "✅ All branches processed."
