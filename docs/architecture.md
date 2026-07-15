# Architecture

## Goal

Give GPT-5.6 a compact development contract that preserves correctness and autonomy without re-teaching capabilities the model already performs reliably.

## Non-goals

- Reproduce the original Superpowers Skill graph.
- Automatically activate on every conversation.
- Enforce one development methodology for every task.
- Replace project-specific rules, security policy, or user decisions.
- Claim lower token use automatically means better task quality.

## Design decisions

### One explicit entry point

The plugin exposes one Skill and sets allow_implicit_invocation to false. This removes the old always-trigger router and fourteen overlapping trigger descriptions. Users opt into the workflow with $gpt56-superpowers; ordinary Codex behavior remains untouched.

### Outcome contract

The core resolves goal, success criteria, constraints, evidence, permission, and stopping conditions. These describe the destination while leaving search, tool, and implementation choices to GPT-5.6.

### Risk is a route, not a ritual

Low-risk work goes directly to a deterministic check. Medium-risk behavior changes get targeted regression evidence. High-risk work adds durable decisions, isolation, independent review, and broader affected checks only where justified.

External writes and destructive actions remain a separate authorization boundary. Risk does not imply repeated approval, and local authorization does not imply permission to mutate remote state.

### Conditional depth

The core links five references. They are one level deep, never cross-linked, and each owns one decision domain. A normal task loads the core plus zero or one reference rather than a chain of complete Skills.

### Claim-based verification

Evidence is selected from the completion claim:

- changed artifact: inspect diff and schema;
- fixed bug: exercise the original symptom;
- working behavior: targeted test or smoke;
- integration: affected build, type, lint, or integration check;
- release readiness: project-required broader suite.

This eliminates repeated full-suite runs while preserving the rule that unverified states cannot be reported as passed.

### Bounded delegation

Parallel agents are used for independent work, elapsed-time savings, specialist context, or fresh high-risk review. The architecture explicitly rejects per-task implementer plus spec-review plus quality-review chains.

## Mapping to GPT-5.6 guidance

| Official guidance | Implementation |
|---|---|
| Simplify repeated instructions | One core, five conditional references, no compatibility aliases |
| State outcomes and stop rules | Six-part contract and explicit finish/fallback conditions |
| Define autonomy | Read-only versus change requests plus one permission boundary |
| Route tools by dependency | Parallel independent reads, sequential dependent work, synthesize before action |
| Use PTC only for bounded aggregation | Deterministic-reduction rule in the core |
| Use sparse progress updates | Preamble plus major-phase changes only |
| Validate what matters | Risk and claim-to-evidence matrices |
| Evaluate representative tasks | Six-scenario manifest plus documented metrics for live comparisons |

## Prompt budget

Repository validation enforces a maximum of 900 words for the core and 2,500 words for the complete Skill package. The current version is 775 core words and 2,251 total words. Limits are guardrails, not a target to fill.

## Change policy

Change one behavioral rule at a time when tuning an established deployment. Re-run the same representative traces with the same model and reasoning effort. Add an instruction only for a measured failure mode; remove it again if it does not improve the pass criteria.
