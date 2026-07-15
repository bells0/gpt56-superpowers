---
name: gpt56-verification
description: Choose proportionate evidence when validation strategy is the task, a material claim spans evidence layers, release gates are unclear, or validation remains uncertain after primary work. Do not invoke for a routine targeted check.
---

# GPT-5.6 Verification

Match each material completion claim to the cheapest evidence capable of disproving it.

## Choose evidence by claim

| Claim | Useful evidence |
|---|---|
| Documentation or static configuration is valid | Diff inspection plus relevant format, schema, and link checks |
| A bug is fixed | Original symptom or a stable reproduction path |
| Behavior works | Narrow reliable check or smoke path covering the changed behavior |
| Visual output is correct | Render and inspect affected states and dimensions |
| Integration remains healthy | Affected type, lint, build, contract, or integration check |
| A release is ready | Project-required gates and broader checks justified by release risk |

Start narrow. Broaden when failures reveal adjacent impact, dependency boundaries are uncertain, project rules require it, or the claim itself is broad. Run expensive checks after the change stabilizes; repeat them only when later edits invalidate the result.

Prefer observable output over implementation ritual. A change can be correct without adding a new automated test when existing evidence is sufficient; durable regression coverage is useful when the failure is likely to recur or the project requires it.

## Completion

Record the relevant command, observation, or artifact and its result. Do not translate a partial check into a broader claim. When a check is unavailable or fails for an unrelated reason, state what was checked, what remains unknown, and the best next verification step.
