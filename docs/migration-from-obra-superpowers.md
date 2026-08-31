# Migration from `obra/superpowers`

This project is an original model-evolving rewrite, not a compatibility layer. It deliberately avoids fourteen aliases because discoverable aliases would restore much of the trigger and metadata overhead.

## Capability mapping

| Previous Skill | Version 0.8 decision |
|---|---|
| `using-superpowers` | Narrow implicit descriptions plus direct invocation; no every-message router |
| `brainstorming` | `agentic-design-planning` only for consequential ambiguity or dependency planning |
| `writing-plans` | `agentic-writing-plans` for repository-grounded, implementation-ready plans after decisions settle |
| `executing-plans` | Base model execution for coupled work; `agentic-subagent-driven-development` for independently ownable plan outcomes |
| `systematic-debugging` | `agentic-debugging` for non-obvious causal investigation |
| `verification-before-completion` | `agentic-verification` matches evidence to material claims |
| `dispatching-parallel-agents` | `agentic-delegation-review` only for genuinely independent work or focused judgment |
| `subagent-driven-development` | `agentic-subagent-driven-development` with the controller-owned contracts, disjoint write ownership, durable state, and proportional review |
| `requesting-code-review`, `receiving-code-review` | Focused evidence-backed review in `agentic-delegation-review` |
| `using-git-worktrees` | `agentic-using-git-worktrees` only for explicit or materially justified isolation |
| `finishing-a-development-branch` | `agentic-git-delivery` for explicit Git state and atomic local commits after verified repository outcomes |
| `test-driven-development` | Removed as a Skill and methodology requirement; project or user rules still govern when specified |
| `writing-skills` | Base model plus repository-specific creators and validators |

## Removed defaults

- Skill lookup before every response.
- Design approval and micro-plans before every edit.
- Fail-first development, named phase rituals, and deletion of pre-test implementation.
- Implementer-plus-reviewer chains for routine work.
- Automatic worktrees, pushes, and branch menus.
- Repeated broad checks at multiple workflow stages.

## Preserved invariants

- Ground decisions in the project and preserve unrelated user changes.
- Respect explicit scope, values, and authorization.
- Obtain specific authority for unapproved external or destructive actions.
- Diagnose non-obvious failures from evidence and revisit the original symptom.
- Match material completion claims to proportionate evidence and disclose gaps.
- Commit each completed repository-changing outcome locally by default while preserving explicit opt-outs and separate push authority.
- Evaluate review findings technically rather than applying them blindly.

## Transactional local migration

`scripts/install-local.sh` validates source and path safety, acquires a shared lock, and classifies each of the eleven target paths as:

- `preserved`: already an exact symlink to this checkout;
- `created`: linked by the current transaction;
- `moved`: conflicting target backed up before linking.

It also moves any of the fourteen legacy directories into an exclusive transaction directory under:

```text
~/.codex/skill-backups/agentic-superpowers/
```

The version-2 manifest records all managed, preserved, created, and moved names before the transaction becomes READY. Restore removes only links created by that transaction, never a preserved link, and returns backed-up entries after collision checks.

Backups created by `gpt56-superpowers` versions 0.7, 0.6, and 0.3 use earlier version-2 managed-Skill manifests, while version 0.1 uses the single-link manifest. The restore script retains compatibility with all formats so previous migrations remain recoverable.
