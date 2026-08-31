#!/usr/bin/env python3
from __future__ import annotations

import importlib.util
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
HELPER = ROOT / "scripts" / "manage-global-runtime.py"
SPEC = importlib.util.spec_from_file_location("manage_global_runtime", HELPER)
assert SPEC and SPEC.loader
RUNTIME = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(RUNTIME)


class GlobalRuntimeTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary.name)
        self.codex_home = self.root / "codex-home"
        self.agent = ROOT / ".codex" / "agents" / "execution-efficiency-auditor.toml"
        self.fragment = ROOT / ".codex" / "purpose-bound-rigor.md"
        self.receipt = self.root / "receipt.json"

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def test_install_status_and_restore_preserve_existing_guidance(self) -> None:
        self.codex_home.mkdir()
        guidance = self.codex_home / "AGENTS.md"
        guidance.write_text("# Personal rules\n\n- Keep this.\n", encoding="utf-8")

        RUNTIME.install(self.codex_home, self.agent, self.fragment, self.receipt)

        self.assertTrue(RUNTIME.status(self.codex_home, self.agent, self.fragment))
        self.assertIn("# Personal rules", guidance.read_text(encoding="utf-8"))
        self.assertIn(RUNTIME.START, guidance.read_text(encoding="utf-8"))
        self.assertEqual(
            (self.codex_home / "agents" / RUNTIME.AGENT_NAME).read_text(encoding="utf-8"),
            self.agent.read_text(encoding="utf-8"),
        )

        RUNTIME.restore(self.receipt)

        self.assertEqual(guidance.read_text(encoding="utf-8"), "# Personal rules\n\n- Keep this.\n")
        self.assertFalse((self.codex_home / "agents" / RUNTIME.AGENT_NAME).exists())

    def test_nonempty_override_is_the_effective_global_target(self) -> None:
        self.codex_home.mkdir()
        override = self.codex_home / "AGENTS.override.md"
        override.write_text("# Override\n", encoding="utf-8")

        RUNTIME.install(self.codex_home, self.agent, self.fragment, self.receipt)

        self.assertIn(RUNTIME.START, override.read_text(encoding="utf-8"))
        self.assertFalse((self.codex_home / "AGENTS.md").exists())

    def test_unmanaged_agent_is_not_replaced(self) -> None:
        target = self.codex_home / "agents" / RUNTIME.AGENT_NAME
        target.parent.mkdir(parents=True)
        target.write_text('name = "personal"\n', encoding="utf-8")

        with self.assertRaisesRegex(ValueError, "unmanaged custom agent"):
            RUNTIME.install(self.codex_home, self.agent, self.fragment, self.receipt)

        self.assertEqual(target.read_text(encoding="utf-8"), 'name = "personal"\n')
        self.assertFalse((self.codex_home / "AGENTS.md").exists())

    def test_legacy_runtime_is_migrated_and_restored_exactly(self) -> None:
        self.codex_home.mkdir()
        guidance = self.codex_home / "AGENTS.md"
        legacy_block = (
            f"{RUNTIME.LEGACY_START}\n"
            "- Keep the old managed rule.\n"
            f"{RUNTIME.LEGACY_END}"
        )
        original_guidance = f"# Personal rules\n\n{legacy_block}\n"
        guidance.write_text(original_guidance, encoding="utf-8")
        agent_target = self.codex_home / "agents" / RUNTIME.AGENT_NAME
        agent_target.parent.mkdir(parents=True)
        original_agent = '# managed-by: gpt56-superpowers\nname = "legacy-auditor"\n'
        agent_target.write_text(original_agent, encoding="utf-8")

        RUNTIME.install(self.codex_home, self.agent, self.fragment, self.receipt)

        migrated = guidance.read_text(encoding="utf-8")
        self.assertIn(RUNTIME.START, migrated)
        self.assertNotIn(RUNTIME.LEGACY_START, migrated)
        self.assertEqual(agent_target.read_text(encoding="utf-8"), self.agent.read_text(encoding="utf-8"))

        RUNTIME.restore(self.receipt)

        self.assertEqual(guidance.read_text(encoding="utf-8"), original_guidance)
        self.assertEqual(agent_target.read_text(encoding="utf-8"), original_agent)

    def test_multiple_current_and_legacy_blocks_are_rejected(self) -> None:
        self.codex_home.mkdir()
        guidance = self.codex_home / "AGENTS.md"
        guidance.write_text(
            f"{RUNTIME.START}\nnew\n{RUNTIME.END}\n\n"
            f"{RUNTIME.LEGACY_START}\nold\n{RUNTIME.LEGACY_END}\n",
            encoding="utf-8",
        )

        with self.assertRaisesRegex(ValueError, "multiple Agentic Superpowers blocks"):
            RUNTIME.install(self.codex_home, self.agent, self.fragment, self.receipt)


if __name__ == "__main__":
    unittest.main()
