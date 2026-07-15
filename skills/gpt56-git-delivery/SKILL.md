---
name: gpt56-git-delivery
description: Handle authorized Git delivery involving isolation, worktrees, branches, staging, commits, pushes, pull requests, merges, or cleanup. Use when Git state or remote delivery is part of the requested outcome, not merely because the project uses Git.
---

# GPT-5.6 Git & Delivery

Deliver repository changes without losing user work or exceeding the requested authority.

## Prepare

1. Inspect status, current branch, upstreams, remotes, and repository rules.
2. Distinguish task changes from unrelated user changes; preserve the latter.
3. Use the existing clean dedicated branch when sufficient. Add isolation only for parallel work, overlapping dirty state, a long-lived risky change, or an explicit request.
4. Before a repository-local worktree, confirm its path is ignored.

## Deliver

- Stage explicit paths and inspect the staged diff before committing.
- Create a commit when requested, required for delivery, or useful as a coherent checkpoint.
- Push, open or update a pull request, merge, tag, or delete remote state only within current authorization.
- Obtain specific confirmation for force operations, history rewriting, permanent discard, or destructive cleanup unless already explicitly authorized.
- Prefer non-interactive commands and avoid altering unrelated working-tree state.

If remote state has moved, inspect divergence before choosing rebase, merge, or another reconciliation. Do not infer permission for a destructive reconciliation from a generic request to “sync.”

## Completion

Verify the resulting status and relevant branch or remote relationship. Report the branch, commit, push or pull-request result, checks run, preserved unrelated changes, and any remaining delivery step. Clean up temporary isolation only when it is safe and within scope.
