# Architecture

## Goal

Give evolving coding agents a small set of precise development lenses without re-teaching reliable base-model behavior or forcing every task through one workflow.

## Hub and spokes

The suite contains eleven focused Skills:

```text
agentic-superpowers                       controller-led cross-phase coordination
├── agentic-orchestrate-delivery          opt-in standardized delivery lifecycle
├── agentic-design-planning               material ambiguity
├── agentic-writing-plans                 implementation-ready plans
├── agentic-using-git-worktrees           justified repository isolation
├── agentic-subagent-driven-development   bounded plan execution
├── agentic-debugging                     non-obvious failures
├── agentic-verification                  claim-matched evidence
├── agentic-purpose-bound-rigor           necessity for workflow defenses
├── agentic-delegation-review             independent work or judgment
└── agentic-git-delivery                  repository delivery state
```

The diagram describes ownership, not a required call chain. Every spoke is a direct entry point. Orchestrated Delivery is the explicit exception for users who want a standardized current-truth → Spec → Plan → Execution → Review → Verification → Acceptance → Closure lifecycle; its narrow trigger prevents that workflow from becoming a tax on ordinary tasks. Design may hand settled requirements to Writing Plans; a suitable plan may hand independently ownable outcomes to Subagent Development; Worktree Isolation is optional; Verification and Git Delivery close only the claims and repository actions that need them.

The full repository installer adds the concise `.codex/purpose-bound-rigor.md` fragment to the user's effective global `AGENTS.md`, so every development run receives the invariant before work starts. It also installs `.codex/agents/execution-efficiency-auditor.toml` as a user-level custom Agent. The Agent remains deliberately outside the normal chain: it provides a read-only audit only after a user requests it or repeated execution drift is already evident, never as an automatic reviewer or release gate.

## Routing rules

- Read-only and clear non-repository work: no suite Skill.
- Explicit standardized delivery or long-running multi-module work that needs durable cross-phase control: Orchestrated Delivery.
- Completed repository-changing outcomes: Git & Delivery supplies atomic local commits at verified boundaries.
- One consequential decision domain: one narrow Skill.
- Two or more dependent phases whose ordering and synthesis affect success: core plus only the one or two narrow Skills that change a decision.
- Proposed hashes, gates, isolation, mocks, freezes, repeated reviews, or broad reruns: Purpose-Bound Rigor requires a concrete protected outcome, observed risk, existing gap, and minimal intervention.
- External or destructive action: a permission boundary independent of task complexity.

All Skills allow implicit invocation, but their descriptions deliberately require a material match. This replaces both the old always-trigger router and version 0.1's single explicit bottleneck.

## Design decisions

### Outcome over ritual

The core resolves goal, success, constraints, evidence, permission, and stop conditions, then sequences dependent work. It does not prescribe an implementation methodology.

### Explicit standardized delivery

Orchestrated Delivery codifies the controller-led method only when the user selects it or the task strongly matches its long-running, multi-module trigger. The controller retains requirements, decisions, shared interfaces, integration, acceptance, and Git closure; explorers, implementers, reviewers, debuggers, and verifiers receive bounded role contracts. Engineering verification and user acceptance remain separate gates.

### Focused ownership

Each spoke owns one decision domain. Trigger overlap is minimized by separating design uncertainty, implementation planning, isolation, bounded execution, causal uncertainty, evidence selection, coordination value, and Git delivery state. Git & Delivery additionally owns suite-wide atomic commit boundaries for repository changes.

### Stable identity, versioned model profiles

Repository, plugin, and Skill identifiers describe durable agentic-engineering responsibilities rather than a model generation. Model-specific prompting inputs, assumptions, and evaluation status live in [model profiles](model-profiles.md). A future model update changes a profile and the affected contracts, not every public identifier.

### Grounded implementation plans

Writing Plans distinguishes user-provided facts, repository observations, proposed choices, and unresolved facts. Exact paths, symbols, commands, and current behavior must come from evidence rather than model completion.

### Conditional isolation and subagents

Worktree Isolation activates only for an explicit request or a concrete safety benefit. Subagent Development activates only for implementation-ready plans with independently ownable outcomes; the controller retains shared state, integration decisions, and final evidence.

### Atomic completion commits

Each independently acceptable outcome maps to one local commit per affected repository after focused evidence passes. The outcome must have one purpose and be independently revertible without leaving dependent history broken; every edit or partial test phase is not a boundary. An approved Plan supplies the commit map, and dependent work starts only after the current boundary is verified and committed. Task-owned paths or hunks are staged explicitly, unrelated user changes remain untouched, and proposed, opted-out, unsafe, incomplete, failed, blocked, or empty work remains uncommitted. Push and other remote authority stay separate.

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

## Current guidance mapping

| Current model-profile guidance | Stable implementation |
|---|---|
| State outcomes and stop rules | Six-part core contract and completion conditions |
| Remove repeated process instructions | Nine focused bodies loaded only at matching boundaries; no mandatory chain |
| Define autonomy and permissions | Verified local outcomes receive atomic commits; remote and destructive authority stay separate |
| Route tools by dependency | Parallel independent work; sequential dependencies; synthesis before claims |
| Validate what matters | Claim-to-evidence selection and explicit gaps |
| Keep progress sparse | Outcome-first reporting and phase-level updates |
| Evaluate representative work | Stable fourteen-scenario routing manifest |

## Prompt budget

Repository validation enforces per-Skill budgets based on each contract's complexity:

- coordinator: at most 600 words;
- compact decision Skills: 300–450 words;
- Writing Plans, Worktree Isolation, and Subagent Development: 600–850 words;
- Purpose-Bound Rigor: at most 500 words;
- Orchestrated Delivery: at most 900 words, with detailed references and copyable templates loaded only when needed;
- complete package: at most 5,800 words;
- only declared SDD resources and no mandatory `$skill` call chain.

Version 0.8 keeps the coordinator under 600 words and the complete package under 5,800 words. These are guardrails, not targets; normal routing loads only the matching bodies and any explicitly needed resource.
