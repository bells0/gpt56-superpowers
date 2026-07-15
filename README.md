# GPT-5.6 Superpowers

A lean, outcome-first replacement for the ceremony-heavy Superpowers workflow, designed for GPT-5.6 Sol and Codex.

It keeps the valuable invariants—permission boundaries, evidence before claims, root-cause debugging, preservation of user changes—and removes mandatory brainstorming, micro-plans, universal TDD, per-task review chains, automatic worktrees, and repeated full-suite verification.

The result is one explicitly invoked Skill with five references loaded only when they change a decision.

## Why this exists

[OpenAI's GPT-5.6 prompting guidance](https://developers.openai.com/api/docs/guides/prompt-guidance-gpt-5p6) recommends defining outcomes, constraints, evidence, autonomy, validation, and stop rules while removing repeated process instructions and examples. In OpenAI's directional internal sample, leaner prompts improved scores by about 10–15% while reducing tokens by 41–66% and cost by 33–67%. Those figures are not a promise for this project; evaluate it on your own representative tasks.

GPT-5.6 Superpowers applies that guidance to a development workflow:

- outcome contract instead of prescribed ceremony;
- low, medium, and high risk routes;
- explicit permission boundaries without repeated approval prompts;
- targeted evidence matched to each completion claim;
- dependency-aware tools and delegation;
- sparse phase updates and concrete stop rules.

## Measured prompt footprint

The baseline was a local 14-Skill installation from obra/superpowers at commit b55764852ac78870e65c6565fb585b6cd8b3c5c9.

| Measure | Baseline | This project | Reduction |
|---|---:|---:|---:|
| Discovered workflow Skills | 14 | 1 | 92.9% |
| Discoverable SKILL.md words | 15,737 | 775 | 95.1% |
| Always-trigger router | Yes | No | Removed |

The 775-word core is the normal loaded body. Conditional references total 1,476 words, so the maximum package is 2,251 words. For transparency, a high-risk authentication route that loads design, delegation, and testing is 1,735 words; adding Git delivery makes it 2,010. These are structural route footprints, not a same-task runtime benchmark. Word count is a proxy for prompt size, not a claim about tokenization or model quality.

## Install

### New installation

Codex's built-in GitHub Skill installer can copy the single Skill:

    python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
      --repo bells0/gpt56-superpowers \
      --path skills/gpt56-superpowers

Start a new Codex task after installation so Skill discovery refreshes.

### Replace an existing obra/superpowers installation

Clone the repository, then run the migration installer:

    git clone git@github.com:bells0/gpt56-superpowers.git
    cd gpt56-superpowers
    ./scripts/install-local.sh

The script validates the repository, rejects unsafe source/target ancestry, takes a shared transaction lock, moves the 14 legacy Skill directories to an exclusive backup outside the discovery root, verifies the new link, and marks the backup READY. It is idempotent and prints the backup path.

Restore the newest backup with:

    ./scripts/restore-original.sh

Or pass a specific READY backup directory as the first argument. Restore performs collision and manifest checks before mutation; empty installations can also be cleanly removed.

## Use

Implicit invocation is disabled to eliminate an always-on routing tax. Invoke it when you want the complete workflow:

    Use $gpt56-superpowers to implement this change end to end.

    Use $gpt56-superpowers to diagnose and fix this bug with proportionate validation.

Ordinary questions and small edits can use Codex directly.

## Architecture

The core Skill establishes:

1. goal, success criteria, constraints, evidence, permission, and stop conditions;
2. a low, medium, or high risk route;
3. the smallest coherent implementation and validation loop;
4. an outcome-first final report.

Five one-level references add detail only when needed:

- design-and-planning.md
- testing-and-verification.md
- debugging.md
- delegation-and-review.md
- git-and-delivery.md

See [architecture](docs/architecture.md), [migration mapping](docs/migration-from-obra-superpowers.md), and [evaluation](docs/evaluation.md).

## Validate

The repository deliberately avoids a large test ceremony. It uses deterministic checks for the artifact being distributed:

    make validate

This runs repository manifest and Skill validation, prompt-budget and legacy-rule checks, the six-scenario eval-manifest check, and isolated transaction/install/restore smoke tests. CI installs PyYAML so agents/openai.yaml is parsed as YAML.

For the canonical Codex validators on a machine with Codex installed:

    make dev-deps
    make local-codex-validate

## 中文说明

这是为 GPT-5.6 Sol 重写的一套轻量 Superpowers。核心变化不是把旧 Skill 缩短一点，而是删除强制串联：不再默认要求头脑风暴、逐步计划、worktree、TDD、每任务双重审查、全量测试和分支收尾。

本项目只保留一个显式调用的核心 Skill，按风险选择流程，五份参考资料按需加载。本地迁移脚本会先把旧 14 个 Skill 备份到 ~/.codex/skill-backups/gpt56-superpowers/，再建立符号链接；可以一键恢复。

设计目标是减少无意义 token、工具调用、等待和验证，同时保留权限、安全、证据与可回滚性。性能收益必须在你自己的真实任务上比较，仓库提供六个代表场景和统一指标。

## License and attribution

MIT. This is an original rewrite inspired by [obra/superpowers](https://github.com/obra/superpowers); see [third-party notices](THIRD_PARTY_NOTICES.md).
