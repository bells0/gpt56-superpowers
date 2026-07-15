#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP_BASE="$(mktemp -d)"
TMP_ROOT="$TMP_BASE/path with spaces"

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

cleanup() {
  rm -rf "$TMP_BASE"
}
trap cleanup EXIT

make_legacy() {
  root="$1"
  mkdir -p "$root"
  for name in "${LEGACY_SKILLS[@]}"; do
    mkdir -p "$root/$name"
    printf '%s\n' "$name" > "$root/$name/SKILL.md"
  done
}

assert_managed_links() {
  root="$1"
  for name in "${MANAGED_SKILLS[@]}"; do
    [[ -L "$root/$name" ]]
    [[ "$(readlink "$root/$name")" == "$REPO_ROOT/skills/$name" ]]
    [[ -f "$root/$name/SKILL.md" ]]
  done
}

assert_no_managed() {
  root="$1"
  for name in "${MANAGED_SKILLS[@]}"; do
    [[ ! -e "$root/$name" && ! -L "$root/$name" ]]
  done
}

run_install() {
  root="$1"
  backups="$2"
  env SKILLS_ROOT="$root" BACKUP_ROOT="$backups" bash "$REPO_ROOT/scripts/install-local.sh" >/dev/null
}

run_restore() {
  root="$1"
  backups="$2"
  shift 2
  env SKILLS_ROOT="$root" BACKUP_ROOT="$backups" bash "$REPO_ROOT/scripts/restore-original.sh" "$@" >/dev/null
}

# Fresh migration, exact idempotency, collision preflight, and broken-link round trip.
BASE_SKILLS="$TMP_ROOT/base skills"
BASE_BACKUPS="$TMP_ROOT/base backups"
make_legacy "$BASE_SKILLS"
rm -rf "$BASE_SKILLS/using-superpowers"
BROKEN_DEST="$TMP_ROOT/missing original target"
ln -s "$BROKEN_DEST" "$BASE_SKILLS/using-superpowers"

run_install "$BASE_SKILLS" "$BASE_BACKUPS"
assert_managed_links "$BASE_SKILLS"
for name in "${LEGACY_SKILLS[@]}"; do
  [[ ! -e "$BASE_SKILLS/$name" && ! -L "$BASE_SKILLS/$name" ]]
done
BASE_BACKUP="$(find "$BASE_BACKUPS" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
grep -Fqx 'format_version=2' "$BASE_BACKUP/INSTALL_INFO"
[[ "$(grep -c '^created=' "$BASE_BACKUP/INSTALL_INFO")" -eq 6 ]]
[[ "$(grep -c '^moved=' "$BASE_BACKUP/INSTALL_INFO")" -eq 14 ]]

backup_count_before="$(find "$BASE_BACKUPS" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
run_install "$BASE_SKILLS" "$BASE_BACKUPS"
backup_count_after="$(find "$BASE_BACKUPS" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
[[ "$backup_count_before" == "$backup_count_after" ]]

mkdir -p "$BASE_SKILLS/brainstorming"
printf '%s\n' collision > "$BASE_SKILLS/brainstorming/SKILL.md"
if run_restore "$BASE_SKILLS" "$BASE_BACKUPS" "$BASE_BACKUP" 2>/dev/null; then
  echo "restore should refuse a legacy destination collision" >&2
  exit 1
fi
assert_managed_links "$BASE_SKILLS"
[[ ! -f "$BASE_BACKUP/RESTORED" ]]
rm -rf "$BASE_SKILLS/brainstorming"

run_restore "$BASE_SKILLS" "$BASE_BACKUPS" "$BASE_BACKUP"
assert_no_managed "$BASE_SKILLS"
for name in "${LEGACY_SKILLS[@]}"; do
  [[ -e "$BASE_SKILLS/$name" || -L "$BASE_SKILLS/$name" ]]
done
[[ -L "$BASE_SKILLS/using-superpowers" ]]
[[ "$(readlink "$BASE_SKILLS/using-superpowers")" == "$BROKEN_DEST" ]]

# Upgrade from version 0.1: preserve the existing core and remove only five new links on restore.
UPGRADE_SKILLS="$TMP_ROOT/upgrade skills"
UPGRADE_BACKUPS="$TMP_ROOT/upgrade backups"
mkdir -p "$UPGRADE_SKILLS"
ln -s "$REPO_ROOT/skills/gpt56-superpowers" "$UPGRADE_SKILLS/gpt56-superpowers"
run_install "$UPGRADE_SKILLS" "$UPGRADE_BACKUPS"
assert_managed_links "$UPGRADE_SKILLS"
UPGRADE_BACKUP="$(find "$UPGRADE_BACKUPS" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
grep -Fqx 'preserved=gpt56-superpowers' "$UPGRADE_BACKUP/INSTALL_INFO"
[[ "$(grep -c '^created=' "$UPGRADE_BACKUP/INSTALL_INFO")" -eq 5 ]]
run_restore "$UPGRADE_SKILLS" "$UPGRADE_BACKUPS" "$UPGRADE_BACKUP"
[[ -L "$UPGRADE_SKILLS/gpt56-superpowers" ]]
for name in "${MANAGED_SKILLS[@]:1}"; do
  [[ ! -e "$UPGRADE_SKILLS/$name" && ! -L "$UPGRADE_SKILLS/$name" ]]
done

# A conflicting narrow Skill is backed up and restored exactly.
CONFLICT_SKILLS="$TMP_ROOT/conflict skills"
CONFLICT_BACKUPS="$TMP_ROOT/conflict backups"
mkdir -p "$CONFLICT_SKILLS/gpt56-debugging"
printf '%s\n' personal > "$CONFLICT_SKILLS/gpt56-debugging/marker"
run_install "$CONFLICT_SKILLS" "$CONFLICT_BACKUPS"
CONFLICT_BACKUP="$(find "$CONFLICT_BACKUPS" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
grep -Fqx 'moved=gpt56-debugging' "$CONFLICT_BACKUP/INSTALL_INFO"
run_restore "$CONFLICT_SKILLS" "$CONFLICT_BACKUPS" "$CONFLICT_BACKUP"
for name in gpt56-superpowers gpt56-design-planning gpt56-verification gpt56-delegation-review gpt56-git-delivery; do
  [[ ! -e "$CONFLICT_SKILLS/$name" && ! -L "$CONFLICT_SKILLS/$name" ]]
done
[[ -d "$CONFLICT_SKILLS/gpt56-debugging" && ! -L "$CONFLICT_SKILLS/gpt56-debugging" ]]
grep -Fqx personal "$CONFLICT_SKILLS/gpt56-debugging/marker"

# Restore refuses replacement of a link whose previous target is waiting in backup.
COLLISION_SKILLS="$TMP_ROOT/moved collision skills"
COLLISION_BACKUPS="$TMP_ROOT/moved collision backups"
mkdir -p "$COLLISION_SKILLS/gpt56-debugging"
printf '%s\n' original > "$COLLISION_SKILLS/gpt56-debugging/marker"
run_install "$COLLISION_SKILLS" "$COLLISION_BACKUPS"
COLLISION_BACKUP="$(find "$COLLISION_BACKUPS" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
rm "$COLLISION_SKILLS/gpt56-debugging"
mkdir -p "$COLLISION_SKILLS/gpt56-debugging"
printf '%s\n' replacement > "$COLLISION_SKILLS/gpt56-debugging/marker"
if run_restore "$COLLISION_SKILLS" "$COLLISION_BACKUPS" "$COLLISION_BACKUP" 2>/dev/null; then
  echo "restore should refuse a moved-target collision" >&2
  exit 1
fi
[[ ! -f "$COLLISION_BACKUP/RESTORED" ]]
grep -Fqx replacement "$COLLISION_SKILLS/gpt56-debugging/marker"
for name in gpt56-superpowers gpt56-design-planning gpt56-verification gpt56-delegation-review gpt56-git-delivery; do
  [[ -L "$COLLISION_SKILLS/$name" ]]
done

# User content replacing a newly created empty target is preserved, while other created links are removed.
USER_SKILLS="$TMP_ROOT/user replacement skills"
USER_BACKUPS="$TMP_ROOT/user replacement backups"
mkdir -p "$USER_SKILLS"
run_install "$USER_SKILLS" "$USER_BACKUPS"
USER_BACKUP="$(find "$USER_BACKUPS" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
rm "$USER_SKILLS/gpt56-verification"
mkdir -p "$USER_SKILLS/gpt56-verification"
printf '%s\n' user-owned > "$USER_SKILLS/gpt56-verification/marker"
run_restore "$USER_SKILLS" "$USER_BACKUPS" "$USER_BACKUP"
for name in gpt56-superpowers gpt56-design-planning gpt56-debugging gpt56-delegation-review gpt56-git-delivery; do
  [[ ! -e "$USER_SKILLS/$name" && ! -L "$USER_SKILLS/$name" ]]
done
grep -Fqx user-owned "$USER_SKILLS/gpt56-verification/marker"

# Inject a third-link failure and require complete rollback.
FAIL_SKILLS="$TMP_ROOT/failure skills"
FAIL_BACKUPS="$TMP_ROOT/failure backups"
FAKE_BIN="$TMP_ROOT/fake bin"
COUNTER="$TMP_ROOT/ln counter"
make_legacy "$FAIL_SKILLS"
mkdir -p "$FAKE_BIN"
REAL_LN="$(command -v ln)"
printf '%s\n' \
  '#!/usr/bin/env bash' \
  'set -eu' \
  'count=0' \
  '[[ ! -f "$LN_COUNTER" ]] || count="$(sed -n "1p" "$LN_COUNTER")"' \
  'count=$((count + 1))' \
  'printf "%s\n" "$count" > "$LN_COUNTER"' \
  '[[ "$count" -ne "$FAIL_LN_AT" ]] || exit 73' \
  'exec "$REAL_LN" "$@"' > "$FAKE_BIN/ln"
chmod +x "$FAKE_BIN/ln"
if env SKILLS_ROOT="$FAIL_SKILLS" BACKUP_ROOT="$FAIL_BACKUPS" \
  PATH="$FAKE_BIN:$PATH" LN_COUNTER="$COUNTER" FAIL_LN_AT=3 REAL_LN="$REAL_LN" \
  bash "$REPO_ROOT/scripts/install-local.sh" >/dev/null 2>&1; then
  echo "install should fail when link creation fails" >&2
  exit 1
fi
assert_no_managed "$FAIL_SKILLS"
for name in "${LEGACY_SKILLS[@]}"; do
  [[ -f "$FAIL_SKILLS/$name/SKILL.md" ]]
done
[[ "$(find "$FAIL_BACKUPS" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')" -eq 0 ]]

# A mid-restore move failure recreates removed links and leaves backup contents READY.
RESTORE_FAIL_SKILLS="$TMP_ROOT/restore failure skills"
RESTORE_FAIL_BACKUPS="$TMP_ROOT/restore failure backups"
RESTORE_FAKE_BIN="$TMP_ROOT/restore fake bin"
MV_COUNTER="$TMP_ROOT/mv counter"
make_legacy "$RESTORE_FAIL_SKILLS"
run_install "$RESTORE_FAIL_SKILLS" "$RESTORE_FAIL_BACKUPS"
RESTORE_FAIL_BACKUP="$(find "$RESTORE_FAIL_BACKUPS" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
mkdir -p "$RESTORE_FAKE_BIN"
REAL_MV="$(command -v mv)"
printf '%s\n' \
  '#!/usr/bin/env bash' \
  'set -eu' \
  'count=0' \
  '[[ ! -f "$MV_COUNTER" ]] || count="$(sed -n "1p" "$MV_COUNTER")"' \
  'count=$((count + 1))' \
  'printf "%s\n" "$count" > "$MV_COUNTER"' \
  '[[ "$count" -ne 1 ]] || exit 74' \
  'exec "$REAL_MV" "$@"' > "$RESTORE_FAKE_BIN/mv"
chmod +x "$RESTORE_FAKE_BIN/mv"
if env SKILLS_ROOT="$RESTORE_FAIL_SKILLS" BACKUP_ROOT="$RESTORE_FAIL_BACKUPS" \
  PATH="$RESTORE_FAKE_BIN:$PATH" MV_COUNTER="$MV_COUNTER" REAL_MV="$REAL_MV" \
  bash "$REPO_ROOT/scripts/restore-original.sh" "$RESTORE_FAIL_BACKUP" >/dev/null 2>&1; then
  echo "restore should fail when a backup move fails" >&2
  exit 1
fi
assert_managed_links "$RESTORE_FAIL_SKILLS"
for name in "${LEGACY_SKILLS[@]}"; do
  [[ -e "$RESTORE_FAIL_BACKUP/$name" || -L "$RESTORE_FAIL_BACKUP/$name" ]]
  [[ ! -e "$RESTORE_FAIL_SKILLS/$name" && ! -L "$RESTORE_FAIL_SKILLS/$name" ]]
done
[[ ! -f "$RESTORE_FAIL_BACKUP/RESTORED" ]]

# Version-1 manifests remain restorable.
V1_SKILLS="$TMP_ROOT/v1 skills"
V1_BACKUPS="$TMP_ROOT/v1 backups"
V1_BACKUP="$V1_BACKUPS/txn-00000000000000000001"
mkdir -p "$V1_SKILLS" "$V1_BACKUP/using-superpowers"
ln -s "$REPO_ROOT/skills/gpt56-superpowers" "$V1_SKILLS/gpt56-superpowers"
printf '%s\n' legacy-v1 > "$V1_BACKUP/using-superpowers/SKILL.md"
printf '%s\n' \
  "source=$REPO_ROOT/skills/gpt56-superpowers" \
  "target=$V1_SKILLS/gpt56-superpowers" \
  'installed_at=20260101T000000Z' \
  'preserve_target=0' \
  'moved=using-superpowers' \
  'state=READY' > "$V1_BACKUP/INSTALL_INFO"
printf '%s\n' READY > "$V1_BACKUP/READY"
run_restore "$V1_SKILLS" "$V1_BACKUPS" "$V1_BACKUP"
[[ ! -e "$V1_SKILLS/gpt56-superpowers" && ! -L "$V1_SKILLS/gpt56-superpowers" ]]
grep -Fqx legacy-v1 "$V1_SKILLS/using-superpowers/SKILL.md"

# Shared lock and path-overlap preflights remain fail-closed.
LOCK_SKILLS="$TMP_ROOT/lock skills"
LOCK_BACKUPS="$TMP_ROOT/lock backups"
mkdir -p "$LOCK_SKILLS/.gpt56-superpowers.lock" "$LOCK_BACKUPS"
if run_install "$LOCK_SKILLS" "$LOCK_BACKUPS" 2>/dev/null; then
  echo "install should refuse an active transaction lock" >&2
  exit 1
fi
assert_no_managed "$LOCK_SKILLS"

BAD_SKILLS="$TMP_ROOT/bad backup skills"
mkdir -p "$BAD_SKILLS/using-superpowers"
printf '%s\n' remain > "$BAD_SKILLS/using-superpowers/SKILL.md"
if env SKILLS_ROOT="$BAD_SKILLS" BACKUP_ROOT="$BAD_SKILLS/using-superpowers/backups" \
  bash "$REPO_ROOT/scripts/install-local.sh" >/dev/null 2>&1; then
  echo "install should reject a backup root inside a movable Skill" >&2
  exit 1
fi
grep -Fqx remain "$BAD_SKILLS/using-superpowers/SKILL.md"

ALIAS_SKILLS="$TMP_ROOT/alias skills"
ALIAS_BACKUP="$TMP_ROOT/alias backup"
mkdir -p "$ALIAS_SKILLS"
ln -s "$ALIAS_SKILLS" "$ALIAS_BACKUP"
if env SKILLS_ROOT="$ALIAS_SKILLS" BACKUP_ROOT="$ALIAS_BACKUP" \
  bash "$REPO_ROOT/scripts/install-local.sh" >/dev/null 2>&1; then
  echo "install should reject a backup-root symlink aliasing the Skills root" >&2
  exit 1
fi
assert_no_managed "$ALIAS_SKILLS"
[[ -z "$(find "$ALIAS_SKILLS" -mindepth 1 -maxdepth 1 -name 'txn-*' -print -quit)" ]]

NESTED_CODEX="$TMP_ROOT/nested home/.codex"
NESTED_REPO="$NESTED_CODEX/skills/gpt56-superpowers"
mkdir -p "$(dirname "$NESTED_REPO")"
cp -R "$REPO_ROOT" "$NESTED_REPO"
if env CODEX_HOME="$NESTED_CODEX" bash "$NESTED_REPO/scripts/install-local.sh" >/dev/null 2>&1; then
  echo "install should reject a repository nested at a managed target" >&2
  exit 1
fi
[[ -d "$NESTED_REPO" && ! -L "$NESTED_REPO" ]]

echo "PASS: six-Skill transactions, v1 compatibility, rollback, collisions, locks, and path safety"
