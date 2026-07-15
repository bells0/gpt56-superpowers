# Migration from `obra/superpowers`

This project is an original GPT-5.6 rewrite, not a compatibility layer. It deliberately avoids fourteen aliases because discoverable aliases would restore much of the trigger and metadata overhead.

## Capability mapping

| Previous Skill | Version 0.2 decision |
|---|---|
| `using-superpowers` | Narrow implicit descriptions plus direct invocation; no every-message router |
| `brainstorming`, `writing-plans` | `gpt56-design-planning` only for consequential ambiguity or dependency planning |
| `executing-plans` | Base model execution; cross-phase synthesis in `gpt56-superpowers` |
| `systematic-debugging` | `gpt56-debugging` for non-obvious causal investigation |
| `verification-before-completion` | `gpt56-verification` matches evidence to material claims |
| `dispatching-parallel-agents`, `subagent-driven-development` | `gpt56-delegation-review` only for genuinely independent work |
| `requesting-code-review`, `receiving-code-review` | Focused evidence-backed review in `gpt56-delegation-review` |
| `using-git-worktrees`, `finishing-a-development-branch` | `gpt56-git-delivery` when Git state is part of the requested outcome |
| `test-driven-development` | Removed as a Skill and methodology requirement; project or user rules still govern when specified |
| `writing-skills` | Base model plus repository-specific creators and validators |

## Removed defaults

- Skill lookup before every response.
- Design approval and micro-plans before every edit.
- Fail-first development, named phase rituals, and deletion of pre-test implementation.
- Implementer-plus-reviewer chains for routine work.
- Automatic worktrees, commits, pushes, and branch menus.
- Repeated broad checks at multiple workflow stages.

## Preserved invariants

- Ground decisions in the project and preserve unrelated user changes.
- Respect explicit scope, values, and authorization.
- Obtain specific authority for unapproved external or destructive actions.
- Diagnose non-obvious failures from evidence and revisit the original symptom.
- Match material completion claims to proportionate evidence and disclose gaps.
- Evaluate review findings technically rather than applying them blindly.

## Transactional local migration

`scripts/install-local.sh` validates source and path safety, acquires a shared lock, and classifies each of the six target paths as:

- `preserved`: already an exact symlink to this checkout;
- `created`: linked by the current transaction;
- `moved`: conflicting target backed up before linking.

It also moves any of the fourteen legacy directories into an exclusive transaction directory under:

```text
~/.codex/skill-backups/gpt56-superpowers/
```

The version-2 manifest records all managed, preserved, created, and moved names before the transaction becomes READY. Restore removes only links created by that transaction, never a preserved link, and returns backed-up entries after collision checks.

Backups created by version 0.1 use the previous single-link manifest. The restore script retains compatibility so the original fourteen-Skill backup remains recoverable.
