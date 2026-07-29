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

1. **Scope gate:** Skip the full workflow for one clear, local, reversible edit.
2. **Spec gate:** When product, UX, architecture, ownership, permissions, compatibility, migration, or failure semantics remain materially open, use `gpt56-design-planning` first. For substantial durable work, save the accepted direction at the project’s spec location or `docs/specs/YYYY-MM-DD-<feature>.md`.
3. **Authority gate:** The approved Spec uniquely owns goals, non-goals, behavior, domain boundaries, state/data rules, failure/compatibility behavior, and acceptance semantics. Plans link its sections rather than create a second contract.
4. **Plan gate:** Plan only after Spec approval or otherwise settled requirements. Split independently shippable/testable subsystems, then state dependency order and shared-file ownership.
5. **Execution gate:** Prefer high reasoning for Spec and Plan. Sol owns contracts, shared interfaces, integration, and final evidence. General models or Terra receive only bounded routine tasks with stable inputs and disjoint ownership. Dependent Plans run sequentially; parallelize tasks only after interfaces stabilize.
6. **Feedback gate:** Correct repository facts or task defects in the Plan. For product or architecture semantic changes, stop affected work, re-approve the Spec, then revise dependent Plans. Implementers never settle these silently.

## Ground and classify

1. Inspect repository instructions, relevant code, tests, docs, and patterns.
2. Identify the approved source and a coherent, testable scope.
3. Follow the project’s Plan location; otherwise use `docs/plans/YYYY-MM-DD-<subsystem>-implementation.md` for durable handoff or an inline Plan when persistence adds no value.

Classify every exact detail:

- **Provided:** value from the user or approved Spec.
- **Observed:** name, path, command, schema, or behavior verified in the repository.
- **Proposed:** adopted implementation choice with reason or tradeoff; never current behavior.
- **Unresolved:** required inspection or decision; never convert it into fact.

When access is incomplete, plan at the verified boundary. Use `Confirm from repository:` instead of inventing environment variables, symbols, response fields, commands, or behavior.

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
```

When no durable Spec was warranted, name the exact approved source. Before tasks, map files/modules and give each one a single responsibility.

Make each task the smallest independently acceptable outcome with useful validation and stable interfaces. Fold setup, configuration, docs, and migrations into their dependent outcome; never create tasks only for boilerplate, commands, or commits.

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
- [project pattern, constraints, failure behavior, migration boundary]

**Evidence**
- Run: `[command when known]`
- Observe: [specific behavior or artifact]
```

Use exact details only when Provided, Observed, or explicitly Proposed. Prefer responsibilities over brittle line ranges. Include snippets only when an approved contract or algorithm would otherwise remain ambiguous.

Use test-first steps for new behavior or reproduced bugs when supported; do not force them onto docs, generated artifacts, configuration, or exploration.

## Remove Plan failures

Do not leave:

- `TODO`, `TBD`, missing decisions, or contradictory names;
- duplicated Spec rules instead of links to their authoritative sections;
- vague validation without rules, failure behavior, and observable evidence;
- speculative files, identifiers, commands, or results presented as facts;
- unrelated refactors, optional scope, or mandatory subagents, worktrees, reviews, or commits without task-specific reason.

## Review and route execution

Before finishing:

1. Map every Spec requirement and global constraint to a task or acceptance check.
2. Verify dependencies, ownership, interfaces, schemas, and exact values across all Plans.
3. Ensure implementers need no consequential design choice.
4. Trace exact details to Provided, Observed, or Proposed evidence; downgrade anything else.
5. Remove duplication/over-decomposition and match evidence to each claim.
6. Record the sequential Plan order and safe within-Plan parallel boundaries.

Recommend the smallest execution shape:

- Sol executes coupled, cross-cutting, or high-risk work directly.
- Use `gpt56-subagent-driven-development` only for independently ownable outcomes where isolation or parallelism materially helps.
- Use `gpt56-using-git-worktrees` only when requested or justified by concurrent, risky, or long-lived work.

Report the approved Spec location, Plan location(s) and order, execution shape, and any unresolved item that genuinely blocks implementation.
