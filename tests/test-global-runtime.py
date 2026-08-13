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


if __name__ == "__main__":
    unittest.main()
