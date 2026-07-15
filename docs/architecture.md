# Architecture

## Goal

Give GPT-5.6 a small set of precise development lenses without re-teaching reliable base-model behavior or forcing every task through one workflow.

## Hub and spokes

The suite contains six sibling Skills:

```text
gpt56-superpowers              cross-phase coordination
├── gpt56-design-planning      material ambiguity
├── gpt56-debugging            non-obvious failures
├── gpt56-verification         claim-matched evidence
├── gpt56-delegation-review    independent work or judgment
└── gpt56-git-delivery         repository delivery state
```

The diagram describes ownership, not a required call chain. Every spoke is a direct entry point and contains all instructions needed for its domain. None links to or requires a sibling.

## Routing rules

- Clear, local, low-ambiguity work: no suite Skill.
- One consequential decision domain: one narrow Skill.
- Two or more dependent phases whose ordering and synthesis affect success: core plus only the one or two narrow Skills that change a decision.
- External or destructive action: a permission boundary independent of task complexity.

All Skills allow implicit invocation, but their descriptions deliberately require a material match. This replaces both the old always-trigger router and version 0.1's single explicit bottleneck.

## Design decisions

### Outcome over ritual

The core resolves goal, success, constraints, evidence, permission, and stop conditions, then sequences dependent work. It does not prescribe an implementation methodology.

### Independent ownership

Each spoke owns one decision domain. Trigger overlap is minimized by separating design uncertainty, causal uncertainty, evidence selection, coordination value, and Git delivery state.

### Claim-based verification

Verification starts with the statement being made:

- artifact validity: diff, format, schema, links;
- bug fixed: original symptom;
- behavior works: narrow reliable check or smoke;
- visual correctness: rendered affected states;
- integration health: affected type, lint, build, contract, or integration check;
- release readiness: project-required and risk-justified gates.

The scope broadens only when the claim, observed failures, uncertain dependency boundary, release risk, or project rules require it.

### Bounded coordination

Delegation is justified by independent deliverables, elapsed-time savings, or fresh judgment that can change a material decision. Review is focused on named risks rather than added as a universal stage.

## Mapping to GPT-5.6 guidance

| Official guidance | Implementation |
|---|---|
| State outcomes and stop rules | Six-part core contract and completion conditions |
| Remove repeated process instructions | Six small self-contained bodies; no mandatory chain |
| Define autonomy and permissions | Local change authority separated from external/destructive authority |
| Route tools by dependency | Parallel independent work; sequential dependencies; synthesis before claims |
| Validate what matters | Claim-to-evidence selection and explicit gaps |
| Keep progress sparse | Outcome-first reporting and phase-level updates |
| Evaluate representative work | Stable eight-scenario routing manifest |

## Prompt budget

Repository validation enforces:

- core: at most 350 words;
- each spoke: at most 300 words;
- complete package: at most 1,650 words;
- no nested resource documents or required sibling calls.

Version 0.2 currently uses 307 core words and 1,589 words total. These are guardrails, not targets.
