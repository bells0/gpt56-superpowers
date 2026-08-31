---
name: agentic-git-delivery
description: Deliver verified changes through agent-owned feature branches, atomic commits, PR evidence, independent approval, required checks, controlled merge, and safe cleanup.
---

# Agentic Git & Delivery

The agent owns delivery mechanics; the user reviews the PR and decides merge.

## Agent-owned delivery

1. Inspect the default branch, status, upstreams, remotes, rules, and verified baseline. Preserve unrelated changes.
2. Before implementation, automatically create or select an isolated task branch. Never ask the user to do it. Protect and migrate uncommitted default-branch work; ask only when safe separation is impossible.
3. Stage owned paths or hunks. Map each acceptable, verified, revertible outcome to one atomic commit; exclude proposed, incomplete, failed, empty, or opted-out work.
4. After verification, automatically commit, push, and open or update the PR. These are preauthorized defaults; do not seek stepwise confirmation. Explicit local-only instructions stop before push.
5. Record scope, implementation, evidence, risks, dependencies, and unresolved items; keep required checks current.

## Approval and merge gate

- The implementer cannot approve. PR creation, self-review, and green checks are not approval.
- Require independent authorized-reviewer or user approval. Merge only after approval and required checks pass; never bypass protections.
- Update the same branch for review fixes and refresh evidence.

Immediate explicit authorization remains required for merge, force push, history rewrite, deleting an unmerged branch, visibility changes, or comparable high-impact actions. Direct default-branch work requires prior user authorization and a recorded reason.

After confirmed merge, automatically clean remote and local branches only when the worktree is clean and no unmerged commits or open dependencies remain. Otherwise report the blocker.

Report branch, commits, push and PR state, checks, approval, merge result, preserved changes, and remaining blockers.
