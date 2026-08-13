#!/usr/bin/env python3
"""Install or restore GPT-5.6 global guidance and the optional audit agent."""

from __future__ import annotations

import argparse
import json
import os
import shutil
import tempfile
from pathlib import Path


START = "<!-- gpt56-superpowers:purpose-bound-rigor:start -->"
END = "<!-- gpt56-superpowers:purpose-bound-rigor:end -->"
AGENT_NAME = "execution-efficiency-auditor.toml"


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def write_atomic(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(
        "w", encoding="utf-8", newline="\n", dir=path.parent, delete=False
    ) as handle:
        handle.write(text)
        temporary = Path(handle.name)
    os.replace(temporary, path)


def managed_block(fragment: Path) -> str:
    return f"{START}\n{read(fragment).strip()}\n{END}"


def find_block(text: str) -> tuple[int, int, str] | None:
    start = text.find(START)
    end = text.find(END)
    if start < 0 and end < 0:
        return None
    if start < 0 or end < start or text.find(START, start + 1) >= 0 or text.find(END, end + 1) >= 0:
        raise ValueError("global AGENTS guidance contains malformed gpt56-superpowers markers")
    finish = end + len(END)
    return start, finish, text[start:finish]


def guidance_target(codex_home: Path) -> Path:
    override = codex_home / "AGENTS.override.md"
    if override.is_file() and read(override).strip():
        return override
    return codex_home / "AGENTS.md"


def status(codex_home: Path, source_agent: Path, fragment: Path) -> bool:
    target = guidance_target(codex_home)
    if not target.is_file():
        return False
    block = find_block(read(target))
    agent = codex_home / "agents" / AGENT_NAME
    return bool(block and block[2] == managed_block(fragment) and agent.is_file() and read(agent) == read(source_agent))


def install(codex_home: Path, source_agent: Path, fragment: Path, receipt: Path) -> None:
    codex_home.mkdir(parents=True, exist_ok=True)
    target = guidance_target(codex_home)
    original_text = read(target) if target.is_file() else ""
    found = find_block(original_text)
    new_block = managed_block(fragment)
    if found:
        start, finish, previous_block = found
        updated_text = original_text[:start] + new_block + original_text[finish:]
    else:
        previous_block = None
        separator = "\n\n" if original_text.strip() else ""
        updated_text = original_text.rstrip() + separator + new_block + "\n"

    agent_target = codex_home / "agents" / AGENT_NAME
    previous_agent = read(agent_target) if agent_target.is_file() else None
    if previous_agent is not None and "# managed-by: gpt56-superpowers" not in previous_agent:
        raise ValueError(f"refusing to replace unmanaged custom agent: {agent_target}")

    receipt.parent.mkdir(parents=True, exist_ok=True)
    receipt_data = {
        "version": 1,
        "guidance_target": str(target),
        "guidance_file_existed": target.is_file(),
        "previous_block": previous_block,
        "installed_block": new_block,
        "agent_target": str(agent_target),
        "previous_agent": previous_agent,
        "installed_agent": read(source_agent),
    }
    write_atomic(receipt, json.dumps(receipt_data, ensure_ascii=False, indent=2) + "\n")

    try:
        write_atomic(target, updated_text)
        agent_target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source_agent, agent_target)
    except Exception:
        restore(receipt)
        receipt.unlink(missing_ok=True)
        raise


def restore(receipt: Path) -> None:
    if not receipt.is_file():
        return
    data = json.loads(read(receipt))
    target = Path(data["guidance_target"])
    agent = Path(data["agent_target"])

    found = None
    if target.is_file():
        current = read(target)
        found = find_block(current)
        if not found or found[2] != data["installed_block"]:
            raise ValueError(f"managed guidance changed after installation: {target}")

    if agent.is_file() and read(agent) != data["installed_agent"]:
        raise ValueError(f"managed custom agent changed after installation: {agent}")

    if target.is_file() and found:
        current = read(target)
        replacement = data["previous_block"] or ""
        updated = (current[: found[0]] + replacement + current[found[1] :]).strip()
        if updated:
            write_atomic(target, updated + "\n")
        elif data["guidance_file_existed"]:
            write_atomic(target, "")
        else:
            target.unlink()

    if agent.is_file():
        previous = data["previous_agent"]
        if previous is None:
            agent.unlink()
        else:
            write_atomic(agent, previous)


def main() -> None:
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command", required=True)
    for command in ("status", "install"):
        item = subparsers.add_parser(command)
        item.add_argument("--codex-home", type=Path, required=True)
        item.add_argument("--source-agent", type=Path, required=True)
        item.add_argument("--fragment", type=Path, required=True)
        if command == "install":
            item.add_argument("--receipt", type=Path, required=True)
    restore_parser = subparsers.add_parser("restore")
    restore_parser.add_argument("--receipt", type=Path, required=True)
    args = parser.parse_args()

    if args.command == "status":
        raise SystemExit(0 if status(args.codex_home, args.source_agent, args.fragment) else 1)
    if args.command == "install":
        install(args.codex_home, args.source_agent, args.fragment, args.receipt)
        return
    restore(args.receipt)


if __name__ == "__main__":
    main()
