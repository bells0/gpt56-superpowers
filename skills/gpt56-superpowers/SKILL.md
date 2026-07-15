---
name: gpt56-superpowers
description: Use when the user explicitly invokes $gpt56-superpowers for an end-to-end development workflow with risk-based planning, implementation, validation, and delivery. Do not use for ordinary questions or uninvoked small tasks.
---

# GPT-5.6 Superpowers

## Outcome

Complete the requested development outcome with the least process that preserves correctness, evidence, user intent, and safety. Define the destination and boundaries; let GPT-5.6 choose the efficient path.

Do not force brainstorming, a written plan, a worktree, TDD, subagents, review, full tests, commits, or a PR. Use each only when its decision rule below is met.

## Establish the contract

Before acting, resolve six facts from the request and available context:

1. Goal: the user-visible result.
2. Success: what must be true at completion.
3. Constraints: project rules, explicit values, scope, and compatibility.
4. Evidence: files, logs, docs, tests, or sources needed to support decisions.
5. Permission: which local and external actions are authorized.
6. Stop: when to finish, ask, fall back, or report a blocker.

Inspect available context before asking. Ask only for a missing choice that would materially change the result and cannot be safely inferred. Otherwise state a useful assumption and proceed.

## Choose the smallest route

Classify by the highest material impact, irreversibility, and uncertainty. A security-sensitive domain outranks a low-risk file type.

| Risk | Typical work | Process | Validation |
|---|---|---|---|
| Low | Reading, docs, prompts, skills, static config, styling, mechanical edits | Act directly | Inspect the diff; check format, schema, links, or a minimal smoke test |
| Medium | Local behavior changes, ordinary bugs, a few related files | Briefly decompose dependencies; design only if ambiguity matters | Reproduce or run targeted tests, then affected type, lint, build, or smoke checks |
| High | Security, auth, privacy, payments, migrations, concurrency, public APIs, cross-module architecture, release work | Record key decisions and a compact plan; isolate when useful; add independent review when uncertainty, blast radius, a security boundary, or a release gate justifies it | Targeted regression plus affected integration/build checks; broaden only when release risk or project rules justify it |

External or destructive action is a permission boundary, not a risk score. A high-risk local task can proceed within scope; an unapproved external write cannot.

## Execute

1. Ground in the relevant project, artifacts, and rules. Preserve user changes and explicit values.
2. Resolve prerequisites before dependent action. Parallelize independent reads; keep dependent steps sequential; synthesize before editing.
3. Make the smallest coherent change that satisfies the contract. Avoid unrelated refactors and speculative features.
4. Validate each material claim with matching evidence. Do not claim a test, build, fix, or release state that was not checked.
5. Report the outcome first, then decisive evidence, material caveats, and the next action only when one remains.

For tool-heavy work, send one short preamble and update only at major phase changes or when evidence changes the plan. Do not narrate routine calls.

Use programmatic aggregation only for bounded deterministic filtering, joining, sorting, deduplication, or repeated validation. Use direct judgment for approvals, semantic decisions, citations, and final checks.

Delegate only when work is genuinely independent, parallelism saves time, or a high-risk change benefits from a fresh review. Do not create an implementer and two reviewers for every task.

## Permission boundary

- Answer, explain, review, diagnose, or plan: inspect and report; do not implement unless requested.
- Change, build, or fix: make in-scope local changes and run relevant non-destructive validation without asking again.
- Require confirmation when the current request does not specifically authorize an external write, destructive action, purchase, force push, permanent discard, or material scope expansion.
- Treat explicit authorization in the current request as sufficient; do not repeatedly seek the same approval.

## Load references only when needed

Read only the reference that changes the current decision:

- Material product, UX, architecture, or scope ambiguity: references/design-and-planning.md
- Medium/high behavior changes, an unclear validation level, a TDD choice, visual verification, or a release-readiness claim: references/testing-and-verification.md
- Ambiguous, intermittent, multi-component, or unresolved failures: references/debugging.md
- Parallel agents or independent review: references/delegation-and-review.md
- Branches, worktrees, commits, push, PR, merge, or cleanup: references/git-and-delivery.md

Do not preload all references and do not follow reference links unless they are directly needed.

## Stop rules

Stop when success criteria are met with proportionate evidence. Try at most one or two meaningful fallbacks for empty, partial, or suspicious results. Do not keep searching to improve phrasing or add nonessential detail.

If required evidence or authority is missing, name the exact gap and the smallest next step. If validation is unavailable, state what was checked, what was not, and the next best verification.
