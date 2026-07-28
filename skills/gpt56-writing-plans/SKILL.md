---
name: gpt56-writing-plans
description: Turn settled requirements or an approved design into an implementation-ready plan for a multi-step repository change. Use before coding when work spans dependent deliverables, multiple files or interfaces, migrations, or downstream handoff. Exclude single clear edits, unresolved product or architecture choices, and speculative planning without repository evidence.
---

# GPT-5.6 Writing Plans

Create a durable implementation contract that Sol or bounded workers can execute without rediscovering requirements. Plan outcomes and interfaces, not the model's internal reasoning.

## Confirm readiness

1. Inspect repository instructions, relevant code, tests, documentation, and established patterns.
2. Separate settled requirements from unresolved choices. Use `gpt56-design-planning` first when a material product, architecture, compatibility, permission, or migration decision remains open.
3. Confirm the requested scope can produce one coherent, testable result. Split independent subsystems into separate plans when they can ship and validate separately.
4. Follow the project's plan location when one exists. Otherwise, save a durable plan to `docs/plans/YYYY-MM-DD-<feature>-implementation.md` when later execution or handoff needs a file; return a compact inline plan when persistence adds no value.

Classify every exact detail before putting it into the plan:

- **Provided:** copy the user's or approved spec's exact value verbatim.
- **Observed:** use a name, path, command, schema, or behavior verified in the repository.
- **Proposed:** state an implementation recommendation as a choice to adopt, with its reason or tradeoff; never present it as current repository behavior.
- **Unresolved:** name the inspection or decision that will resolve it; do not convert a recommendation into a repository fact.

When repository access is unavailable or incomplete, plan at the verified boundary level. Use `Confirm from repository:` for missing implementation facts instead of inventing environment variables, function names, response fields, commands, file contents, or current behavior.

## Build the plan

Start with:

```markdown
# [Feature] Implementation Plan

**Goal:** [user-visible result]
**Non-goals:** [explicit exclusions]
**Architecture:** [short implementation direction]

## Global Constraints
- [exact project-wide values, compatibility limits, naming, dependencies]

## Acceptance Evidence
- [observable behavior and the check that proves it]
```

Before defining tasks, map the files or modules that will change and give each one a clear responsibility. Follow existing structure unless a targeted split is required by this work.

Make each task the smallest outcome that:

- has a coherent implementation boundary;
- carries its own useful validation;
- exposes stable inputs and outputs to neighboring tasks;
- could be accepted or rejected independently without becoming a tiny action.

Fold setup, configuration, documentation, and migration steps into the outcome that needs them. Do not create separate tasks merely for boilerplate, running a command, or committing.

Use this task structure:

```markdown
### Task N: [verifiable outcome]

**Outcome**
[behavior or artifact produced]

**Files**
- Create: `exact/path`
- Modify: `exact/path` — [symbol or responsibility]
- Test: `exact/path`

**Interfaces**
- Consumes: [existing or earlier-task contract]
- Produces: [exact function, type, schema, route, event, or artifact]

**Implementation notes**
- [project pattern, constraint, failure behavior, migration boundary]

**Evidence**
- Run: `[command when known]`
- Observe: [specific passing behavior or artifact]
```

Use exact paths, symbols, values, and commands only when they are Provided or Observed. A Proposed design may introduce a new exact contract only when the plan explicitly labels it as proposed and explains why it is safe to settle during planning. Prefer symbols or responsibilities over brittle line-number ranges. Include code snippets only when an approved exact contract, schema, or algorithm would otherwise remain ambiguous; do not pre-write ordinary implementation code for Sol to transcribe.

Apply test-first steps when behavior is being introduced or a reproducible bug is being fixed and the repository supports them. Do not force artificial TDD steps onto documentation, generated artifacts, pure configuration, or exploratory work.

## Remove plan failures

Do not leave:

- `TODO`, `TBD`, "implement later," or missing decisions;
- vague instructions such as "add validation" without rules and failure behavior;
- undefined interfaces or contradictory names across tasks;
- speculative files, commands, or test results;
- ungrounded identifiers or implementation rules presented as settled facts;
- unrelated refactors or optional features;
- mandatory subagent, worktree, review, or commit steps without a task-specific reason.

## Self-review and route execution

Before finishing:

1. Map every requirement and global constraint to a task or acceptance check.
2. Verify task dependencies, interface names, schemas, and exact values are consistent.
3. Confirm an implementer can start each task without making a consequential design choice.
4. Trace every exact identifier, value, command, and behavior to Provided, Observed, or explicitly Proposed evidence; downgrade anything else to `Confirm from repository:`.
5. Remove duplicated instructions and over-decomposition.
6. Confirm the evidence supports the breadth of each completion claim.

Recommend the smallest execution shape:

- Sol executes directly when work is coupled or coordination adds no value.
- Use `gpt56-subagent-driven-development` only when the plan contains independently ownable outcomes and context isolation or parallelism materially helps.
- Use `gpt56-using-git-worktrees` only when isolation is requested or justified by concurrent, risky, or long-lived work.

Report the plan location or inline plan, the chosen execution shape, and any unresolved item that genuinely blocks implementation.
