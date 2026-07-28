---
name: gpt56-using-git-worktrees
description: Prepare or verify safe Git worktree isolation for local repository work. Use when the user requests a worktree, concurrent tasks need separate branches, the current checkout contains conflicting user changes, or long-lived or risky implementation benefits from isolation. Exclude ordinary edits already safe in the current checkout and tasks already running in an isolated worktree.
---

# GPT-5.6 Worktree Isolation

Create only the isolation the task needs. Detect the current state first, prefer Codex-native worktree controls, and preserve user changes.

## Decide whether isolation helps

A direct request for a worktree authorizes creation. Otherwise, use one only when concurrent work, overlapping branch state, a dirty checkout, or a long-lived risky change makes isolation materially safer. If the benefit is marginal, work in place.

Before creating anything, inspect:

```text
git rev-parse --show-toplevel
git rev-parse --git-dir
git rev-parse --git-common-dir
git rev-parse --show-superproject-working-tree
git branch --show-current
git status --short
```

Resolve the reported Git paths before comparing them. A linked worktree has a different Git directory and common directory; a submodule can look similar, so treat a non-empty superproject path as a submodule rather than proof of worktree isolation.

If already isolated, keep the existing worktree. Do not nest another one. Record whether it is on a branch or detached HEAD.

## Create isolation safely

1. Prefer a Codex or harness-native worktree action when the current task can use it. Native controls own placement, branch state, handoff, and cleanup; do not create invisible parallel state behind them.
2. If no native path is available, use `git worktree` directly.
3. Honor explicit branch and directory choices. Otherwise use the repository's existing `.worktrees/` or `worktrees/` convention; `.worktrees/` wins when both exist.
4. Before using a project-local directory, verify it is ignored with `git check-ignore`. Do not silently edit `.gitignore` or create a commit solely to make worktree setup succeed. Use an approved external location or ask when no safe location exists.
5. Use the `codex/` branch prefix unless the user or repository specifies another convention.
6. Resolve the final absolute target and confirm it is not the repository root, home directory, or an existing unrelated path before running `git worktree add`.

Uncommitted changes in the source checkout do not automatically appear in a new worktree. If the requested task depends on them, work in the current checkout or obtain a safe, explicit transfer decision. Never stash, copy, commit, or discard unrelated user changes merely to populate the worktree.

## Prepare the worktree

Follow repository instructions for setup. Do not automatically install every detected ecosystem dependency. Reuse existing caches and run only setup commands required to make the task executable.

Establish a proportionate baseline:

- run a targeted check that covers the area about to change;
- broaden only when project rules or the task's integration boundary requires it;
- distinguish pre-existing failures from failures introduced later;
- report a blocking baseline problem instead of claiming the workspace is clean.

Do not start implementation on `main` or `master` unless the user explicitly chose that state or the task is already managed by a safe native workflow.

## Hand off and finish

Report:

- worktree absolute path;
- branch or detached state;
- source revision;
- preserved uncommitted source changes;
- setup and baseline evidence;
- any limitation affecting later cleanup.

Let `gpt56-git-delivery` own the completion commit and any safe cleanup. Worktree creation never authorizes push, merge, branch deletion, or removal of another worktree.
