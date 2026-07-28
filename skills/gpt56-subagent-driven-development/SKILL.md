---
name: gpt56-subagent-driven-development
description: Execute an implementation-ready plan through bounded Codex subagents under GPT-5.6 Sol control. Use when a plan has at least two independently ownable outcomes and context isolation, parallel read work, or specialized implementation materially improves speed or quality. Exclude simple tasks, unresolved designs, tightly coupled edits, overlapping file ownership, and delegation whose coordination cost exceeds its benefit.
---

# GPT-5.6 Sol Subagent Development

Keep Sol accountable for the contract, decomposition, integration, and final evidence. Delegate bounded outcomes, not responsibility for the whole result.

## Preflight the plan

1. Read the complete plan and repository instructions.
2. Resolve contradictory tasks, missing interfaces, unstable ownership, or plan-required defects before dispatch.
3. Use `gpt56-writing-plans` when the input is not implementation-ready. Use `gpt56-design-planning` when a consequential choice remains open.
4. Use `gpt56-using-git-worktrees` only when isolation is requested or materially useful; it is not a mandatory ceremony.
5. Assign one owner to each mutable file or shared state boundary. Keep cross-cutting architecture, integration decisions, and final synthesis with Sol.

Default to sequential implementation when agents share a checkout. Parallelize read-only investigations freely when independent; parallelize writes only across disjoint artifacts with stable interfaces.

## Preserve durable task state

For three or more delegated tasks, a run likely to survive compaction, or a review-heavy change, use the bundled helper:

```text
node scripts/sdd-tools.cjs workspace PLAN_FILE
node scripts/sdd-tools.cjs brief PLAN_FILE TASK_NUMBER
node scripts/sdd-tools.cjs review-package PLAN_FILE BASE_SHA HEAD_SHA
```

The helper stores ignored, plan-scoped briefs, reports, progress, and diff packages under `.gpt56/sdd/<plan-name>/`. If Node is unavailable, keep the same contracts with available file tools; do not block a short run merely to recreate the helper.

Create `progress.md` with the plan path, source revision, task status, agent identity, owned paths, commits if any, validation evidence, concerns, and deferred findings. Trust the ledger and Git history after compaction; never redispatch a task already recorded complete without evidence that its result was lost.

## Dispatch bounded implementers

Use [references/implementer-prompt.md](references/implementer-prompt.md) when assigning code changes.

- Give the outcome, task brief, owned paths, stable interfaces, global constraints, relevant context, evidence contract, and report path.
- Use fresh or task-local context. Do not paste the whole session or accumulated task transcripts.
- Tell every writing agent that it is not alone in the codebase, must not revert others, and must stay within assigned ownership.
- Prefer Terra for bounded, well-specified routine implementation when routing is available. Keep ambiguous, multi-component, high-impact, or integration-heavy work on Sol. Respect user-pinned models and available tool schemas.
- Do not require a worker commit unless commit ownership is explicitly assigned. The controller or `gpt56-git-delivery` normally owns the coherent completion commit.

Require one status:

- `DONE`: implemented and verified within scope.
- `DONE_WITH_CONCERNS`: complete but a named correctness or integration concern remains.
- `NEEDS_CONTEXT`: a specific missing input blocks safe work.
- `BLOCKED`: the approach, environment, or plan prevents completion.

If a worker is blocked, change the missing context, task boundary, model capability, or plan. Do not repeat the same dispatch unchanged.

## Integrate and review proportionately

After every writing task, inspect the actual diff and reported evidence before accepting the result. Resolve shared-interface mismatches before starting dependent tasks.

Do not force an independent reviewer after every task. Use `gpt56-delegation-review` when the user requests review or a specific unresolved high-impact judgment can realistically change the result. For a review, generate a diff package and use [references/reviewer-prompt.md](references/reviewer-prompt.md).

A multi-agent write run normally earns one integrated final review when:

- several agents changed production code;
- interfaces, auth, concurrency, migrations, or shared state cross task boundaries;
- task-local evidence cannot support the whole-branch claim.

For review findings, resume the original implementer when its context remains useful. After two unsuccessful delegated fix rounds, stop the loop: Sol diagnoses whether the issue is wrong context, a plan defect, a coupled change, or insufficient capability, then chooses a coherent fix or escalates. Never create an unbounded review-fix cycle.

## Complete the outcome

1. Reconcile task outputs against the plan, global constraints, and current repository state.
2. Run focused checks during tasks and the integration-level checks required by the final claim.
3. Use `gpt56-verification` when the evidence strategy remains materially uncertain.
4. Resolve or explicitly report every concern, blocked item, and deferred finding.
5. Use `gpt56-git-delivery` for the scoped completion commit and any authorized delivery or cleanup.

Report the integrated result, decisive evidence, material findings changed by review, and remaining gaps. Do not return a transcript of agent activity.
