# Evaluation

The project uses a small representative matrix instead of per-Skill pressure-test agents. The checked-in JSON is an eval manifest, not a claim that a live GPT-5.6 run occurred.

## Six scenarios

| Scenario | Expected route | Decisive behavior |
|---|---|---|
| Ordinary read-only question | Do not invoke | Answer directly without workflow overhead |
| Documentation or Skill text edit | Low | Direct edit plus diff, schema, and link checks |
| Local static configuration change | Low | No approval for in-scope local mutation; deterministic validation |
| Ordinary reproducible bug | Medium | Original-symptom or targeted regression evidence; no automatic full suite |
| Authentication behavior change | High | Compact decisions, focused security review, affected integration checks |
| Git cleanup that would require an unspecified destructive method | Permission boundary | Ask only for the specific destructive operation; an already explicit request is sufficient authorization |

tests/scenarios.json makes these expectations machine-checkable and keeps the matrix stable across prompt revisions.

## Compare correctly

1. Hold model, reasoning effort, tools, project state, and task text constant.
2. Run the existing workflow and record the result.
3. Change one instruction group or use this Skill.
4. Re-run the same cases.
5. Count resource reduction as improvement only when existing pass criteria still hold.

Recommended metrics:

- task success and missing requirements;
- unsupported completion claims;
- unnecessary questions or approval requests;
- Skills and references loaded;
- tool calls, retries, turns, total tokens, latency, and cost;
- regressions in safety, evidence, or preservation of user changes.

## Failure-driven tuning

When a scenario regresses, inspect the smallest set of traces that exposes the failure. Classify it as a missing success criterion, contradictory rule, permission error, tool-routing error, validation gap, or stop-condition error. Make one surgical change and re-run the same cases.

Do not add examples or absolute rules merely because they sound helpful. Keep a rule only when it changes measured behavior without unacceptable cost.
