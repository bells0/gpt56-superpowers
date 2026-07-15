#!/usr/bin/env python3
"""Deterministic repository checks for the GPT-5.6 Superpowers artifact."""

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
SKILL = ROOT / "skills" / "gpt56-superpowers"
CORE = SKILL / "SKILL.md"
REFERENCES = (
    "debugging.md",
    "delegation-and-review.md",
    "design-and-planning.md",
    "git-and-delivery.md",
    "testing-and-verification.md",
)
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

core_text = CORE.read_text(encoding="utf-8")
frontmatter = re.match(r"\A---\n(.*?)\n---\n", core_text, flags=re.DOTALL)
check(frontmatter is not None, "SKILL.md must start with YAML frontmatter")
if frontmatter:
    header = frontmatter.group(1)
    check(re.search(r"^name: gpt56-superpowers$", header, flags=re.MULTILINE) is not None, "Skill name is invalid")
    description = re.search(r"^description: (.+)$", header, flags=re.MULTILINE)
    check(description is not None and description.group(1).startswith("Use when "), "Skill description must start with 'Use when '")

openai_yaml = (SKILL / "agents" / "openai.yaml").read_text(encoding="utf-8")
check('allow_implicit_invocation: false' in openai_yaml, "implicit invocation must remain disabled")
check("$gpt56-superpowers" in openai_yaml, "default prompt must explicitly invoke the Skill")
if yaml is not None:
    try:
        openai_config = yaml.safe_load(openai_yaml)
        check(isinstance(openai_config, dict), "agents/openai.yaml must contain a mapping")
        check(
            openai_config.get("policy", {}).get("allow_implicit_invocation") is False,
            "agents/openai.yaml policy must parse as false",
        )
    except yaml.YAMLError as exc:
        failures.append(f"agents/openai.yaml is not valid YAML: {exc}")

for reference in REFERENCES:
    path = SKILL / "references" / reference
    check(path.is_file(), f"missing reference: {reference}")
    check(f"references/{reference}" in core_text, f"core does not route to {reference}")

core_words = words(core_text)
package_words = sum(words(path.read_text(encoding="utf-8")) for path in SKILL.rglob("*.md"))
check(core_words <= 900, f"core budget exceeded: {core_words} > 900 words")
check(package_words <= 2500, f"package budget exceeded: {package_words} > 2500 words")

legacy_rules = (
    "even a 1% chance",
    "no production code",
    "delete it and start over",
    "every project must",
    "two-stage review",
    "fresh full command",
)
skill_corpus = "\n".join(path.read_text(encoding="utf-8").lower() for path in SKILL.rglob("*.md"))
for phrase in legacy_rules:
    check(phrase not in skill_corpus, f"legacy absolute rule reintroduced: {phrase}")

for markdown in ROOT.rglob("*.md"):
    if ".git" in markdown.parts:
        continue
    text = markdown.read_text(encoding="utf-8")
    check("[TODO:" not in text and "\nTODO" not in text, f"placeholder remains in {markdown.relative_to(ROOT)}")
    for target in re.findall(r"\[[^\]]+\]\(([^)]+)\)", text):
        if target.startswith(("http://", "https://", "#", "mailto:")):
            continue
        clean = target.split("#", 1)[0]
        if not clean:
            continue
        check((markdown.parent / clean).resolve().exists(), f"broken link in {markdown.relative_to(ROOT)}: {target}")

scenarios = load_json(ROOT / "tests" / "scenarios.json")
expected_ids = {
    "ordinary-readonly",
    "skill-text-edit",
    "local-config",
    "ordinary-bug",
    "auth-change",
    "destructive-git",
}
if isinstance(scenarios, list):
    ids = {item.get("id") for item in scenarios if isinstance(item, dict)}
    check(ids == expected_ids, "scenario manifest must contain the six canonical cases")
    risks = {item.get("expected", {}).get("risk") for item in scenarios if isinstance(item, dict)}
    check({"none", "low", "medium", "high", "permission"}.issubset(risks), "scenario manifest must cover all routes")
    for item in scenarios:
        if not isinstance(item, dict):
            failures.append("scenario entries must be objects")
            continue
        expected = item.get("expected")
        check(
            isinstance(expected, dict)
            and {"invoke", "risk", "approval", "references", "validation"}.issubset(expected),
            f"scenario {item.get('id')} is missing expected fields",
        )

if failures:
    for failure in failures:
        print(f"FAIL: {failure}", file=sys.stderr)
    raise SystemExit(1)

print(f"PASS: plugin and Skill structure")
print(f"PASS: core budget {core_words}/900 words")
print(f"PASS: package budget {package_words}/2500 words")
print(f"PASS: {len(REFERENCES)} conditional references and 6 eval scenarios")
