# Evaluation

The checked-in scenario matrix tests routing intent and package invariants. It is not a claim that a live GPT-5.6 benchmark occurred.

## Nine representative scenarios

| Scenario | Expected route | Decisive behavior |
|---|---|---|
| Read-only code explanation | None | Answer from inspected evidence without workflow overhead |
| Clear static edit | Git & Delivery | Direct change, obvious artifact checks, and a scoped local commit |
| Public API or migration ambiguity | Design & Planning | Choose a tradeoff and define boundaries and acceptance |
| Intermittent cross-component failure and fix | Debugging + Git & Delivery | Find the first divergence, recheck the symptom, and commit the completed fix |
| Material visual or release claim | Verification | Match claim breadth to reliable evidence |
| Independent investigations or focused security review | Delegation & Review | Parallelize true independence and synthesize findings |
| Authorized branch, commit, push, and pull request | Git & Delivery | Preserve unrelated state and verify delivery results |
| Cross-module migration with architecture and evidence dependencies | Core + Design + Verification | Coordinate phases without loading the complete suite |
| Explicit no-commit request | Git & Delivery | Verify the change while leaving it uncommitted |

`tests/scenarios.json` keeps these expectations machine-checkable and ensures every Skill has a distinct effect boundary.

## Current evidence

- Deterministic validation checks the six structures, trigger-budget limits, forbidden ritual language, sibling independence, and scenario specification.
- Transaction smoke tests exercise fresh and upgrade installs, exact restore semantics, conflicts, injected install and restore failures, version-1 compatibility, path aliases, locks, spaces, and broken links in about two seconds on the development machine.
- A three-case blind forward review on 2026-07-20 covered an implicit simple-change commit, an explicit no-commit request, and a multi-repository completion. All three followed the version-0.3 local-commit contract.

The blind review tests semantic separation in the discovery descriptions. It does not exercise Codex's production implicit router and is not a live GPT-5.6 outcome, latency, token, or cost benchmark.

## Compare effectiveness

1. Hold model, reasoning effort, tools, project state, and task text constant.
2. Run the previous workflow and this suite on the same cases.
3. Evaluate task success before resource reduction.
4. Inspect regressions, change one instruction group, and rerun the affected cases.

Useful metrics include:

- requirements satisfied and regressions introduced;
- unsupported completion claims;
- unnecessary questions or approval requests;
- wrong, missing, or excess Skill routes;
- tool calls, retries, turns, loaded prompt words, tokens, latency, and cost;
- preservation of user changes and permission boundaries.

Keep a rule only when it changes representative behavior without unacceptable cost. Structural word counts measure potential prompt footprint; they do not substitute for live outcome evaluation.
