---
name: agentic-orchestrate-delivery
description: Run a controller-led, evidence-gated software delivery workflow from current-state discovery through requirements, implementation planning, bounded subagent execution, independent review, real-path verification, user acceptance, documentation, and Git closure. Use when the user explicitly requests this standardized workflow or a long-running multi-module change needs durable cross-phase control. Exclude simple local edits, read-only analysis, ad hoc delegation, and work whose consequential requirements remain unavailable.
---

# Agentic Orchestrated Delivery

Keep the main thread accountable for semantics, decomposition, shared interfaces, integration, evidence, and completion. Delegate bounded execution, never ownership of the whole outcome.

## Establish authority and current truth

1. Read repository instructions, the request, relevant code, tests, documentation, Git state, and any approved Spec or Plan.
2. Define the goal, observable success, non-goals, constraints, permission boundary, required evidence, and stop conditions.
3. Classify exact details as **Provided**, **Observed**, **Proposed**, or **Unresolved**. Never present a proposal as current behavior.
4. Distinguish product decisions from implementation choices. Ask only when an unresolved consequential choice cannot be inferred safely.
5. Preserve unrelated user changes and record the starting revision or dirty state when it affects delivery.

Read [references/decision-and-escalation.md](references/decision-and-escalation.md) whenever requirements, facts, or failure handling are uncertain.

## Run the lifecycle

Follow the gates in [references/lifecycle.md](references/lifecycle.md). Move forward only when the current phase has enough evidence for the next phase:

```text
Current truth -> Spec -> Plan -> Execution -> Review -> Verification
              -> User acceptance -> Documentation and Git closure
```

- Skip an artifact only when its information is already settled and traceable elsewhere.
- Return to the owning phase when new evidence invalidates an upstream assumption.
- Keep cross-phase state durable for long runs, three or more delegated tasks, review-heavy work, or likely context compaction. Copy [assets/delivery-workbook.md](assets/delivery-workbook.md) when one consolidated ledger is useful.
- Report meaningful phase transitions and blockers; do not stream raw logs into the main thread.

## Control delegation

Read [references/role-contracts.md](references/role-contracts.md) before dispatching agents.

- Keep requirements, consequential decisions, shared mutable state, integration, and final claims in the controller thread.
- Use explorers for read-only current-state mapping and workers for implementation-ready outcomes.
- Assign one owner per mutable file or shared-state boundary. Parallelize writes only across disjoint artifacts with stable interfaces.
- Give each worker an outcome, owned paths, inputs, outputs, constraints, evidence contract, and return format. Copy [assets/task-brief.md](assets/task-brief.md) for substantial assignments.
- Tell writing agents they are not alone, must preserve others' work, and must stop on ownership or interface conflict.
- Require `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, or `BLOCKED`. Do not treat a worker report as proof.
- After two failed attempts with the same approach, change the approach, repair the plan or task boundary, or surface the genuinely missing fact.

## Integrate, review, and verify

Inspect every writing task's diff and focused evidence before accepting it. Copy [assets/worker-report.md](assets/worker-report.md) when durable handoff evidence is needed.

Use an independent reviewer for production-code outcomes selected by this workflow, while keeping the review boundary proportionate: review an independently accepted outcome or the integrated multi-owner result, not every mechanical edit. Keep the reviewer read-only and independent from implementer rationale. Copy [assets/review-report.md](assets/review-report.md) for findings and re-review status.

Read [references/evidence-and-closure.md](references/evidence-and-closure.md) before making completion or delivery claims. Prefer the real user path and observable output. Mocks may add regression coverage but never replace requested real-path acceptance. Resolve supported findings, re-review the fix boundary, and avoid unbounded review-fix loops.

Treat engineering verification and user acceptance as separate gates:

- **Engineering verification:** the implementation satisfies the claim with proportionate technical evidence.
- **User acceptance:** the user-visible result and workflow satisfy the agreed intent; record pending acceptance without calling the work fully accepted.

## Close the delivery

Update affected documentation to current truth. On a task-specific feature branch, commit each verified, independently acceptable repository outcome at its approved boundary. Child-repository commits precede parent gitlink or pointer updates. Stage only task-owned paths and preserve dirty state. Use `agentic-git-delivery` to push the branch, create the evidence-bearing PR, obtain independent approval, pass required checks, and control merge; explicit local-only instructions stop before push.

Finish with the integrated outcome, decisive evidence, review disposition, acceptance state, documentation state, branch and PR state, commits, checks, approval, merge state, preserved user changes, and remaining gaps. Do not return a transcript of agent activity.
