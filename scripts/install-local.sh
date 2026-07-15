#!/usr/bin/env bash
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_ROOT="${SKILLS_ROOT:-$CODEX_HOME/skills}"
BACKUP_ROOT="${BACKUP_ROOT:-$CODEX_HOME/skill-backups/gpt56-superpowers}"
SOURCE_ROOT="$REPO_ROOT/skills"
LOCK_DIR="$SKILLS_ROOT/.gpt56-superpowers.lock"

MANAGED_SKILLS=(
  gpt56-superpowers
  gpt56-design-planning
  gpt56-debugging
  gpt56-verification
  gpt56-delegation-review
  gpt56-git-delivery
)

LEGACY_SKILLS=(
  brainstorming
  dispatching-parallel-agents
  executing-plans
  finishing-a-development-branch
  receiving-code-review
  requesting-code-review
  subagent-driven-development
  systematic-debugging
  test-driven-development
  using-git-worktrees
  using-superpowers
  verification-before-completion
  writing-plans
  writing-skills
)

exists() {
  [[ -e "$1" || -L "$1" ]]
}

exact_link() {
  [[ -L "$SKILLS_ROOT/$1" ]] && [[ "$(readlink "$SKILLS_ROOT/$1")" == "$SOURCE_ROOT/$1" ]]
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

for name in "${MANAGED_SKILLS[@]}"; do
  [[ -f "$SOURCE_ROOT/$name/SKILL.md" ]] || die "source Skill is missing: $SOURCE_ROOT/$name"
done

python3 - "$SOURCE_ROOT" "$SKILLS_ROOT" "$BACKUP_ROOT" "${MANAGED_SKILLS[@]}" -- "${LEGACY_SKILLS[@]}" <<'PY'
import os
import sys


def slot(path: str) -> str:
    parent, name = os.path.split(os.path.abspath(path))
    return os.path.join(os.path.realpath(parent), name)


def canonical_root(path: str) -> str:
    absolute = os.path.abspath(path)
    if os.path.lexists(absolute):
        return os.path.realpath(absolute)
    return slot(absolute)


def related(left: str, right: str) -> bool:
    try:
        common = os.path.commonpath((left, right))
    except ValueError:
        return False
    return common == left or common == right


source_root = os.path.realpath(sys.argv[1])
skills_root = canonical_root(sys.argv[2])
backup_root = canonical_root(sys.argv[3])
separator = sys.argv.index("--")
names = [*sys.argv[4:separator], *sys.argv[separator + 1:]]
move_slots = [slot(os.path.join(skills_root, name)) for name in names]
problems = []

for move_path in move_slots:
    if related(source_root, move_path):
        problems.append(f"source and movable path overlap: {source_root} <-> {move_path}")
    if related(backup_root, move_path):
        problems.append(f"backup and movable path overlap: {backup_root} <-> {move_path}")

if related(source_root, backup_root):
    problems.append(f"source and backup root overlap: {source_root} <-> {backup_root}")
if related(skills_root, backup_root):
    problems.append(f"Skills and backup roots overlap: {skills_root} <-> {backup_root}")

if problems:
    for problem in dict.fromkeys(problems):
        print(f"ERROR: {problem}", file=sys.stderr)
    raise SystemExit(1)
PY

python3 "$REPO_ROOT/scripts/validate.py"
mkdir -p "$SKILLS_ROOT" "$BACKUP_ROOT"
python3 - "$SKILLS_ROOT" "$BACKUP_ROOT" <<'PY'
import os
import sys

if os.stat(sys.argv[1]).st_dev != os.stat(sys.argv[2]).st_dev:
    print("ERROR: Skills and backup roots must be on the same filesystem", file=sys.stderr)
    raise SystemExit(1)
PY

BACKUP_DIR=""
moved_names=()
created_names=()
preserved_names=()
committed=0
lock_held=0

release_lock() {
  if [[ "$lock_held" -eq 1 ]]; then
    rm -f "$LOCK_DIR/owner" || echo "WARNING: could not remove lock owner file" >&2
    rmdir "$LOCK_DIR" 2>/dev/null || echo "WARNING: could not release lock: $LOCK_DIR" >&2
    lock_held=0
  fi
  return 0
}

rollback() {
  set +e
  rollback_error=0

  for ((index=${#created_names[@]} - 1; index >= 0; index--)); do
    name="${created_names[$index]}"
    if exact_link "$name"; then
      rm "$SKILLS_ROOT/$name" || rollback_error=1
    elif exists "$SKILLS_ROOT/$name"; then
      echo "WARNING: rollback preserved changed target: $SKILLS_ROOT/$name" >&2
      rollback_error=1
    fi
  done

  for ((index=${#moved_names[@]} - 1; index >= 0; index--)); do
    name="${moved_names[$index]}"
    if exists "$BACKUP_DIR/$name" && ! exists "$SKILLS_ROOT/$name"; then
      mv "$BACKUP_DIR/$name" "$SKILLS_ROOT/$name" || rollback_error=1
    elif exists "$BACKUP_DIR/$name"; then
      echo "WARNING: rollback collision left $name in $BACKUP_DIR" >&2
      rollback_error=1
    fi
  done

  if [[ -n "$BACKUP_DIR" && "$rollback_error" -eq 0 ]]; then
    rm -f "$BACKUP_DIR/INSTALL_INFO" "$BACKUP_DIR/INSTALL_INFO.tmp" \
      "$BACKUP_DIR/READY" "$BACKUP_DIR/READY.tmp"
    rmdir "$BACKUP_DIR" 2>/dev/null || true
  fi

  if [[ "$rollback_error" -eq 1 ]]; then
    echo "WARNING: rollback was incomplete; inspect $BACKUP_DIR" >&2
  fi
  return 0
}

on_exit() {
  status=$?
  trap - EXIT
  if [[ "$committed" -eq 0 ]]; then
    rollback
  fi
  release_lock
  exit "$status"
}

if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  die "another install or restore is active; inspect lock $LOCK_DIR"
fi
lock_held=1
trap on_exit EXIT
printf '%s\n' "$$" > "$LOCK_DIR/owner"

all_installed=1
for name in "${MANAGED_SKILLS[@]}"; do
  if ! exact_link "$name" || [[ ! -f "$SKILLS_ROOT/$name/SKILL.md" ]]; then
    all_installed=0
    break
  fi
done

legacy_found=0
for name in "${LEGACY_SKILLS[@]}"; do
  if exists "$SKILLS_ROOT/$name"; then
    legacy_found=1
    break
  fi
done

if [[ "$all_installed" -eq 1 && "$legacy_found" -eq 0 ]]; then
  committed=1
  release_lock
  trap - EXIT
  echo "Already installed: six GPT-5.6 Skills"
  exit 0
fi

BACKUP_DIR="$(python3 - "$BACKUP_ROOT" <<'PY'
import pathlib
import sys

root = pathlib.Path(sys.argv[1])
sequences = []
for path in root.glob("txn-*"):
    suffix = path.name[4:]
    if suffix.isdigit():
        sequences.append(int(suffix))
candidate = root / f"txn-{max(sequences, default=0) + 1:020d}"
candidate.mkdir()
print(candidate)
PY
)"

for name in "${LEGACY_SKILLS[@]}"; do
  if exists "$SKILLS_ROOT/$name"; then
    mv "$SKILLS_ROOT/$name" "$BACKUP_DIR/$name"
    moved_names+=("$name")
  fi
done

for name in "${MANAGED_SKILLS[@]}"; do
  if exact_link "$name"; then
    preserved_names+=("$name")
    continue
  fi
  if exists "$SKILLS_ROOT/$name"; then
    mv "$SKILLS_ROOT/$name" "$BACKUP_DIR/$name"
    moved_names+=("$name")
  fi
  ln -s "$SOURCE_ROOT/$name" "$SKILLS_ROOT/$name"
  created_names+=("$name")
done

for name in "${MANAGED_SKILLS[@]}"; do
  exact_link "$name" || die "post-install link verification failed: $SKILLS_ROOT/$name"
  [[ -f "$SKILLS_ROOT/$name/SKILL.md" ]] || die "post-install Skill verification failed: $name"
done

timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
{
  printf 'format_version=2\n'
  printf 'source_root=%s\n' "$SOURCE_ROOT"
  printf 'skills_root=%s\n' "$SKILLS_ROOT"
  printf 'installed_at=%s\n' "$timestamp"
  for name in "${MANAGED_SKILLS[@]}"; do printf 'managed=%s\n' "$name"; done
  for name in "${preserved_names[@]}"; do printf 'preserved=%s\n' "$name"; done
  for name in "${created_names[@]}"; do printf 'created=%s\n' "$name"; done
  for name in "${moved_names[@]}"; do printf 'moved=%s\n' "$name"; done
  printf 'state=READY\n'
} > "$BACKUP_DIR/INSTALL_INFO.tmp"
mv "$BACKUP_DIR/INSTALL_INFO.tmp" "$BACKUP_DIR/INSTALL_INFO"
printf '%s\n' "READY" > "$BACKUP_DIR/READY.tmp"
mv "$BACKUP_DIR/READY.tmp" "$BACKUP_DIR/READY"

committed=1
release_lock
trap - EXIT

echo "Installed six GPT-5.6 Skills from: $SOURCE_ROOT"
echo "Backup: $BACKUP_DIR"
echo "Restart Codex or start a new task to refresh Skill discovery."
