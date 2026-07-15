# GPT-5.6 Superpowers

A lean, effect-first replacement for the ceremony-heavy Superpowers workflow, designed for GPT-5.6 Sol and Codex.

Version 0.2 uses a hub-and-spoke structure: one compact coordinator for genuinely multi-phase work and five independent narrow Skills. A clear task can use one narrow Skill directly—or no Skill at all—without entering a mandatory chain.

## Why this exists

[OpenAI's GPT-5.6 prompting guidance](https://developers.openai.com/api/docs/guides/prompt-guidance-gpt-5p6) recommends defining outcomes, constraints, evidence, autonomy, validation, and stop rules while removing repeated process instructions the model already performs reliably.

This suite keeps the useful invariants—permission boundaries, project grounding, root-cause diagnosis, evidence before claims, preservation of user changes—and removes methodology ritual. In particular, it does not impose fail-first development, repeated broad suites, automatic worktrees, per-task review chains, or mandatory commits.

## Structure

| Skill | Use it for |
|---|---|
| `gpt56-superpowers` | Two or more dependent development phases that need end-to-end coordination |
| `gpt56-design-planning` | Consequential ambiguity in product, UX, architecture, interfaces, migrations, or scope |
| `gpt56-debugging` | Ambiguous, intermittent, environment-dependent, or multi-component failures |
| `gpt56-verification` | Choosing proportionate evidence for material completion claims |
| `gpt56-delegation-review` | Genuinely independent parallel work or a focused independent review |
| `gpt56-git-delivery` | Authorized branches, worktrees, commits, pushes, pull requests, merges, or cleanup |

All six are siblings. None requires another. Narrow trigger descriptions allow implicit routing without an always-on router; explicit `$skill-name` invocation remains available.

## Prompt footprint

The comparison baseline is a local 14-Skill installation from `obra/superpowers` at commit `b55764852ac78870e65c6565fb585b6cd8b3c5c9`.

| Measure | Baseline | Version 0.2 | Reduction |
|---|---:|---:|---:|
| Workflow Skills | 14 | 6 | 57.1% |
| Total `SKILL.md` words | 15,737 | 1,589 | 89.9% |
| Always-trigger router | Yes | No | Removed |

A normal routed task loads one body of 233–307 words. The representative multi-phase route—core plus design and verification—is 829 words. The full 1,589-word package is not a mandatory prompt chain. Word count is a structural proxy, not a model-quality or tokenization guarantee.

## Install

### New installation

Install all six Skills from GitHub:

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo bells0/gpt56-superpowers \
  --path \
    skills/gpt56-superpowers \
    skills/gpt56-design-planning \
    skills/gpt56-debugging \
    skills/gpt56-verification \
    skills/gpt56-delegation-review \
    skills/gpt56-git-delivery
```

Start a new Codex task after installation so Skill discovery refreshes.

### Replace an existing `obra/superpowers` installation

```bash
git clone git@github.com:bells0/gpt56-superpowers.git
cd gpt56-superpowers
./scripts/install-local.sh
```

The migration is transactional: it validates the package, locks the Skills directory, backs up legacy or conflicting entries outside discovery, installs six exact symlinks, and records which links were preserved or created. Restore the newest READY transaction with:

```bash
./scripts/restore-original.sh
```

You can also pass a specific backup directory. Existing version-0.1 backups remain restorable.

## Use

Implicit routing handles strong matches. Invoke a Skill explicitly when you want a specific lens:

```text
Use $gpt56-debugging to diagnose this intermittent cross-service failure.

Use $gpt56-verification to choose proportionate evidence for this release claim.

Use $gpt56-superpowers to coordinate this migration end to end.
```

Ordinary questions, clear documentation edits, and simple local changes should use Codex directly.

## Validation

The repository uses deterministic package checks, an eight-case routing specification, and isolated install/restore transaction smoke tests. The scenarios constrain intended behavior; they are not a live model benchmark:

```bash
make validate
```

Run the canonical Codex Skill and plugin validators with:

```bash
make dev-deps
make local-codex-validate
```

See [architecture](docs/architecture.md), [migration mapping](docs/migration-from-obra-superpowers.md), and [evaluation](docs/evaluation.md).

## 中文说明

这是为 GPT-5.6 Sol 重写的轻量 Superpowers：`1 个跨阶段核心 + 5 个独立窄领域 Skill`。普通任务不加载，单领域任务只加载一个，真正复杂的任务才由核心协调并最多组合少量窄 Skill。

本版本彻底移除了开发方法论强制，不要求先写失败测试、不要求 RED/GREEN/REFACTOR、不要求重复跑全量测试。保留的是更薄的“声明—证据”验证：文档看 diff/schema/link，Bug 复查原始症状，行为跑最相关检查，视觉实际渲染，发布遵守项目门禁；无法验证就明确缺口。

## License and attribution

MIT. This is an original rewrite inspired by [obra/superpowers](https://github.com/obra/superpowers); see [third-party notices](THIRD_PARTY_NOTICES.md).
