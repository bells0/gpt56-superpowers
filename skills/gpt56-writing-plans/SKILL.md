---
name: gpt56-writing-plans
description: Establish a reusable Spec → Plan → Implementation workflow and turn an approved spec or settled requirements into implementation-ready plans for multi-step repository changes. Use before coding when work spans dependent deliverables, files or interfaces, migrations, or bounded-agent handoff. Exclude single clear edits, unresolved consequential design, and speculative planning without repository evidence.
---

# GPT-5.6 Writing Plans

Create a durable authority chain executable without rediscovering requirements. Plan outcomes and interfaces, not internal reasoning.

## Apply the lifecycle

Use only as much process as the change needs:

```text
Approved Spec → Implementation Plan(s) → Implementation → Integration evidence
```

1. **Scope:** Skip the full workflow for one clear, local, reversible edit.
2. **Spec:** When product, UX, architecture, ownership, compatibility, migration, or failure semantics remain materially open, use `gpt56-design-planning` first. Save substantial accepted direction at the project’s Spec location or `docs/specs/YYYY-MM-DD-<feature>.md`.
3. **Authority:** The approved Spec owns goals, non-goals, behavior, domain boundaries, state/data rules, failure/compatibility behavior, and acceptance semantics. Plans link its sections instead of duplicating them.
4. **Plan:** Start only after Spec approval or otherwise settled requirements. Split independently shippable/testable subsystems, then state dependency order and shared-file ownership.
5. **Execution:** Sol owns contracts, shared interfaces, integration, and final evidence. Delegate only bounded routine tasks with stable inputs and disjoint ownership. Run dependent Plans sequentially; parallelize after interfaces stabilize.
6. **Feedback:** Correct repository facts or task defects in the Plan. For semantic changes, stop affected work, re-approve the Spec, then revise dependent Plans.

## Ground and classify

Inspect repository instructions, relevant code, tests, docs, and patterns. Identify the approved source and a coherent testable scope. Follow the project’s Plan location; otherwise use `docs/plans/YYYY-MM-DD-<subsystem>-implementation.md` for durable handoff or an inline Plan when persistence adds no value.

Classify every exact detail:

- **Provided:** value from the user or approved Spec.
- **Observed:** repository-verified name, path, command, schema, or behavior.
- **Proposed:** adopted implementation choice with reason or tradeoff; never current behavior.
- **Unresolved:** required inspection or decision; never convert it into fact.

When access is incomplete, use `Confirm from repository:` instead of inventing identifiers, commands, content, or behavior.

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
- Placement: [cross-task closure outside numbered tasks; controller after integration]
- Repositories: [child repository commits precede parent gitlink/pointer updates]
- Record: [verification, commit hashes, preserved unrelated dirty state; local commits only]
- No-commit states: [incomplete, failed, blocked, unsafe, acceptance gate pending, or explicit opt-out]
```

When no durable Spec was warranted, name the exact approved source. Map files/modules to single responsibilities.

Each task must be the smallest independently acceptable outcome with useful validation and stable interfaces. Fold setup, config, docs, and migration into the outcome needing them. The final numbered task must be an acceptance-ready product result. Never make a commit or Delivery Contract a numbered task.

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

Prefer responsibilities over brittle line ranges. Include snippets only when an approved contract or algorithm remains ambiguous. Use test-first steps for reproducible behavior when useful; do not force them onto docs, generated artifacts, config, or exploration.

## Define the delivery contract

For every repository-changing Plan, define completion and commit ownership. A required acceptance gate delays completion; an explicit opt-out also prevents commit. The controller normally owns coherent completion after integration; workers commit only when assigned.

Derive repository order from dependency topology. Child repository commits precede parent gitlink or pointer updates. Report verification, commit hashes, and preserved unrelated dirty state. Default to local commits only; never push without explicit authorization.

## Remove Plan failures

Remove placeholders, duplicated Spec rules, missing decisions, vague evidence, undefined interfaces, contradictions, speculation, unrelated work, and mandatory subagents, worktrees, reviews, or delivery rituals without task-specific reason.

## Review and route execution

Before finishing:

1. Map every Spec requirement and constraint to a task or acceptance check.
2. Verify dependencies, ownership, interfaces, schemas, and exact values.
3. Ensure implementers need no consequential design choice.
4. Trace facts to Provided, Observed, or Proposed evidence.
5. Confirm the Delivery Contract remains outside numbered tasks and covers trigger, ownership, topology, evidence, remote boundary, and no-commit states.
6. Record sequential Plan order and safe parallel boundaries.

Recommend Sol for coupled work, bounded subagents only when ownership or parallelism materially helps, and worktrees only when requested or justified. Report Spec and Plan locations, execution shape, and genuine blockers.
