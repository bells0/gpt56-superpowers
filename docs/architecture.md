# Architecture

## Goal

Give GPT-5.6 a small set of precise development lenses without re-teaching reliable base-model behavior or forcing every task through one workflow.

## Hub and spokes

The suite contains ten focused Skills:

```text
gpt56-superpowers                       Sol-led cross-phase coordination
├── gpt56-design-planning               material ambiguity
├── gpt56-writing-plans                 implementation-ready plans
├── gpt56-using-git-worktrees           justified repository isolation
├── gpt56-subagent-driven-development   bounded plan execution
├── gpt56-debugging                     non-obvious failures
├── gpt56-verification                  claim-matched evidence
├── gpt56-purpose-bound-rigor           necessity for workflow defenses
├── gpt56-delegation-review             independent work or judgment
└── gpt56-git-delivery                  repository delivery state
```

The diagram describes ownership, not a required call chain. Every spoke is a direct entry point. Design may hand settled requirements to Writing Plans; a suitable plan may hand independently ownable outcomes to Subagent Development; Worktree Isolation is optional; Verification and Git Delivery close only the claims and repository actions that need them.

The full repository installer adds the concise `.codex/purpose-bound-rigor.md` fragment to the user's effective global `AGENTS.md`, so every development run receives the invariant before work starts. It also installs `.codex/agents/execution-efficiency-auditor.toml` as a user-level custom Agent. The Agent remains deliberately outside the normal chain: it provides a read-only audit only after a user requests it or repeated execution drift is already evident, never as an automatic reviewer or release gate.

## Routing rules

- Read-only and clear non-repository work: no suite Skill.
- Completed repository-changing work: Git & Delivery supplies the default scoped local commit.
- One consequential decision domain: one narrow Skill.
- Two or more dependent phases whose ordering and synthesis affect success: core plus only the one or two narrow Skills that change a decision.
- Proposed hashes, gates, isolation, mocks, freezes, repeated reviews, or broad reruns: Purpose-Bound Rigor requires a concrete protected outcome, observed risk, existing gap, and minimal intervention.
- External or destructive action: a permission boundary independent of task complexity.

All Skills allow implicit invocation, but their descriptions deliberately require a material match. This replaces both the old always-trigger router and version 0.1's single explicit bottleneck.

## Design decisions

### Outcome over ritual

The core resolves goal, success, constraints, evidence, permission, and stop conditions, then sequences dependent work. It does not prescribe an implementation methodology.

### Focused ownership

Each spoke owns one decision domain. Trigger overlap is minimized by separating design uncertainty, implementation planning, isolation, bounded execution, causal uncertainty, evidence selection, coordination value, and Git delivery state. Git & Delivery additionally owns the suite-wide local completion commit for repository changes.

### Grounded implementation plans

Writing Plans distinguishes user-provided facts, repository observations, proposed choices, and unresolved facts. Exact paths, symbols, commands, and current behavior must come from evidence rather than model completion.

### Conditional isolation and subagents

Worktree Isolation activates only for an explicit request or a concrete safety benefit. Subagent Development activates only for implementation-ready plans with independently ownable outcomes; Sol retains shared state, integration decisions, and final evidence.

### Scoped completion commits

One completed user-visible outcome maps to one local commit per affected repository. Task-owned paths or hunks are staged explicitly, unrelated user changes remain untouched, and explicit opt-outs or unsafe, incomplete, failed, blocked, or empty work remains uncommitted. Push and other remote authority stay separate.

### Claim-based verification

Verification starts with the statement being made:

- artifact validity: diff, format, schema, links;
- bug fixed: original symptom;
- behavior works: narrow reliable check or smoke;
- visual correctness: rendered affected states;
- integration health: affected type, lint, build, contract, or integration check;
- release readiness: project-required and risk-justified gates.

The scope broadens only when the claim, observed failures, uncertain dependency boundary, release risk, or project rules require it.

### Purpose-bound rigor

The direct path is the default for local, reversible work. A non-default defense must name the exact outcome it protects, evidence that the risk exists now, why existing controls are insufficient, and why the proposal is the cheapest effective response. Missing answers reject the defense rather than creating another approval ritual.

### Bounded coordination

Delegation is justified by independent deliverables, elapsed-time savings, or fresh judgment that can change a material decision. Review is focused on named risks rather than added as a universal stage.

## Mapping to GPT-5.6 guidance

| Official guidance | Implementation |
|---|---|
| State outcomes and stop rules | Six-part core contract and completion conditions |
| Remove repeated process instructions | Nine focused bodies loaded only at matching boundaries; no mandatory chain |
| Define autonomy and permissions | Completed local changes include a scoped commit; remote and destructive authority stay separate |
| Route tools by dependency | Parallel independent work; sequential dependencies; synthesis before claims |
| Validate what matters | Claim-to-evidence selection and explicit gaps |
| Keep progress sparse | Outcome-first reporting and phase-level updates |
| Evaluate representative work | Stable twelve-scenario routing manifest |

## Prompt budget

Repository validation enforces per-Skill budgets based on each contract's complexity:

- coordinator: at most 600 words;
- compact decision Skills: 300–450 words;
- Writing Plans, Worktree Isolation, and Subagent Development: 600–850 words;
- Purpose-Bound Rigor: at most 500 words;
- complete package: at most 4,800 words;
- only declared SDD resources and no mandatory `$skill` call chain.

Version 0.5 currently uses 587 coordinator words and 4,678 words total. These are guardrails, not targets; normal routing loads only the matching bodies and any explicitly needed resource.
