---
name: gpt56-git-delivery
description: Handle safe Git delivery involving scoped commits, branches, worktrees, pushes, pull requests, merges, or cleanup. Use for explicit Git operations and automatically after any completed repository-changing request that should receive its default local completion commit.
---

# GPT-5.6 Git & Delivery

Deliver repository changes without losing user work or exceeding the requested authority.

## Default completion commit

A completed repository-changing request authorizes one local commit per affected repository without another prompt. Map one user-visible outcome to one coherent commit. Do not commit read-only or planning work, incomplete, failed, blocked, empty, opted-out, or unsafe-to-isolate work. A commit never authorizes a push.

## Prepare

1. Inspect status, current branch, upstreams, remotes, and repository rules.
2. Distinguish task changes from unrelated user changes; preserve the latter.
3. Use the current suitable branch. Add isolation only for parallel work, overlapping state, long-lived risk, or an explicit request.
4. Before a repository-local worktree, confirm its path is ignored.

## Deliver

- Stage only task-owned paths or hunks; never broadly stage unrelated work.
- Inspect the staged diff, follow message conventions, and create the completion commit.
- Never bypass a failed hook. Stop if changes cannot be isolated truthfully.
- Push, create pull requests, merge, tag, or change remote state only when authorized.
- Confirm force operations, history rewriting, permanent discard, or destructive cleanup unless already authorized.
- Prefer non-interactive commands.

If remote state moved, inspect divergence before reconciling. Do not infer destructive authority from a generic request to “sync.”

## Completion

Verify status and branch or remote relationships. Report the commit, checks, preserved unrelated changes, and authorized remote results. Clean temporary isolation only when safe and in scope.
