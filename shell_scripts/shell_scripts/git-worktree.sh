#!/bin/bash

# Manages git worktrees with automatic branch resolution.
# Worktree directories are placed as siblings of the main worktree,
# with slashes in branch names preserved as nested directories.
#
# Usage:
#   git-worktree.sh add <branch>[:local-branch]
#   git-worktree.sh remove <branch>

set -e

# Resolves where a worktree directory should live on disk.
# Places it alongside the main worktree, e.g. /home/user/repos/my-feature
resolve_worktree_dir() {
  local branch="$1"
  local main_wt

  main_wt=$(git worktree list | head -1 | awk '{print $1}')

  # Preserve slashes so branches like "feature/foo" become nested directories
  echo "$(dirname "$main_wt")/${branch}"
}

# Adds a worktree for a branch, resolving it in this order:
#   1. Existing local branch
#   2. Fetch from any remote (tries each in turn)
#   3. Already-tracked remote branch
#   4. New branch off origin's default branch (e.g. main)
#
# Supports "remote:local" syntax to check out a remote branch under a different local name.
cmd_add() {
  local arg="$1"

  if [ -z "$arg" ]; then
    echo "Usage: git wt <branch>[:local-branch]" >&2
    return 1
  fi

  local remote_branch="$arg"
  local local_branch="$arg"

  # Split on ":" — left side is the remote branch, right side is the local name
  if echo "$arg" | grep -q ":"; then
    remote_branch="${arg%%:*}"
    local_branch="${arg#*:}"
  fi

  local worktree_dir
  worktree_dir=$(resolve_worktree_dir "$local_branch")

  # 1. Use existing local branch if available
  if git show-ref --verify --quiet "refs/heads/$local_branch"; then
    echo "Using existing local branch: $local_branch"
    git worktree add "$worktree_dir" "$local_branch"
    return
  fi

  # 2/3. Try each remote: fetch the branch, or fall back to an already-tracked ref
  for remote in $(git remote); do
    echo "Fetching $remote_branch from remote: $remote"
    if git fetch "$remote" "refs/heads/$remote_branch:refs/remotes/$remote/$remote_branch" 2>/dev/null; then
      echo "Using remote branch: $remote/$remote_branch"
      git worktree add -b "$local_branch" "$worktree_dir" "$remote/$remote_branch"
      return
    fi
    echo "Checking for refs/remotes/$remote/$remote_branch"
    if git show-ref --verify --quiet "refs/remotes/$remote/$remote_branch"; then
      echo "Using remote branch: $remote/$remote_branch"
      git worktree add -b "$local_branch" "$worktree_dir" "$remote/$remote_branch"
      return
    fi
  done

  # 4. Branch not found anywhere — create a new one off origin's default branch
  local default_branch
  default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')

  echo "No local or remote branch found. Creating $local_branch from origin/$default_branch"
  git fetch origin "$default_branch"
  git worktree add -b "$local_branch" "$worktree_dir" "origin/$default_branch"
}

# Removes a worktree and deletes its local branch.
cmd_remove() {
  local branch="$1"

  if [ -z "$branch" ]; then
    echo "Usage: git wtr <branch>" >&2
    return 1
  fi

  local worktree_dir
  worktree_dir=$(resolve_worktree_dir "$branch")

  if [ ! -d "$worktree_dir" ]; then
    echo "Worktree directory not found: $worktree_dir" >&2
    return 1
  fi

  # Refuse to remove if the branch has unpushed commits
  local upstream
  upstream=$(git rev-parse --abbrev-ref "$branch@{upstream}" 2>/dev/null) || true

  if [ -n "$upstream" ]; then
    local ahead
    ahead=$(git rev-list --count "$upstream..$branch")
    if [ "$ahead" -gt 0 ]; then
      echo "Branch $branch is $ahead commit(s) ahead of $upstream. Push it before removing." >&2
      return 1
    fi
  else
    # No tracking branch — check if any remote has this branch at the same commit
    local tip
    tip=$(git rev-parse "$branch")
    local found=false
    for remote in $(git remote); do
      local remote_tip
      remote_tip=$(git rev-parse "refs/remotes/$remote/$branch" 2>/dev/null) || true
      if [ -n "$remote_tip" ] && [ "$tip" = "$remote_tip" ]; then
        found=true
        break
      fi
    done
    if [ "$found" != true ]; then
      echo "Branch $branch has no remote at the same commit. Push it before removing." >&2
      return 1
    fi
  fi

  local main_wt_parent
  main_wt_parent=$(dirname "$(git worktree list | head -1 | awk '{print $1}')")

  git worktree remove "$worktree_dir"
  # Clean up the local branch; -d (not -D) as a safety net against unmerged work
  git branch -d "$branch" 2>/dev/null || true

  # Remove empty parent directories left behind by nested branch paths (e.g. feature/)
  # Stops at the directory that contains all worktrees
  local dir
  dir=$(dirname "$worktree_dir")
  while [ "$dir" != "$main_wt_parent" ] && [ -d "$dir" ] && [ -z "$(ls -A "$dir")" ]; do
    rmdir "$dir"
    dir=$(dirname "$dir")
  done
}

case "$1" in
  add)    cmd_add "$2" ;;
  remove) cmd_remove "$2" ;;
  *)
    echo "Usage: git-worktree.sh {add|remove} <branch>" >&2
    exit 1
    ;;
esac
