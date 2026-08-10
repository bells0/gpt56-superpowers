#!/usr/bin/env python3
"""Deterministic package checks for the GPT-5.6 Superpowers suite."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

try:
    import yaml
except ModuleNotFoundError:
    yaml = None


ROOT = Path(__file__).resolve().parents[1]
SKILLS_ROOT = ROOT / "skills"
SKILL_NAMES = (
    "gpt56-superpowers",
    "gpt56-design-planning",
    "gpt56-writing-plans",
    "gpt56-using-git-worktrees",
    "gpt56-subagent-driven-development",
    "gpt56-debugging",
    "gpt56-verification",
    "gpt56-delegation-review",
    "gpt56-git-delivery",
)
SKILL_WORD_LIMITS = {
    "gpt56-superpowers": 600,
    "gpt56-design-planning": 300,
    "gpt56-writing-plans": 850,
    "gpt56-using-git-worktrees": 600,
    "gpt56-subagent-driven-development": 750,
    "gpt56-debugging": 300,
    "gpt56-verification": 300,
    "gpt56-delegation-review": 450,
    "gpt56-git-delivery": 300,
}
PACKAGE_WORD_LIMIT = 4300
ALLOWED_RESOURCE_DIRS = {
    "gpt56-subagent-driven-development": {"references", "scripts"},
}
failures: list[str] = []


def check(condition: bool, message: str) -> None:
    if not condition:
        failures.append(message)


def words(text: str) -> int:
    return len(text.split())


def load_json(path: Path) -> object:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        failures.append(f"{path.relative_to(ROOT)} is not valid JSON: {exc}")
        return {}


manifest = load_json(ROOT / ".codex-plugin" / "plugin.json")
if isinstance(manifest, dict):
    check(manifest.get("name") == "gpt56-superpowers", "plugin name must match the repository")
    check(
        isinstance(manifest.get("version"), str)
        and re.fullmatch(r"\d+\.\d+\.\d+", manifest["version"]) is not None,
        "plugin version must use strict semver",
    )
    check(manifest.get("skills") == "./skills/", "plugin skills path must be ./skills/")
    check(manifest.get("license") == "MIT", "plugin license must be MIT")
    author = manifest.get("author")
    check(isinstance(author, dict) and bool(author.get("name")), "plugin author.name is required")
    interface = manifest.get("interface")
    required_interface = {
        "displayName",
        "shortDescription",
        "longDescription",
        "developerName",
        "category",
        "capabilities",
        "defaultPrompt",
    }
    check(
        isinstance(interface, dict) and required_interface.issubset(interface),
        "plugin interface is missing required fields",
    )

actual_skill_dirs = {
    path.name for path in SKILLS_ROOT.iterdir() if path.is_dir() and not path.name.startswith(".")
}
check(actual_skill_dirs == set(SKILL_NAMES), "skills/ must contain exactly the nine supported Skills")

word_counts: dict[str, int] = {}
skill_corpus: list[str] = []
for name in SKILL_NAMES:
    skill_dir = SKILLS_ROOT / name
    skill_path = skill_dir / "SKILL.md"
    config_path = skill_dir / "agents" / "openai.yaml"
    check(skill_path.is_file(), f"missing {name}/SKILL.md")
    check(config_path.is_file(), f"missing {name}/agents/openai.yaml")
    if not skill_path.is_file() or not config_path.is_file():
        continue

    skill_text = skill_path.read_text(encoding="utf-8")
    skill_corpus.append(skill_text.lower())
    frontmatter = re.match(r"\A---\n(.*?)\n---\n", skill_text, flags=re.DOTALL)
    check(frontmatter is not None, f"{name}/SKILL.md must start with YAML frontmatter")
    if frontmatter:
        header = frontmatter.group(1)
        check(
            re.search(rf"^name: {re.escape(name)}$", header, flags=re.MULTILINE) is not None,
            f"{name} frontmatter name is invalid",
        )
        description = re.search(r"^description: (.+)$", header, flags=re.MULTILINE)
        check(description is not None and len(description.group(1)) >= 80, f"{name} needs a specific trigger description")

    config_text = config_path.read_text(encoding="utf-8")
    check(f"${name}" in config_text, f"{name} default prompt must explicitly invoke the Skill")
    check("allow_implicit_invocation: true" in config_text, f"{name} must allow narrow implicit routing")
    if yaml is not None:
        try:
            config = yaml.safe_load(config_text)
            check(isinstance(config, dict), f"{name}/agents/openai.yaml must contain a mapping")
            check(
                config.get("policy", {}).get("allow_implicit_invocation") is True,
                f"{name} implicit invocation policy must parse as true",
            )
        except yaml.YAMLError as exc:
            failures.append(f"{name}/agents/openai.yaml is not valid YAML: {exc}")

    extra_dirs = {
        path.name
        for path in skill_dir.iterdir()
        if path.is_dir()
        and path.name != "agents"
        and path.name not in ALLOWED_RESOURCE_DIRS.get(name, set())
    }
    check(not extra_dirs, f"{name} contains unnecessary resource directories: {sorted(extra_dirs)}")
    check("$gpt56-" not in skill_text, f"{name} body must not require another sibling Skill")
    word_counts[name] = words(skill_text)

for name, limit in SKILL_WORD_LIMITS.items():
    check(word_counts.get(name, 0) <= limit, f"{name} prompt budget exceeded")
package_words = sum(word_counts.values())
check(package_words <= PACKAGE_WORD_LIMIT, f"package prompt budget exceeded: {package_words} > {PACKAGE_WORD_LIMIT}")

sdd_root = SKILLS_ROOT / "gpt56-subagent-driven-development"
for relative in (
    "references/implementer-prompt.md",
    "references/reviewer-prompt.md",
    "scripts/sdd-tools.cjs",
):
    check((sdd_root / relative).is_file(), f"missing gpt56-subagent-driven-development/{relative}")

writing_plan_path = SKILLS_ROOT / "gpt56-writing-plans" / "SKILL.md"
writing_plan_text = writing_plan_path.read_text(encoding="utf-8") if writing_plan_path.is_file() else ""
for heading in ("## Delivery Contract", "## Define the delivery contract"):
    check(heading in writing_plan_text, f"gpt56-writing-plans is missing stable heading: {heading}")
delivery_patterns = {
    "cross-task closure outside numbered tasks": r"cross-task.{0,80}(?:closure|completion).{0,100}outside.{0,40}(?:numbered )?task",
    "last numbered task is a product result": r"final numbered task.{0,80}(?:acceptance-ready|product result)",
    "controller owns post-integration delivery": r"controller.{0,120}(?:after|following).{0,80}integration",
    "child commit precedes parent pointer": r"child repositor(?:y|ies).{0,80}(?:precede|before).{0,80}parent.{0,40}(?:gitlink|pointer)",
    "acceptance gate and explicit opt-out": r"acceptance gate.{0,180}explicit(?:ly)? opt(?:ed)?-out|explicit opt-out.{0,180}acceptance gate",
    "completion record and local-only boundary": r"verification.{0,40}commit hashes.{0,80}dirty state.{0,120}local commits only",
}
for label, pattern in delivery_patterns.items():
    check(
        re.search(pattern, writing_plan_text, flags=re.IGNORECASE | re.DOTALL) is not None,
        f"gpt56-writing-plans delivery contract is missing {label}",
    )

implementer_path = sdd_root / "references" / "implementer-prompt.md"
implementer_prompt = implementer_path.read_text(encoding="utf-8") if implementer_path.is_file() else ""
check(
    re.search(r"worker rule.{0,80}not a global delivery\s+opt-out", implementer_prompt, re.DOTALL) is not None
    and re.search(r"controller.{0,80}gpt56-git-delivery.{0,80}completion commit", implementer_prompt, re.DOTALL)
    is not None,
    "implementer prompt must preserve controller-owned completion delivery",
)

corpus = "\n".join(skill_corpus)
obsolete_patterns = {
    "forced methodology acronym": r"(?:always|mandatory|must|required).{0,20}\btdd\b|\btdd\b.{0,20}(?:always|mandatory|required)",
    "fail-first ritual": r"fail[- ]first",
    "forced test-first ritual": r"(?:always|mandatory|must).{0,20}test[- ]first|test[- ]first.{0,20}(?:always|mandatory|required)",
    "red-green-refactor ritual": r"red.{0,12}green.{0,12}refactor",
    "mandatory full suite": r"mandatory full[- ]suite|always run (?:the )?full suite",
    "forced restart": r"delete (?:the )?(?:implementation|code).{0,20}start over",
}
for label, pattern in obsolete_patterns.items():
    check(re.search(pattern, corpus, flags=re.IGNORECASE | re.DOTALL) is None, f"obsolete {label} reintroduced")

for markdown in ROOT.rglob("*.md"):
    if ".git" in markdown.parts:
        continue
    text = markdown.read_text(encoding="utf-8")
    check("[TODO:" not in text and "\nTODO" not in text, f"placeholder remains in {markdown.relative_to(ROOT)}")
    for target in re.findall(r"\[[^\]]+\]\(([^)]+)\)", text):
        if target.startswith(("http://", "https://", "#", "mailto:")):
            continue
        clean = target.split("#", 1)[0]
        if clean:
            check((markdown.parent / clean).resolve().exists(), f"broken link in {markdown.relative_to(ROOT)}: {target}")

scenarios = load_json(ROOT / "tests" / "scenarios.json")
expected_ids = {
    "ordinary-readonly",
    "clear-static-edit",
    "material-design",
    "ambiguous-failure",
    "claim-evidence",
    "parallel-review",
    "git-delivery",
    "multi-phase",
    "explicit-no-commit",
    "implementation-plan",
    "worktree-isolation",
    "subagent-plan-execution",
}
if isinstance(scenarios, list):
    ids = {item.get("id") for item in scenarios if isinstance(item, dict)}
    check(ids == expected_ids, "scenario manifest must contain the twelve canonical cases")
    routed = set()
    for item in scenarios:
        if not isinstance(item, dict):
            failures.append("scenario entries must be objects")
            continue
        expected = item.get("expected")
        check(
            isinstance(expected, dict)
            and {"skills", "approval", "local_commit", "evidence"}.issubset(expected),
            f"scenario {item.get('id')} is missing expected fields",
        )
        if not isinstance(expected, dict):
            continue
        skills = expected.get("skills")
        check(isinstance(skills, list), f"scenario {item.get('id')} skills must be a list")
        if isinstance(skills, list):
            check(set(skills).issubset(SKILL_NAMES), f"scenario {item.get('id')} names an unknown Skill")
            check(len(skills) <= 3, f"scenario {item.get('id')} routes too many Skills")
            routed.update(skills)
        check(isinstance(expected.get("approval"), bool), f"scenario {item.get('id')} approval must be boolean")
        check(
            isinstance(expected.get("local_commit"), bool),
            f"scenario {item.get('id')} local_commit must be boolean",
        )
        check(bool(expected.get("evidence")), f"scenario {item.get('id')} needs decisive evidence")
    check(routed == set(SKILL_NAMES), "scenario manifest must exercise every Skill")

if failures:
    for failure in failures:
        print(f"FAIL: {failure}", file=sys.stderr)
    raise SystemExit(1)

print("PASS: plugin and nine-Skill structure")
print(
    "PASS: skill budgets "
    + ", ".join(f"{name}={word_counts[name]}/{SKILL_WORD_LIMITS[name]}" for name in SKILL_NAMES)
)
print(f"PASS: package budget {package_words}/{PACKAGE_WORD_LIMIT} words")
print("PASS: dependency-aware routing, lean workflow rules, links, resources, and 12 scenarios")
