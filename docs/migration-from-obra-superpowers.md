# Migration from obra/superpowers

This project is an original GPT-5.6 rewrite, not an in-place upgrade. It intentionally removes compatibility aliases because fourteen discoverable aliases would restore much of the trigger and metadata overhead.

## Capability mapping

| Previous Skill | New location or decision |
|---|---|
| using-superpowers | Explicit $gpt56-superpowers invocation; no one-percent or every-message rule |
| brainstorming | design-and-planning.md, only for material ambiguity |
| writing-plans | design-and-planning.md, deliverable-level plans only |
| executing-plans | Core execution loop; no separate required mode |
| test-driven-development | testing-and-verification.md, behavior and risk decision |
| verification-before-completion | testing-and-verification.md, evidence matched to claim |
| systematic-debugging | debugging.md, fast path with conditional escalation |
| dispatching-parallel-agents | delegation-and-review.md, dependency-aware parallelism |
| subagent-driven-development | delegation-and-review.md, bounded delegation |
| requesting-code-review | delegation-and-review.md, risk-based review |
| receiving-code-review | delegation-and-review.md, evaluate findings as evidence |
| using-git-worktrees | git-and-delivery.md, isolation only when useful |
| finishing-a-development-branch | git-and-delivery.md, only for authorized delivery |
| writing-skills | Core low-risk route plus repository-specific validators |

## Removed defaults

- Skill lookup before every response.
- Brainstorming and design approval before every edit.
- Plans split into two-to-five-minute steps with embedded implementation code.
- Universal fail-first TDD and deletion of implementation written before a test.
- Implementer plus two reviewers for every task.
- Automatic worktree creation, dependency installation, ignore-file commit, and baseline full-suite run.
- Repeated full-suite checks in worktree, TDD, verification, review, and branch-finishing phases.
- Mandatory commits, pushes, and branch-choice menus.

## Preserved invariants

- Respect explicit scope, values, and existing user changes.
- Confirm unapproved external, destructive, costly, force-push, permanent-discard, or scope-expanding actions.
- Do not claim tests, builds, fixes, or release states without matching evidence.
- Verify the original symptom for a bug fix, or state the validation gap.
- Evaluate review feedback technically rather than applying it blindly.
- Verify a project-local worktree directory is ignored before creating it.

## Local migration behavior

scripts/install-local.sh checks the repository and path ancestry before mutation, acquires a shared lock, and moves existing legacy directories and any conflicting gpt56-superpowers target into an exclusive transaction directory under:

    ~/.codex/skill-backups/gpt56-superpowers/

It then creates one link:

    ~/.codex/skills/gpt56-superpowers
      -> <cloned-repository>/skills/gpt56-superpowers

Each complete backup has an atomic READY marker and a manifest of the exact moved names. scripts/restore-original.sh only accepts a matching READY backup, removes the managed link when appropriate, and restores it after a collision preflight. Invalid or partial directories are skipped. No legacy directory is deleted.

Start a new Codex task after install or restore so discovery refreshes.
