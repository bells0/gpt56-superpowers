---
name: agentic-git-delivery
description: Deliver verified repository changes through feature branches, atomic commits, pushed branch state, reviewable pull requests, independent approval, required checks, and controlled merge.
---

# Agentic Git & Delivery

Deliver repository changes without losing user work, bypassing review, or treating implementation as approval.

## Feature-branch contract

1. Inspect status, default branch, upstreams, remotes, and repository rules. Preserve unrelated user changes.
2. Before development, create or switch to a task-specific feature branch. Do not develop, commit, or push directly on `main` or another default branch.
3. Stage only task-owned paths or hunks. Map each independently acceptable, verified, revertible outcome to one atomic commit; never commit proposed, incomplete, failed, empty, or opted-out work.
4. After the development outcome passes its focused evidence, push the feature branch and open or update its pull request unless the user explicitly limits delivery to local state or remote authority is unavailable.
5. Record PR scope, implementation, verification evidence, risks, unresolved items, and dependencies. Keep required checks visible and current.

## Approval and merge gate

- The implementer owns the change but cannot approve it. Self-review and green checks are evidence, not approval.
- Require approval from an independent authorized reviewer or the user.
- Merge only after that approval and every required check passes. Never bypass failed hooks, checks, branch protection, or required review.
- If review requests changes, update the same feature branch, add focused evidence, and request approval again when required.

Direct default-branch work is an emergency exception only. Obtain explicit user authorization first and record the reason in the commit or PR. Force pushes, history rewrites, destructive cleanup, merge, tags, and releases require matching authority.

Report branch, commits, push and PR state, checks, approval, merge result, preserved changes, and remaining blockers.
