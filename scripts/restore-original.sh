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

contains_name() {
  local needle="$1"
  local candidate
  shift
  for candidate in "$@"; do
    [[ "$candidate" == "$needle" ]] && return 0
  done
  return 1
}

allowed_name() {
  contains_name "$1" "${MANAGED_SKILLS[@]}" || contains_name "$1" "${LEGACY_SKILLS[@]}"
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

mkdir -p "$SKILLS_ROOT" "$BACKUP_ROOT"

BACKUP_DIR=""
restored_names=()
removed_names=()
committed=0
lock_held=0
restored_marker=""

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

  if [[ -n "$restored_marker" ]]; then
    rm -f "$restored_marker" "$BACKUP_DIR/RESTORED"
  fi

  for ((index=${#restored_names[@]} - 1; index >= 0; index--)); do
    name="${restored_names[$index]}"
    if exists "$SKILLS_ROOT/$name" && ! exists "$BACKUP_DIR/$name"; then
      mv "$SKILLS_ROOT/$name" "$BACKUP_DIR/$name" || rollback_error=1
    elif exists "$SKILLS_ROOT/$name"; then
      echo "WARNING: rollback collision at $SKILLS_ROOT/$name" >&2
      rollback_error=1
    fi
  done

  for ((index=${#removed_names[@]} - 1; index >= 0; index--)); do
    name="${removed_names[$index]}"
    if ! exists "$SKILLS_ROOT/$name"; then
      ln -s "$SOURCE_ROOT/$name" "$SKILLS_ROOT/$name" || rollback_error=1
    else
      echo "WARNING: rollback could not recreate $name because its path is occupied" >&2
      rollback_error=1
    fi
  done

  if [[ "$rollback_error" -eq 1 ]]; then
    echo "WARNING: restore rollback was incomplete; inspect $BACKUP_DIR and $SKILLS_ROOT" >&2
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

format_version="$(sed -n 's/^format_version=//p' "$BACKUP_DIR/INSTALL_INFO" | tail -n 1)"
state="$(sed -n 's/^state=//p' "$BACKUP_DIR/INSTALL_INFO" | tail -n 1)"
[[ "$state" == "READY" ]] || die "backup manifest is not READY"

restore_v2() {
  recorded_source_root="$(sed -n 's/^source_root=//p' "$BACKUP_DIR/INSTALL_INFO" | tail -n 1)"
  recorded_skills_root="$(sed -n 's/^skills_root=//p' "$BACKUP_DIR/INSTALL_INFO" | tail -n 1)"
  [[ "$recorded_source_root" == "$SOURCE_ROOT" ]] || die "backup source does not match this repository"
  [[ "$recorded_skills_root" == "$SKILLS_ROOT" ]] || die "backup target does not match this Skills root"

  manifest_managed=()
  manifest_preserved=()
  manifest_created=()
  manifest_moved=()
  while IFS= read -r name; do manifest_managed+=("$name"); done < <(sed -n 's/^managed=//p' "$BACKUP_DIR/INSTALL_INFO")
  while IFS= read -r name; do manifest_preserved+=("$name"); done < <(sed -n 's/^preserved=//p' "$BACKUP_DIR/INSTALL_INFO")
  while IFS= read -r name; do manifest_created+=("$name"); done < <(sed -n 's/^created=//p' "$BACKUP_DIR/INSTALL_INFO")
  while IFS= read -r name; do manifest_moved+=("$name"); done < <(sed -n 's/^moved=//p' "$BACKUP_DIR/INSTALL_INFO")

  [[ "${manifest_managed[*]}" == "${MANAGED_SKILLS[*]}" ]] || die "managed Skill manifest is invalid"

  seen="|"
  for name in "${manifest_preserved[@]}" "${manifest_created[@]}"; do
    contains_name "$name" "${MANAGED_SKILLS[@]}" || die "unknown managed Skill in manifest: $name"
    [[ "$seen" != *"|$name|"* ]] || die "duplicate or overlapping managed state: $name"
    seen="$seen$name|"
  done
  for name in "${MANAGED_SKILLS[@]}"; do
    [[ "$seen" == *"|$name|"* ]] || die "managed Skill lacks preserved or created state: $name"
  done

  seen_moved="|"
  for name in "${manifest_moved[@]}"; do
    allowed_name "$name" || die "unknown moved Skill in manifest: $name"
    [[ "$seen_moved" != *"|$name|"* ]] || die "duplicate moved Skill in manifest: $name"
    seen_moved="$seen_moved$name|"
    exists "$BACKUP_DIR/$name" || die "manifest item is absent from backup: $name"
    if contains_name "$name" "${MANAGED_SKILLS[@]}"; then
      contains_name "$name" "${manifest_created[@]}" || die "moved managed Skill was not recreated: $name"
    fi
  done

  for entry in "$BACKUP_DIR"/*; do
    item="$(basename "$entry")"
    case "$item" in
      INSTALL_INFO|READY|RESTORED|RESTORED.tmp.*) continue ;;
    esac
    contains_name "$item" "${manifest_moved[@]}" || die "backup item is absent from manifest: $item"
  done

  for name in "${manifest_moved[@]}"; do
    if exists "$SKILLS_ROOT/$name"; then
      if contains_name "$name" "${manifest_created[@]}" && exact_link "$name"; then
        continue
      fi
      die "restore collision at $SKILLS_ROOT/$name"
    fi
  done

  for name in "${manifest_created[@]}"; do
    if exact_link "$name"; then
      rm "$SKILLS_ROOT/$name"
      removed_names+=("$name")
    elif exists "$SKILLS_ROOT/$name" && contains_name "$name" "${manifest_moved[@]}"; then
      die "restore collision at $SKILLS_ROOT/$name"
    fi
  done

  for name in "${manifest_moved[@]}"; do
    mv "$BACKUP_DIR/$name" "$SKILLS_ROOT/$name"
    restored_names+=("$name")
  done

  echo "Restored ${#restored_names[@]} backed-up Skill directories; removed ${#removed_names[@]} transaction-created links."
}

restore_v1() {
  recorded_source="$(sed -n 's/^source=//p' "$BACKUP_DIR/INSTALL_INFO" | tail -n 1)"
  recorded_target="$(sed -n 's/^target=//p' "$BACKUP_DIR/INSTALL_INFO" | tail -n 1)"
  preserve_target="$(sed -n 's/^preserve_target=//p' "$BACKUP_DIR/INSTALL_INFO" | tail -n 1)"
  [[ "$recorded_source" == "$SOURCE_ROOT/gpt56-superpowers" ]] || die "version-1 backup source does not match this repository"
  [[ "$recorded_target" == "$SKILLS_ROOT/gpt56-superpowers" ]] || die "version-1 backup target does not match this Skills root"
  [[ "$preserve_target" == "0" || "$preserve_target" == "1" ]] || die "invalid version-1 preserve_target value"

  manifest_moved=()
  seen_moved="|"
  while IFS= read -r name; do
    if [[ "$name" != "gpt56-superpowers" ]] && ! contains_name "$name" "${LEGACY_SKILLS[@]}"; then
      die "unknown version-1 moved Skill: $name"
    fi
    [[ "$seen_moved" != *"|$name|"* ]] || die "duplicate version-1 moved Skill: $name"
    seen_moved="$seen_moved$name|"
    manifest_moved+=("$name")
  done < <(sed -n 's/^moved=//p' "$BACKUP_DIR/INSTALL_INFO")

  for name in "${manifest_moved[@]}"; do
    exists "$BACKUP_DIR/$name" || die "version-1 manifest item is absent from backup: $name"
    if exists "$SKILLS_ROOT/$name"; then
      if [[ "$name" == "gpt56-superpowers" && "$preserve_target" == "0" ]] && exact_link "$name"; then
        continue
      fi
      die "restore collision at $SKILLS_ROOT/$name"
    fi
  done

  for entry in "$BACKUP_DIR"/*; do
    item="$(basename "$entry")"
    case "$item" in
      INSTALL_INFO|READY|RESTORED|RESTORED.tmp.*) continue ;;
    esac
    contains_name "$item" "${manifest_moved[@]}" || die "version-1 backup item is absent from manifest: $item"
  done

  if [[ "$preserve_target" == "1" ]]; then
    exact_link gpt56-superpowers || die "version-1 backup expects the core link to remain present"
  elif exact_link gpt56-superpowers; then
    rm "$SKILLS_ROOT/gpt56-superpowers"
    removed_names+=("gpt56-superpowers")
  elif exists "$SKILLS_ROOT/gpt56-superpowers"; then
    die "refusing to remove an unrelated core target"
  fi

  [[ ${#manifest_moved[@]} -gt 0 || "$preserve_target" == "0" ]] || die "version-1 backup contains no state to restore"
  for name in "${manifest_moved[@]}"; do
    mv "$BACKUP_DIR/$name" "$SKILLS_ROOT/$name"
    restored_names+=("$name")
  done

  echo "Restored version-1 transaction: ${#restored_names[@]} directories."
}

case "$format_version" in
  2) restore_v2 ;;
  "") restore_v1 ;;
  *) die "unsupported backup format version: $format_version" ;;
esac

restored_marker="$BACKUP_DIR/RESTORED.tmp.$$"
printf 'restored_at=%s\n' "$(date -u +%Y%m%dT%H%M%SZ)" > "$restored_marker"
mv "$restored_marker" "$BACKUP_DIR/RESTORED"
restored_marker="$BACKUP_DIR/RESTORED"

committed=1
release_lock
trap - EXIT

echo "Backup restored: $BACKUP_DIR"
echo "Restart Codex or start a new task to refresh Skill discovery."
