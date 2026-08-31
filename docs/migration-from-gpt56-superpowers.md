# Migration from `gpt56-superpowers`

Version 0.8 renames the suite to Agentic Superpowers so future model upgrades do not require another public-identifier migration.

## Identifier mapping

| Previous Skill | Current Skill |
|---|---|
| `gpt56-superpowers` | `agentic-superpowers` |
| `gpt56-orchestrate-delivery` | `agentic-orchestrate-delivery` |
| `gpt56-design-planning` | `agentic-design-planning` |
| `gpt56-writing-plans` | `agentic-writing-plans` |
| `gpt56-using-git-worktrees` | `agentic-using-git-worktrees` |
| `gpt56-subagent-driven-development` | `agentic-subagent-driven-development` |
| `gpt56-debugging` | `agentic-debugging` |
| `gpt56-verification` | `agentic-verification` |
| `gpt56-purpose-bound-rigor` | `agentic-purpose-bound-rigor` |
| `gpt56-delegation-review` | `agentic-delegation-review` |
| `gpt56-git-delivery` | `agentic-git-delivery` |

## Full-installer behavior

`./scripts/install-local.sh` treats all previous `gpt56-*` IDs as migration inputs:

- existing old Skill directories or links are moved into the new transaction backup;
- only `agentic-*` links remain discoverable after installation;
- an old managed purpose-bound-rigor block and managed audit Agent are upgraded in place;
- the receipt preserves the exact previous state, so restoring that transaction brings the old installation back;
- version-0.7, version-0.6, version-0.3, and version-0.1 backup formats remain accepted by the restore script.

The suite deliberately does not install live aliases for old Skill names. Keeping both namespaces would duplicate discovery metadata and make implicit routing ambiguous. Update explicit `$gpt56-*` prompts and project instructions to the mapped `$agentic-*` names.

## Delivery contract in version 0.8

`agentic-git-delivery` also establishes a review-gated default for repository changes:

- development, commits, and pushes occur on a task-specific feature branch, not the default branch;
- verified outcomes receive atomic commits, then the completed branch is pushed into a PR;
- the PR records scope, implementation, verification evidence, risks, unresolved items, and dependencies;
- an independent authorized reviewer or the user must approve, and every required check must pass before merge;
- the implementer cannot approve its own work;
- an explicit local-only request stops before push;
- direct default-branch work requires prior user authorization and a recorded emergency reason.

## Repository and catalog contract

After the authorized GitHub repository rename and publication, external catalogs and installers should use:

- repository: `https://github.com/bells0/agentic-superpowers.git`
- branch: `main`
- Skill paths: the eleven `skills/agentic-*` directories listed above

Until that remote action occurs, these values describe the target release contract rather than confirmed public state.
