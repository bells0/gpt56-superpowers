#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_ROOT="${SKILLS_ROOT:-$CODEX_HOME/skills}"
BACKUP_ROOT="${BACKUP_ROOT:-$CODEX_HOME/skill-backups/gpt56-superpowers}"
SOURCE="$REPO_ROOT/skills/gpt56-superpowers"
TARGET="$SKILLS_ROOT/gpt56-superpowers"
LOCK_DIR="$SKILLS_ROOT/.gpt56-superpowers.lock"

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

die() {
  echo "ERROR: $*" >&2
  exit 1
}

[[ -f "$SOURCE/SKILL.md" ]] || die "source Skill is missing: $SOURCE"

python3 - "$SOURCE" "$TARGET" "$SKILLS_ROOT" "$BACKUP_ROOT" "${LEGACY_SKILLS[@]}" <<'PY'
import os
import sys


def slot(path: str) -> str:
    parent, name = os.path.split(os.path.abspath(path))
    return os.path.join(os.path.realpath(parent), name)


def related(left: str, right: str) -> bool:
    try:
        common = os.path.commonpath((left, right))
    except ValueError:
        return False
    return common == left or common == right


source = os.path.realpath(sys.argv[1])
target = slot(sys.argv[2])
skills_root = slot(sys.argv[3])
backup_root = slot(sys.argv[4])
move_slots = [target, *[slot(os.path.join(sys.argv[3], name)) for name in sys.argv[5:]]]
problems = []

for move_path in move_slots:
    if related(source, move_path):
        problems.append(f"source and movable path overlap: {source} <-> {move_path}")
    if related(backup_root, move_path):
        problems.append(f"backup and movable path overlap: {backup_root} <-> {move_path}")

if related(source, backup_root):
    problems.append(f"source and backup root overlap: {source} <-> {backup_root}")
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
moved_count=0
target_created=0
committed=0
lock_held=0

release_lock() {
  if [[ "$lock_held" -eq 1 ]]; then
    if ! rm -f "$LOCK_DIR/owner"; then
      echo "WARNING: could not remove lock owner file: $LOCK_DIR/owner" >&2
    fi
    if ! rmdir "$LOCK_DIR" 2>/dev/null; then
      echo "WARNING: could not release lock: $LOCK_DIR" >&2
    fi
    lock_held=0
  fi
  return 0
}

rollback() {
  set +e
  set +u
  rollback_error=0

  if [[ "$target_created" -eq 1 ]] && [[ -L "$TARGET" ]] && [[ "$(readlink "$TARGET")" == "$SOURCE" ]]; then
    if ! rm "$TARGET"; then
      echo "WARNING: rollback could not remove $TARGET" >&2
      rollback_error=1
    fi
  fi

  for ((index=${#moved_names[@]} - 1; index >= 0; index--)); do
    name="${moved_names[$index]}"
    if exists "$BACKUP_DIR/$name" && ! exists "$SKILLS_ROOT/$name"; then
      if ! mv "$BACKUP_DIR/$name" "$SKILLS_ROOT/$name"; then
        echo "WARNING: rollback could not restore $name from $BACKUP_DIR" >&2
        rollback_error=1
      fi
    elif exists "$BACKUP_DIR/$name"; then
      echo "WARNING: rollback collision left $name in $BACKUP_DIR" >&2
      rollback_error=1
    fi
  done

  if [[ -n "$BACKUP_DIR" ]]; then
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

legacy_found=0
for name in "${LEGACY_SKILLS[@]}"; do
  if exists "$SKILLS_ROOT/$name"; then
    legacy_found=1
    break
  fi
done

if [[ -L "$TARGET" ]] && [[ "$(readlink "$TARGET")" == "$SOURCE" ]] && [[ "$legacy_found" -eq 0 ]]; then
  committed=1
  release_lock
  trap - EXIT
  echo "Already installed: $TARGET -> $SOURCE"
  exit 0
fi

target_preexisting=0
if [[ -L "$TARGET" ]] && [[ "$(readlink "$TARGET")" == "$SOURCE" ]]; then
  target_preexisting=1
fi

timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
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
  path="$SKILLS_ROOT/$name"
  if exists "$path"; then
    mv "$path" "$BACKUP_DIR/$name"
    moved_names+=("$name")
    moved_count=$((moved_count + 1))
  fi
done

if [[ "$target_preexisting" -eq 0 ]] && exists "$TARGET"; then
  mv "$TARGET" "$BACKUP_DIR/gpt56-superpowers"
  moved_names+=("gpt56-superpowers")
  moved_count=$((moved_count + 1))
fi

if [[ "$target_preexisting" -eq 0 ]]; then
  ln -s "$SOURCE" "$TARGET"
  target_created=1
fi

if [[ ! -L "$TARGET" ]] || [[ "$(readlink "$TARGET")" != "$SOURCE" ]] || [[ ! -f "$TARGET/SKILL.md" ]]; then
  die "post-install link verification failed: $TARGET"
fi

{
  printf 'source=%s\n' "$SOURCE"
  printf 'target=%s\n' "$TARGET"
  printf 'installed_at=%s\n' "$timestamp"
  printf 'preserve_target=%s\n' "$target_preexisting"
  if [[ "$moved_count" -gt 0 ]]; then
    for name in "${moved_names[@]}"; do
      printf 'moved=%s\n' "$name"
    done
  fi
  printf 'state=READY\n'
} > "$BACKUP_DIR/INSTALL_INFO.tmp"
mv "$BACKUP_DIR/INSTALL_INFO.tmp" "$BACKUP_DIR/INSTALL_INFO"
printf '%s\n' "READY" > "$BACKUP_DIR/READY.tmp"
mv "$BACKUP_DIR/READY.tmp" "$BACKUP_DIR/READY"

committed=1
release_lock
trap - EXIT

echo "Installed: $TARGET -> $SOURCE"
echo "Backup: $BACKUP_DIR"
echo "Restart Codex or start a new task to refresh Skill discovery."
