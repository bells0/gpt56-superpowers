PYTHON ?= python3
CODEX_HOME ?= $(HOME)/.codex

.PHONY: validate static install-smoke global-runtime-smoke dev-deps local-codex-validate

validate: static global-runtime-smoke install-smoke

static:
	$(PYTHON) scripts/validate.py

install-smoke:
	bash tests/test-install.sh

global-runtime-smoke:
	$(PYTHON) tests/test-global-runtime.py

dev-deps:
	$(PYTHON) -m pip install -r requirements-dev.txt

local-codex-validate:
	@$(PYTHON) -c 'import yaml' >/dev/null 2>&1 || { echo "PyYAML is required; run make dev-deps" >&2; exit 1; }
	@for skill in skills/agentic-*; do \
		$(PYTHON) $(CODEX_HOME)/skills/.system/skill-creator/scripts/quick_validate.py "$$skill" || exit 1; \
	done
	$(PYTHON) $(CODEX_HOME)/skills/.system/plugin-creator/scripts/validate_plugin.py .
