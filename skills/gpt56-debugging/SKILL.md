---
name: gpt56-debugging
description: Diagnose and resolve ambiguous, intermittent, environment-dependent, multi-component, high-impact, or still-unexplained failures. Use when the cause is not evident from direct inspection or one evidence-backed attempt.
---

# GPT-5.6 Debugging

Find the earliest controllable cause of a non-obvious failure and prove that the original symptom changed.

## Investigate

1. Pin down the symptom, trigger, expected behavior, environment, and a known-good comparison when available.
2. Reproduce or capture the failure at the cheapest reliable boundary. Preserve useful logs and exact error state.
3. Trace inputs and outputs across components until the first expected-versus-actual divergence appears.
4. Form one falsifiable causal hypothesis at a time. Choose the next observation that best separates it from alternatives.
5. Fix the earliest controllable cause with the smallest coherent change; avoid masking a downstream symptom.

Use instrumentation, history, documentation, or comparison with working code when direct inspection is insufficient. Treat correlation as a lead, not a conclusion.

## Escalate intelligently

After two or three evidence-backed attempts fail, revisit the system model, assumptions, and component boundary instead of stacking patches. Surface a blocker when the missing evidence depends on unavailable access, environment, data, or authority.

## Completion

Recheck the original symptom and the nearest plausible regression surface. Report the observed cause, the evidence that supports it, the change made, what now passes, and any validation gap. If no fix was requested, stop after the diagnosis and evidence.
