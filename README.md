# GPT-5.6 Superpowers

A lean, effect-first replacement for the ceremony-heavy Superpowers workflow, designed for GPT-5.6 Sol and Codex.

Version 0.5 uses a dependency-aware hub-and-spoke structure: one Sol-first coordinator and nine focused Skills. A clear task can use one focused Skill directly—or no Skill at all—while planning, isolation, bounded subagent execution, and extra workflow defenses remain optional unless they materially improve the outcome.

## Why this exists

[OpenAI's GPT-5.6 prompting guidance](https://developers.openai.com/api/docs/guides/prompt-guidance-gpt-5p6) recommends defining outcomes, constraints, evidence, autonomy, validation, and stop rules while removing repeated process instructions the model already performs reliably.

This suite keeps the useful invariants—permission boundaries, project grounding, root-cause diagnosis, evidence before claims, preservation of user changes—and removes methodology ritual. It does not impose fail-first development, repeated broad suites, automatic worktrees, or per-task review chains. Completed repository-changing requests do receive one scoped local commit per affected repository by default; explicit opt-outs and unsafe or incomplete work remain uncommitted, and commit authority never implies push authority.

## Structure

| Skill | Use it for |
|---|---|
| `gpt56-superpowers` | Two or more dependent development phases that need end-to-end coordination |
| `gpt56-design-planning` | Consequential ambiguity in product, UX, architecture, interfaces, migrations, or scope |
| `gpt56-writing-plans` | Approved Spec → ordered implementation Plans → execution handoff |
| `gpt56-using-git-worktrees` | Explicit or justified worktree isolation that preserves existing user changes |
| `gpt56-subagent-driven-development` | Implementation-ready plans with independently ownable outcomes under Sol control |
| `gpt56-debugging` | Ambiguous, intermittent, environment-dependent, or multi-component failures |
| `gpt56-verification` | Choosing proportionate evidence for material completion claims |
| `gpt56-purpose-bound-rigor` | Requiring a concrete necessity case before adding hashes, gates, isolation, mocks, freezes, or repeated reviews |
| `gpt56-delegation-review` | Genuinely independent parallel work or a focused independent review |
| `gpt56-git-delivery` | Default scoped completion commits plus authorized branches, worktrees, pushes, pull requests, merges, or cleanup |

All ten are direct entry points. The execution-structure Skills may hand work to another focused Skill only at a real dependency boundary; no fixed chain is required. Narrow trigger descriptions allow implicit routing without an always-on router, and explicit `$skill-name` invocation remains available.

## Prompt footprint

The comparison baseline is a local 14-Skill installation from `obra/superpowers` at commit `b55764852ac78870e65c6565fb585b6cd8b3c5c9`.

| Measure | Baseline | Version 0.5 | Reduction |
|---|---:|---:|---:|
| Workflow Skills | 14 | 10 | 28.6% |
| Total `SKILL.md` words | 15,737 | 4,678 | 70.3% |
| Always-trigger router | Yes | No | Removed |

A focused route loads one body of 233–842 words. The longest Skills carry concrete planning, worktree, or subagent contracts and load only when those structures materially help. The full 4,678-word package is never a mandatory prompt chain. Word count is a structural proxy, not a model-quality or tokenization guarantee.

## Install

### New installation

Install all ten Skills from GitHub:

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo bells0/gpt56-superpowers \
  --path \
    skills/gpt56-superpowers \
    skills/gpt56-design-planning \
    skills/gpt56-writing-plans \
    skills/gpt56-using-git-worktrees \
    skills/gpt56-subagent-driven-development \
    skills/gpt56-debugging \
    skills/gpt56-verification \
    skills/gpt56-purpose-bound-rigor \
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

The migration is transactional: it validates the package, locks the Skills directory, backs up legacy or conflicting entries outside discovery, installs nine exact symlinks, and records which links were preserved or created. Restore the newest READY transaction with:

```bash
./scripts/restore-original.sh
```

You can also pass a specific backup directory. Existing version-0.3 six-Skill and version-0.1 backups remain restorable.

## Use

Implicit routing handles strong matches. Invoke a Skill explicitly when you want a specific lens:

```text
Use $gpt56-debugging to diagnose this intermittent cross-service failure.

Use $gpt56-verification to choose proportionate evidence for this release claim.

Use $gpt56-purpose-bound-rigor to decide whether these proposed gates and isolation steps are actually necessary.

Use $gpt56-writing-plans to turn this approved Spec into ordered, repository-grounded implementation Plans and define the Sol-controlled execution handoff.

Use $gpt56-superpowers to coordinate this migration end to end.

Use `docs/implementation-closed-loop.md` as a reusable template for long-running Spec → Plan → Execution workflows (including Plan A/B/C style handoffs and model-split recommendations).
```

Ordinary questions still use Codex directly. Completed repository changes implicitly add Git & Delivery for the scoped local completion commit; explicit `$skill-name` invocation remains available.

## Validation

The repository uses deterministic package checks, a twelve-case routing specification, and isolated install/restore transaction smoke tests. The scenarios constrain intended behavior; they are not a live model benchmark:

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

这是为 GPT-5.6 Sol 重写的轻量 Superpowers：`1 个 Sol 主控核心 + 9 个聚焦 Skill`。普通任务不加载，单领域任务只加载一个；实施计划、工作树隔离、子代理执行和额外防御措施只在确实能改善结果时形成可选衔接。

本版本彻底移除了开发方法论强制，不要求先写失败测试、不要求 RED/GREEN/REFACTOR、不要求重复跑全量测试。保留的是更薄的“声明—证据”验证：文档看 diff/schema/link，Bug 复查原始症状，行为跑最相关检查，视觉实际渲染，发布遵守项目门禁；无法验证就明确缺口。

完成并验证的仓库修改默认会按需求生成一个只包含本次改动的本地 commit；只读、计划、未完成、验证失败、无法安全隔离或明确要求不提交的工作不会自动提交。默认 commit 不代表允许自动 push。

## License and attribution

MIT. This is an original rewrite inspired by [obra/superpowers](https://github.com/obra/superpowers); see [third-party notices](THIRD_PARTY_NOTICES.md).
