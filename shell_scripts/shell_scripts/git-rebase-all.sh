#!/bin/bash

# Exit immediately if a command fails
# set -e

DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')

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

    # Rebase onto origin/$DEFAULT_BRANCH
    if ! git rebase "$BASE_BRANCH" --update-refs; then
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
BASE_BRANCH="origin/$DEFAULT_BRANCH"

# Get all local branches except $DEFAULT_BRANCH
mapfile -t branches < <(git branch --format='%(refname:short)' | grep -v "^${DEFAULT_BRANCH}\$")
branches+=("$DEFAULT_BRANCH")

declare -A branch_paths
while read -r path _ branch; do
    branch_name=$(echo "$branch" | sed 's/[][]//g' | xargs)
    branch_paths["$branch_name"]="$path"
done < <(git worktree list)

# Iterate over branches
for branch in "${branches[@]}"; do
    is_leaf=true
    for other in "${branches[@]}"; do
        if git merge-base --is-ancestor "$branch" "origin/$DEFAULT_BRANCH" 2>/dev/null; then
            # Always rebase branches below $DEFAULT_BRANCH
            # Usually they're already merged branches
            break
        fi
        [ "$branch" = "$other" ] && continue
        if git merge-base --is-ancestor "$branch" "$other" 2>/dev/null; then
            # Branches on the same commit makes them non-leaf even though they're leafs
            if [ "$(git rev-parse $branch)" != "$(git rev-parse $other)" ]; then
                is_leaf=false
                break
            fi
        fi
    done
    if ! $is_leaf ; then
        continue
    fi
    echo "Branch $branch"
    path=${branch_paths["$branch"]}
    if [ -n "$path" ]; then
        pushd "$path" > /dev/null
    fi
    ret=$(do-one-branch $branch 2>&1)
    if [ $? -ne 0 ]; then
        # Remove last line
        echo -ne "\033[1A\033[2K"
        echo -e "⚠️  \0033[0;31mFailed to rebase $branch\0033[0m"
        git rebase --abort
    else
        # Remove last line
        echo -ne "\033[1A\033[2K"
        echo -e "\0033[0;32m✓  Rebased $branch\0033[0m"
    fi
    if [ -n "$path" ]; then
        popd > /dev/null
    fi
done

git switch "$current_branch" >/dev/null

echo "✅ All branches processed."
