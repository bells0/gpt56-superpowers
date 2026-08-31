# Agentic Superpowers

A lean, effect-first development Skill suite whose stable identity survives model upgrades.

Version 0.8 introduces the model-neutral `agentic-*` namespace while retaining the dependency-aware hub-and-spoke structure: one accountable coordinator, one explicit controller-led delivery workflow, and nine focused Skills. A clear task can use one focused Skill directly—or no Skill at all—while long-running work can opt into a durable current-truth → Spec → Plan → Execution → Review → Verification → Acceptance → Closure lifecycle. The full repository installer also adds a concise global purpose-bound-rigor rule and an on-demand read-only audit agent.

## Why this exists

The suite evolves through versioned model profiles instead of embedding a model generation in repository, plugin, or Skill identifiers. The current profile was shaped by [OpenAI's GPT-5.6 prompting guidance](https://developers.openai.com/api/docs/guides/prompt-guidance-gpt-5p6), while the stable contracts remain outcomes, constraints, evidence, autonomy, validation, permissions, and stop rules. See [model profiles](docs/model-profiles.md) for the distinction between design inputs, deterministic package checks, and live-model evidence.

This suite keeps the useful invariants—permission boundaries, project grounding, root-cause diagnosis, evidence before claims, preservation of user changes—and removes methodology ritual. It does not impose fail-first development, repeated broad suites, automatic worktrees, or per-task review chains. Each independently acceptable repository outcome receives an atomic local commit after focused evidence passes; approved Plans define those boundaries, while explicit opt-outs and unsafe or incomplete work remain uncommitted. Commit authority never implies push authority.

## Structure

| Skill | Use it for |
|---|---|
| `agentic-superpowers` | Two or more dependent development phases that need end-to-end coordination |
| `agentic-orchestrate-delivery` | Explicit standardized delivery from current-state discovery through acceptance and Git closure |
| `agentic-design-planning` | Consequential ambiguity in product, UX, architecture, interfaces, migrations, or scope |
| `agentic-writing-plans` | Approved Spec → ordered implementation Plans → execution handoff |
| `agentic-using-git-worktrees` | Explicit or justified worktree isolation that preserves existing user changes |
| `agentic-subagent-driven-development` | Implementation-ready plans with independently ownable outcomes under accountable controller ownership |
| `agentic-debugging` | Ambiguous, intermittent, environment-dependent, or multi-component failures |
| `agentic-verification` | Choosing proportionate evidence for material completion claims |
| `agentic-purpose-bound-rigor` | Requiring a concrete necessity case before adding hashes, gates, isolation, mocks, freezes, or repeated reviews |
| `agentic-delegation-review` | Genuinely independent parallel work or a focused independent review |
| `agentic-git-delivery` | Atomic completion commits plus authorized branches, worktrees, pushes, pull requests, merges, or cleanup |

All eleven are direct entry points. The orchestrated workflow is opt-in for explicit standardized delivery or long-running multi-module work; it does not force ordinary tasks through a fixed chain. The remaining execution-structure Skills may hand work to another focused Skill only at a real dependency boundary. Narrow trigger descriptions allow implicit routing without an always-on router, and explicit `$skill-name` invocation remains available.

## Prompt footprint

The comparison baseline is a local 14-Skill installation from `obra/superpowers` at commit `b55764852ac78870e65c6565fb585b6cd8b3c5c9`.

| Measure | Baseline | Version 0.8 | Reduction |
|---|---:|---:|---:|
| Workflow Skills | 14 | 11 | 21.4% |
| Total `SKILL.md` words | 15,737 | 5,404 | 65.7% |
| Always-trigger router | Yes | No | Removed |

A focused route loads one body of 233–850 words. The longest Skills carry concrete planning, orchestrated-delivery, worktree, or subagent contracts and load only when those structures materially help. The full 5,404-word package is never a mandatory prompt chain. Word count is a structural proxy, not a model-quality or tokenization guarantee.

## Install

### Full installation

Clone the repository and run the installer once:

```bash
git clone git@github.com:bells0/agentic-superpowers.git
cd agentic-superpowers
./scripts/install-local.sh
```

The full installer:

- installs all eleven Skills;
- adds a managed purpose-bound-rigor block to the effective global `~/.codex/AGENTS.md` or `AGENTS.override.md` without replacing existing guidance;
- installs `execution-efficiency-auditor` under `~/.codex/agents/`;
- removes only its managed guidance and Agent when `./scripts/restore-original.sh` restores the transaction.

Start a new Codex task after installation. Global `AGENTS.md` guidance is then loaded for every repository; the full Purpose-Bound Rigor Skill expands only when relevant, and the audit Agent remains available on demand.

### Skills-only installation

To install only the eleven Skills without global guidance or the custom Agent:

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo bells0/agentic-superpowers \
  --path \
    skills/agentic-superpowers \
    skills/agentic-orchestrate-delivery \
    skills/agentic-design-planning \
    skills/agentic-writing-plans \
    skills/agentic-using-git-worktrees \
    skills/agentic-subagent-driven-development \
    skills/agentic-debugging \
    skills/agentic-verification \
    skills/agentic-purpose-bound-rigor \
    skills/agentic-delegation-review \
    skills/agentic-git-delivery
```

### Upgrade from `gpt56-superpowers`

```bash
git clone git@github.com:bells0/agentic-superpowers.git
cd agentic-superpowers
./scripts/install-local.sh
```

The installer treats all eleven `gpt56-*` Skill IDs as legacy migration inputs. It moves them into a restorable transaction, replaces the old global guidance marker with the model-neutral marker, and installs only the eleven `agentic-*` Skill links. It does not leave discoverable aliases that would duplicate routing metadata. See [the migration guide](docs/migration-from-gpt56-superpowers.md).

The same installer also replaces an existing `obra/superpowers` installation. It validates the package, preserves legacy or conflicting Skill entries, and records the managed global runtime state. Restore the newest READY transaction with:

```bash
./scripts/restore-original.sh
```

You can also pass a specific backup directory. Existing `gpt56-superpowers` version-0.7, version-0.6, version-0.3, and version-0.1 backups remain restorable.

## Use

Implicit routing handles strong matches. Invoke a Skill explicitly when you want a specific lens:

```text
Use $agentic-debugging to diagnose this intermittent cross-service failure.

Use $agentic-orchestrate-delivery to run this long-running feature through controller-led discovery, planning, bounded execution, review, verification, acceptance, and closure.

Use $agentic-verification to choose proportionate evidence for this release claim.

Use $agentic-purpose-bound-rigor to decide whether these proposed gates and isolation steps are actually necessary.

Use $agentic-writing-plans to turn this approved Spec into ordered, repository-grounded implementation Plans and define the controller-owned execution handoff.

Use $agentic-superpowers to coordinate this migration end to end.

Use `docs/implementation-closed-loop.md` as a reusable template for long-running Spec → Plan → Execution workflows (including Plan A/B/C style handoffs and model-split recommendations).
```

Ordinary questions still use Codex directly. Completed repository outcomes implicitly add Git & Delivery for atomic local commits at verified boundaries; explicit `$skill-name` invocation remains available.

### Process auditor

The full installer makes the read-only `execution-efficiency-auditor` Agent available across repositories. Invoke it only when a user asks to audit process bloat or repeated execution drift; it is not a routine reviewer or implementation gate.

## Validation

The repository uses deterministic package checks, a fourteen-case routing specification, global-runtime tests, and install/restore transaction smoke tests. The scenarios constrain intended behavior; they are not a live model benchmark:

```bash
make validate
```

Run the canonical Codex Skill and plugin validators with:

```bash
make dev-deps
make local-codex-validate
```

See [architecture](docs/architecture.md), [model profiles](docs/model-profiles.md), [migration from `gpt56-superpowers`](docs/migration-from-gpt56-superpowers.md), [migration from `obra/superpowers`](docs/migration-from-obra-superpowers.md), and [evaluation](docs/evaluation.md).

## 中文说明

Agentic Superpowers 是一套不绑定具体模型版本的轻量开发 Skill：`1 个主控核心 + 1 个显式标准交付流程 + 9 个聚焦 Skill`。普通任务不加载，单领域任务只加载一个；长期多模块任务可以显式选择主控编排、独立审查、真实路径验证、用户验收和 Git 收口的完整闭环。

模型迭代记录在独立的 Model Profile 中，不进入仓库、插件或 Skill 的永久命名。升级安装会备份并移除旧的 `gpt56-*` 调用名，只暴露新的 `agentic-*`，同时保留旧事务的恢复能力。

本版本彻底移除了开发方法论强制，不要求先写失败测试、不要求 RED/GREEN/REFACTOR、不要求重复跑全量测试。保留的是更薄的“声明—证据”验证：文档看 diff/schema/link，Bug 复查原始症状，行为跑最相关检查，视觉实际渲染，发布遵守项目门禁；无法验证就明确缺口。

每个独立可验收、可独立回滚且验证通过的仓库结果，默认形成一个原子本地 commit；已批准的 Plan 定义提交边界，依赖任务必须在当前边界提交后再继续。拟议中的 Plan、只读、未完成、验证失败、无法安全隔离或明确要求不提交的工作不会自动提交。默认 commit 不代表允许自动 push。

## License and attribution

MIT. This is an original rewrite inspired by [obra/superpowers](https://github.com/obra/superpowers); see [third-party notices](THIRD_PARTY_NOTICES.md).
