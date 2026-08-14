---
name: gpt56-writing-plans
description: Establish a reusable Spec → Plan → Implementation workflow and turn an approved spec or settled requirements into implementation-ready plans for multi-step repository changes. Use before coding when work spans dependent deliverables, files or interfaces, migrations, or bounded-agent handoff. Exclude single clear edits, unresolved consequential design, and speculative planning without repository evidence.
---

# GPT-5.6 Writing Plans

Create an executable authority chain without rediscovering requirements. Plan outcomes and interfaces, not reasoning.

## Apply the lifecycle

```text
Approved Spec → Implementation Plan(s) → Implementation → Integration evidence
```

1. **Scope:** Skip this workflow for one clear, local, reversible edit.
2. **Spec:** When material product, architecture, interface, migration, or failure semantics remain open, use `gpt56-design-planning` first. Save accepted direction at the project’s Spec location or `docs/specs/YYYY-MM-DD-<feature>.md`.
3. **Authority:** The approved Spec owns goals, non-goals, behavior, domain boundaries, state/data rules, failure/compatibility behavior, and acceptance semantics. Plans link its sections instead of duplicating them.
4. **Plan:** Start only after Spec approval or otherwise settled requirements. Split independently shippable/testable subsystems, then state dependency order and shared-file ownership.
5. **Execution:** Sol owns contracts, shared interfaces, integration, and final evidence. Delegate bounded tasks with stable inputs and disjoint ownership. Each independently acceptable task is a default atomic commit boundary: verify and commit it before dependent work. Parallelize only after interfaces stabilize.
6. **Feedback:** Correct Plan facts and task defects. Semantic changes require Spec re-approval before dependent work.

## Ground and classify

Inspect repository instructions, code, tests, docs, and patterns. Identify the approved source and scope. Use the project’s Plan location, `docs/plans/YYYY-MM-DD-<subsystem>-implementation.md`, or an inline Plan when persistence adds no value.

Classify every exact detail:

- **Provided:** user or approved-Spec value.
- **Observed:** repository-verified fact.
- **Proposed:** implementation choice with rationale; never current behavior.
- **Unresolved:** required inspection or decision; never a fact.

When access is incomplete, use `Confirm from repository:` instead of inventing details.

## Build the Plan

Start with:

```markdown
# [Subsystem] Implementation Plan

**Goal:** [user-visible result]
**Non-goals:** [explicit exclusions]
**Architecture:** [short implementation direction]

## Spec Link
- [approved Spec path and relevant anchors]

## Global Constraints
- [Provided, Observed, or Proposed project-wide constraints]

## Acceptance Evidence
- [observable behavior and the check that proves it]

## Delivery Contract
- Completion trigger: [objective condition; user acceptance when required]
- Commit ownership: [controller or explicitly assigned worker]
- Plan baseline: [commit an approved durable Plan before implementation; never commit it while proposed]
- Commit map: [Task N → owned paths, evidence, message; group only inseparable tasks]
- Sequence: [verify and commit each boundary before dependent work]
- Placement: [cross-task closure outside numbered tasks; controller after integration of each accepted boundary]
- Repositories: [child repository commits precede parent gitlink/pointer updates]
- Record: [verification, commit hashes, preserved unrelated dirty state; local commits only]
- No-commit states: [current boundary incomplete, failed, blocked, unsafe, acceptance gate pending, or explicit opt-out]
```

Without a durable Spec, name the approved source. Map modules to single responsibilities.

Each task is the smallest independently acceptable outcome with useful validation and stable interfaces. It is the default atomic commit boundary: one purpose, relevant evidence, and revertible without breaking dependent history. Do not commit every edit, test phase, or partial state. Fold setup, config, docs, and migration into their owning outcome. The final numbered task must be an acceptance-ready product result. Keep commits and the Delivery Contract outside numbered tasks.

```markdown
### Task N: [verifiable outcome]

**Outcome**
[behavior or artifact]

**Files**
- Create/Modify/Test: `exact/path` — [responsibility]

**Interfaces**
- Consumes: [existing or earlier contract]
- Produces: [function, type, schema, route, event, or artifact]

**Implementation notes**
- [pattern, constraints, failure behavior, migration boundary]

**Evidence**
- Run: `[command when known]`
- Observe: [specific behavior or artifact]
```

Avoid brittle line ranges and mandatory test rituals. Include snippets only for ambiguous approved contracts or algorithms.

## Define the delivery contract

For every repository-changing Plan, define completion, atomic boundaries, and ownership. An acceptance gate delays its boundary; an explicit opt-out prevents commit. Keep a durable Plan uncommitted while proposed; after approval, commit its baseline before implementation. The controller normally owns each task commit after integration; workers commit only when assigned.

Derive task and repository order from dependencies. Verify and commit each boundary before dependent work. Child repository commits precede parent gitlink or pointer updates. Report verification, all hashes, and preserved dirty state. Default to local commits; never push without authorization.

## Remove Plan failures

Remove placeholders, duplicated Spec rules, missing decisions, vague evidence, undefined interfaces, contradictions, speculation, unrelated work, and unjustified workflow rituals.

## Review and route execution

Before finishing:

1. Map every Spec requirement and constraint to a task or acceptance check.
2. Verify dependencies, ownership, interfaces, schemas, and exact values.
3. Ensure implementers need no consequential design choice.
4. Trace facts to Provided, Observed, or Proposed evidence.
5. Confirm the Delivery Contract remains outside numbered tasks and covers trigger, Plan baseline, commit map, ownership, topology, evidence, remote boundary, and per-boundary no-commit states.
6. Record sequential Plan order and safe parallel boundaries.

Keep coupled work with Sol. Use subagents for bounded ownership or useful parallelism and worktrees only when justified. Report Plan locations, execution shape, and blockers.
