# Git and delivery

Use Git mechanics in proportion to isolation and delivery needs.

## Isolation

A new repository or a clean dedicated branch is already isolated. Use a worktree when parallel changes, a dirty overlapping workspace, a long-running risky change, or an explicit request makes isolation valuable.

Before creating a project-local worktree, verify its directory is ignored. Prefer a global worktree location when project rules are absent; do not edit and commit ignore rules merely to create a worktree without need.

Preserve unrelated user changes. Stage explicit paths, inspect the staged diff, and avoid destructive reset or checkout operations unless the user clearly requested permanent discard.

## Commits

Commit when the user requests it, delivery requires it, or a coherent checkpoint has durable value. Do not force a commit for every tiny plan item. A commit should describe the outcome and contain only intended files.

Run validation appropriate to the claim before committing; do not require a full suite solely because a commit exists.

## External delivery

Push, create a repository, open or merge a PR, publish, or change remote state only when authorized. Explicit authorization in the current request is sufficient.

Before push or PR:

- inspect branch, status, and staged content;
- confirm no secrets or unrelated changes are included;
- ensure the reported validation matches what actually ran.

Default to preserving a PR worktree until merge or explicit cleanup. Remove branches, worktrees, or remote state only when requested or clearly part of an authorized completed workflow. Force push and permanent discard always require specific confirmation.

Finish with the commit identifier, branch, remote or PR link, validation evidence, and any remaining caveat.
