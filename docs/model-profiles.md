# Model Profiles

Agentic Superpowers keeps repository, plugin, and Skill identifiers stable across model generations. A model profile records what influenced the current contracts and what evidence actually exists; it is not part of the public namespace.

## Current profile

| Field | Current value |
|---|---|
| Profile | OpenAI GPT-5.6 Sol |
| Recorded | 2026-08-31 |
| Role | Design and prompting-guidance input for version 0.8 |
| Deterministic evidence | Package structure, prompt budgets, routing scenarios, global-runtime behavior, and install/restore transactions |
| Live-model evidence | Historical focused scenarios described in [evaluation](evaluation.md); no repository-wide live routing, latency, token, or cost benchmark is claimed |

The suite may work with other capable coding agents, but compatibility must not be inferred from model-neutral naming alone.

## Updating for a new model

1. Read the model's primary prompting and tool-use guidance.
2. Compare new reliable base behavior with the existing Skill contracts.
3. Change a Skill only when the new behavior changes routing, required constraints, or useful evidence.
4. Run deterministic package validation and the representative scenarios affected by the change.
5. Record live-model results separately from static checks, including model identifier, date, scenario, and limitations.
6. Increment the suite version without renaming the repository, plugin, or `agentic-*` Skill IDs.

Model-specific worker recommendations belong in dated evaluation evidence, not permanent Skill contracts, unless the suite intentionally introduces a separate model-bound profile package.
