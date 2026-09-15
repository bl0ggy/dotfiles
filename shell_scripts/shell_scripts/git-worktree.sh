#!/bin/bash

set -e

resolve_worktree_dir() {
  local branch="$1"
  local main_wt parent_dir repo_name

  main_wt=$(git worktree list | head -1 | awk '{print $1}')
  parent_dir=$(dirname "$main_wt")
  repo_name=$(basename "$main_wt")

  echo "$parent_dir/$repo_name-$branch"
}

cmd_add() {
  local arg="$1"

  if [ -z "$arg" ]; then
    echo "Usage: git wt <branch>[:local-branch]" >&2
    return 1
  fi

  local remote_branch="$arg"
  local local_branch="$arg"

  if echo "$arg" | grep -q ":"; then
    remote_branch="${arg%%:*}"
    local_branch="${arg#*:}"
  fi

  local worktree_dir
  worktree_dir=$(resolve_worktree_dir "$local_branch")

  if git show-ref --verify --quiet "refs/heads/$local_branch"; then
    echo "Using existing local branch: $local_branch"
    git worktree add "$worktree_dir" "$local_branch"
    return
  fi

  if git fetch origin "refs/heads/$remote_branch:refs/remotes/origin/$remote_branch" 2>/dev/null; then
    echo "Using remote branch: origin/$remote_branch"
    git worktree add -b "$local_branch" "$worktree_dir" "origin/$remote_branch"
    return
  fi

  local default_branch
  default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')

  echo "No local or remote branch found. Creating $local_branch from origin/$default_branch"
  git fetch origin "$default_branch"
  git worktree add -b "$local_branch" "$worktree_dir" "origin/$default_branch"
}

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

  git worktree remove "$worktree_dir"
  git branch -D "$branch" 2>/dev/null || true
}

case "$1" in
  add)    cmd_add "$2" ;;
  remove) cmd_remove "$2" ;;
  *)
    echo "Usage: git-worktree.sh {add|remove} <branch>" >&2
    exit 1
    ;;
esac
