---
name: agentic-git-delivery
description: Handle atomic scoped commits and authorized Git delivery. Use for explicit Git operations and automatically after verified repository outcomes that should receive local commits.
---

# Agentic Git & Delivery

Deliver repository changes without losing user work or exceeding authority.

## Default atomic commits

Completed repository work authorizes commits at verified boundaries without another prompt. Follow an approved Plan's commit map; otherwise map each independently acceptable outcome to one commit. A boundary has one purpose, relevant evidence, and can be reverted without breaking dependent history. Never batch independent outcomes or split edits and partial states.

Keep proposed Plans uncommitted; after approval, commit the baseline before implementation. Commit verified boundaries before dependent work. Never commit read-only, incomplete, failed, blocked, empty, opted-out, or unsafe boundaries. Commit never authorizes push.

## Prepare

1. Inspect status, branch, upstreams, remotes, and rules.
2. Separate task changes from unrelated user work; preserve the latter.
3. Keep the suitable branch. Isolate only for parallel writes, overlap, long-lived risk, or an explicit request.
4. Before a repository-local worktree, confirm its path is ignored.

## Deliver

- Stage only task-owned paths or hunks; never broadly stage unrelated work.
- Inspect the staged diff for the current boundary, follow message conventions, and create its atomic commit.
- Record each hash and exclude later boundaries from the current commit.
- Never bypass failed hooks or commit inseparable unrelated work.
- Push, create pull requests, merge, tag, or change remote state only when authorized.
- Confirm force, history rewrite, discard, or destructive cleanup unless authorized.
- Prefer non-interactive commands.

If remote state moved, inspect divergence first. “Sync” never implies destructive authority.

## Completion

Verify status and branch or remote relationships. Report commits, checks, preserved changes, and authorized remote results. Clean temporary isolation only when safe and in scope.
