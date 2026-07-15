#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP_BASE="$(mktemp -d)"
TMP_ROOT="$TMP_BASE/path with spaces"
SKILLS_ROOT="$TMP_ROOT/skills"
BACKUP_ROOT="$TMP_ROOT/backups"

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

cleanup() {
  rm -rf "$TMP_BASE"
}
trap cleanup EXIT

mkdir -p "$SKILLS_ROOT"
for name in "${LEGACY_SKILLS[@]}"; do
  mkdir -p "$SKILLS_ROOT/$name"
  printf '%s\n' "$name" > "$SKILLS_ROOT/$name/SKILL.md"
done

env SKILLS_ROOT="$SKILLS_ROOT" BACKUP_ROOT="$BACKUP_ROOT" \
  bash "$REPO_ROOT/scripts/install-local.sh" >/dev/null

[[ -L "$SKILLS_ROOT/gpt56-superpowers" ]]
[[ "$(readlink "$SKILLS_ROOT/gpt56-superpowers")" == "$REPO_ROOT/skills/gpt56-superpowers" ]]
for name in "${LEGACY_SKILLS[@]}"; do
  [[ ! -e "$SKILLS_ROOT/$name" && ! -L "$SKILLS_ROOT/$name" ]]
done

backup_count_before="$(find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
env SKILLS_ROOT="$SKILLS_ROOT" BACKUP_ROOT="$BACKUP_ROOT" \
  bash "$REPO_ROOT/scripts/install-local.sh" >/dev/null
backup_count_after="$(find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
[[ "$backup_count_before" == "$backup_count_after" ]]

BACKUP_DIR="$(find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
mkdir -p "$SKILLS_ROOT/brainstorming"
printf '%s\n' "collision" > "$SKILLS_ROOT/brainstorming/SKILL.md"
if env SKILLS_ROOT="$SKILLS_ROOT" BACKUP_ROOT="$BACKUP_ROOT" \
  bash "$REPO_ROOT/scripts/restore-original.sh" "$BACKUP_DIR" >/dev/null 2>&1; then
  echo "restore should refuse a destination collision" >&2
  exit 1
fi
[[ -L "$SKILLS_ROOT/gpt56-superpowers" ]]
grep -Fqx "collision" "$SKILLS_ROOT/brainstorming/SKILL.md"
[[ -f "$BACKUP_DIR/brainstorming/SKILL.md" ]]
[[ ! -f "$BACKUP_DIR/RESTORED" ]]
rm -rf "$SKILLS_ROOT/brainstorming"

env SKILLS_ROOT="$SKILLS_ROOT" BACKUP_ROOT="$BACKUP_ROOT" \
  bash "$REPO_ROOT/scripts/restore-original.sh" "$BACKUP_DIR" >/dev/null

[[ ! -e "$SKILLS_ROOT/gpt56-superpowers" && ! -L "$SKILLS_ROOT/gpt56-superpowers" ]]
for name in "${LEGACY_SKILLS[@]}"; do
  [[ -f "$SKILLS_ROOT/$name/SKILL.md" ]]
  grep -Fqx "$name" "$SKILLS_ROOT/$name/SKILL.md"
done
[[ -f "$BACKUP_DIR/RESTORED" ]]

env SKILLS_ROOT="$SKILLS_ROOT" BACKUP_ROOT="$BACKUP_ROOT" \
  bash "$REPO_ROOT/scripts/install-local.sh" >/dev/null
mkdir -p "$SKILLS_ROOT/using-superpowers"
printf '%s\n' "reinstalled" > "$SKILLS_ROOT/using-superpowers/SKILL.md"

env SKILLS_ROOT="$SKILLS_ROOT" BACKUP_ROOT="$BACKUP_ROOT" \
  bash "$REPO_ROOT/scripts/install-local.sh" >/dev/null
LAYER_INFO="$(grep -l '^preserve_target=1$' "$BACKUP_ROOT"/*/INSTALL_INFO | head -n 1)"
LAYER_BACKUP="$(dirname "$LAYER_INFO")"
[[ -L "$SKILLS_ROOT/gpt56-superpowers" ]]
[[ ! -e "$SKILLS_ROOT/using-superpowers" && ! -L "$SKILLS_ROOT/using-superpowers" ]]

env SKILLS_ROOT="$SKILLS_ROOT" BACKUP_ROOT="$BACKUP_ROOT" \
  bash "$REPO_ROOT/scripts/restore-original.sh" >/dev/null
[[ -L "$SKILLS_ROOT/gpt56-superpowers" ]]
[[ -f "$SKILLS_ROOT/using-superpowers/SKILL.md" ]]
[[ -f "$LAYER_BACKUP/RESTORED" ]]

EMPTY_SKILLS="$TMP_ROOT/empty skills"
EMPTY_BACKUPS="$TMP_ROOT/empty backups"
mkdir -p "$EMPTY_SKILLS"

env SKILLS_ROOT="$EMPTY_SKILLS" BACKUP_ROOT="$EMPTY_BACKUPS" \
  bash "$REPO_ROOT/scripts/install-local.sh" >/dev/null
EMPTY_BACKUP="$(find "$EMPTY_BACKUPS" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
[[ -L "$EMPTY_SKILLS/gpt56-superpowers" ]]
mkdir -p "$EMPTY_BACKUPS/zzzz-incomplete"

env SKILLS_ROOT="$EMPTY_SKILLS" BACKUP_ROOT="$EMPTY_BACKUPS" \
  bash "$REPO_ROOT/scripts/restore-original.sh" >/dev/null
[[ ! -e "$EMPTY_SKILLS/gpt56-superpowers" && ! -L "$EMPTY_SKILLS/gpt56-superpowers" ]]
[[ -f "$EMPTY_BACKUP/RESTORED" ]]

TARGET_SKILLS="$TMP_ROOT/existing target skills"
TARGET_BACKUPS="$TMP_ROOT/existing target backups"
mkdir -p "$TARGET_SKILLS/gpt56-superpowers"
printf '%s\n' "personal target" > "$TARGET_SKILLS/gpt56-superpowers/marker"
env SKILLS_ROOT="$TARGET_SKILLS" BACKUP_ROOT="$TARGET_BACKUPS" \
  bash "$REPO_ROOT/scripts/install-local.sh" >/dev/null
TARGET_BACKUP="$(find "$TARGET_BACKUPS" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
[[ -L "$TARGET_SKILLS/gpt56-superpowers" ]]
env SKILLS_ROOT="$TARGET_SKILLS" BACKUP_ROOT="$TARGET_BACKUPS" \
  bash "$REPO_ROOT/scripts/restore-original.sh" "$TARGET_BACKUP" >/dev/null
[[ -d "$TARGET_SKILLS/gpt56-superpowers" && ! -L "$TARGET_SKILLS/gpt56-superpowers" ]]
grep -Fqx "personal target" "$TARGET_SKILLS/gpt56-superpowers/marker"

BROKEN_SKILLS="$TMP_ROOT/broken link skills"
BROKEN_BACKUPS="$TMP_ROOT/broken link backups"
BROKEN_DEST="$TMP_ROOT/missing legacy target"
mkdir -p "$BROKEN_SKILLS"
ln -s "$BROKEN_DEST" "$BROKEN_SKILLS/using-superpowers"
env SKILLS_ROOT="$BROKEN_SKILLS" BACKUP_ROOT="$BROKEN_BACKUPS" \
  bash "$REPO_ROOT/scripts/install-local.sh" >/dev/null
BROKEN_BACKUP="$(find "$BROKEN_BACKUPS" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
[[ ! -e "$BROKEN_SKILLS/using-superpowers" && ! -L "$BROKEN_SKILLS/using-superpowers" ]]
[[ -L "$BROKEN_BACKUP/using-superpowers" ]]
env SKILLS_ROOT="$BROKEN_SKILLS" BACKUP_ROOT="$BROKEN_BACKUPS" \
  bash "$REPO_ROOT/scripts/restore-original.sh" "$BROKEN_BACKUP" >/dev/null
[[ -L "$BROKEN_SKILLS/using-superpowers" ]]
[[ "$(readlink "$BROKEN_SKILLS/using-superpowers")" == "$BROKEN_DEST" ]]

LOCK_SKILLS="$TMP_ROOT/lock skills"
LOCK_BACKUPS="$TMP_ROOT/lock backups"
mkdir -p "$LOCK_SKILLS/.gpt56-superpowers.lock" "$LOCK_BACKUPS"
if env SKILLS_ROOT="$LOCK_SKILLS" BACKUP_ROOT="$LOCK_BACKUPS" \
  bash "$REPO_ROOT/scripts/install-local.sh" >/dev/null 2>&1; then
  echo "install should refuse an active transaction lock" >&2
  exit 1
fi
[[ ! -e "$LOCK_SKILLS/gpt56-superpowers" && ! -L "$LOCK_SKILLS/gpt56-superpowers" ]]

BAD_SKILLS="$TMP_ROOT/bad backup skills"
mkdir -p "$BAD_SKILLS/using-superpowers"
printf '%s\n' "must remain" > "$BAD_SKILLS/using-superpowers/SKILL.md"
if env SKILLS_ROOT="$BAD_SKILLS" BACKUP_ROOT="$BAD_SKILLS/using-superpowers/backups" \
  bash "$REPO_ROOT/scripts/install-local.sh" >/dev/null 2>&1; then
  echo "install should reject a backup root inside a movable Skill" >&2
  exit 1
fi
grep -Fqx "must remain" "$BAD_SKILLS/using-superpowers/SKILL.md"

NESTED_CODEX="$TMP_ROOT/nested home/.codex"
NESTED_REPO="$NESTED_CODEX/skills/gpt56-superpowers"
mkdir -p "$(dirname "$NESTED_REPO")"
cp -R "$REPO_ROOT" "$NESTED_REPO"
if env CODEX_HOME="$NESTED_CODEX" \
  bash "$NESTED_REPO/scripts/install-local.sh" >/dev/null 2>&1; then
  echo "install should reject a repository nested at the target path" >&2
  exit 1
fi
[[ -d "$NESTED_REPO" && ! -L "$NESTED_REPO" ]]
[[ -f "$NESTED_REPO/skills/gpt56-superpowers/SKILL.md" ]]

echo "PASS: migration transactions, rollback preflights, locks, path safety, and restore smoke tests"
