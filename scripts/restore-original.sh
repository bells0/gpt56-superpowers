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

RESTORABLE_SKILLS=(
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
  gpt56-superpowers
)

exists() {
  [[ -e "$1" || -L "$1" ]]
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

mkdir -p "$SKILLS_ROOT" "$BACKUP_ROOT"

BACKUP_DIR=""
restore_names=()
restored_names=()
restore_count=0
removed_link=0
committed=0
lock_held=0
restored_marker=""

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

  if [[ -n "$restored_marker" ]]; then
    rm -f "$restored_marker" "$BACKUP_DIR/RESTORED"
  fi

  for ((index=${#restored_names[@]} - 1; index >= 0; index--)); do
    name="${restored_names[$index]}"
    if exists "$SKILLS_ROOT/$name" && ! exists "$BACKUP_DIR/$name"; then
      if ! mv "$SKILLS_ROOT/$name" "$BACKUP_DIR/$name"; then
        echo "WARNING: rollback could not return $name to $BACKUP_DIR" >&2
        rollback_error=1
      fi
    elif exists "$SKILLS_ROOT/$name"; then
      echo "WARNING: rollback collision left $name at $SKILLS_ROOT/$name" >&2
      rollback_error=1
    fi
  done

  if [[ "$removed_link" -eq 1 ]] && ! exists "$TARGET"; then
    if ! ln -s "$SOURCE" "$TARGET"; then
      echo "WARNING: rollback could not recreate $TARGET" >&2
      rollback_error=1
    fi
  elif [[ "$removed_link" -eq 1 ]]; then
    echo "WARNING: rollback could not recreate $TARGET because the path is occupied" >&2
    rollback_error=1
  fi

  if [[ "$rollback_error" -eq 1 ]]; then
    echo "WARNING: rollback was incomplete; inspect $BACKUP_DIR and $SKILLS_ROOT" >&2
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

BACKUP_DIR="${1:-}"
if [[ -z "$BACKUP_DIR" ]]; then
  while IFS= read -r candidate; do
    if [[ -f "$candidate/READY" && ! -f "$candidate/RESTORED" ]]; then
      BACKUP_DIR="$candidate"
      break
    fi
  done < <(find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 -type d | sort -r)
fi

[[ -n "$BACKUP_DIR" && -d "$BACKUP_DIR" ]] || die "no unrestored READY backup directory found"
[[ -f "$BACKUP_DIR/READY" ]] || die "backup is incomplete or untrusted: $BACKUP_DIR"
[[ ! -f "$BACKUP_DIR/RESTORED" ]] || die "backup was already restored: $BACKUP_DIR"
[[ -f "$BACKUP_DIR/INSTALL_INFO" ]] || die "backup manifest is missing: $BACKUP_DIR"
python3 - "$SKILLS_ROOT" "$BACKUP_DIR" <<'PY'
import os
import sys

if os.stat(sys.argv[1]).st_dev != os.stat(sys.argv[2]).st_dev:
    print("ERROR: Skills and backup roots must be on the same filesystem", file=sys.stderr)
    raise SystemExit(1)
PY

recorded_source="$(sed -n 's/^source=//p' "$BACKUP_DIR/INSTALL_INFO" | tail -n 1)"
recorded_target="$(sed -n 's/^target=//p' "$BACKUP_DIR/INSTALL_INFO" | tail -n 1)"
recorded_state="$(sed -n 's/^state=//p' "$BACKUP_DIR/INSTALL_INFO" | tail -n 1)"
preserve_target="$(sed -n 's/^preserve_target=//p' "$BACKUP_DIR/INSTALL_INFO" | tail -n 1)"

[[ "$recorded_source" == "$SOURCE" ]] || die "backup source does not match this repository"
[[ "$recorded_target" == "$TARGET" ]] || die "backup target does not match this Skills root"
[[ "$recorded_state" == "READY" ]] || die "backup manifest is not READY"
[[ "$preserve_target" == "0" || "$preserve_target" == "1" ]] || die "invalid preserve_target value"

if exists "$TARGET"; then
  [[ -L "$TARGET" ]] || die "refusing to replace non-symlink target: $TARGET"
  [[ "$(readlink "$TARGET")" == "$SOURCE" ]] || die "refusing to remove an unrelated symlink: $TARGET"
fi

if [[ "$preserve_target" -eq 1 ]] && ! exists "$TARGET"; then
  die "backup expects the current GPT-5.6 Skill link to remain present"
fi

for name in "${RESTORABLE_SKILLS[@]}"; do
  if exists "$BACKUP_DIR/$name"; then
    grep -Fqx "moved=$name" "$BACKUP_DIR/INSTALL_INFO" || die "backup item is absent from manifest: $name"
    if [[ "$name" != "gpt56-superpowers" ]] && exists "$SKILLS_ROOT/$name"; then
      die "restore collision at $SKILLS_ROOT/$name"
    fi
    restore_names+=("$name")
    restore_count=$((restore_count + 1))
  fi
done

manifest_move_count="$(grep -c '^moved=' "$BACKUP_DIR/INSTALL_INFO" || true)"
[[ "$manifest_move_count" -eq "$restore_count" ]] || die "backup manifest and contents disagree"
if [[ "$restore_count" -eq 0 && "$preserve_target" -eq 1 ]]; then
  die "backup contains no state to restore"
fi

if [[ "$preserve_target" -eq 0 ]] && [[ -L "$TARGET" ]]; then
  rm "$TARGET"
  removed_link=1
fi

if [[ "$restore_count" -gt 0 ]]; then
  for name in "${restore_names[@]}"; do
    mv "$BACKUP_DIR/$name" "$SKILLS_ROOT/$name"
    restored_names+=("$name")
  done
fi

restored_marker="$BACKUP_DIR/RESTORED.tmp.$$"
printf 'restored_at=%s\n' "$(date -u +%Y%m%dT%H%M%SZ)" > "$restored_marker"
mv "$restored_marker" "$BACKUP_DIR/RESTORED"
restored_marker="$BACKUP_DIR/RESTORED"

committed=1
release_lock
trap - EXIT

echo "Restored $restore_count Skill directories from: $BACKUP_DIR"
echo "Restart Codex or start a new task to refresh Skill discovery."
