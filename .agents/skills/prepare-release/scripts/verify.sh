#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
cd "$ROOT" || exit 1

PREFIX="[prepare-release]"
STRICT="${HARNESS_STRICT:-0}"
WARNINGS=0
FAILURES=0

info() { printf '%s INFO: %s\n' "$PREFIX" "$*"; }
pass() { printf '%s PASS: %s\n' "$PREFIX" "$*"; }
warn() { WARNINGS=$((WARNINGS + 1)); printf '%s WARN: %s\n' "$PREFIX" "$*" >&2; }
fail() { FAILURES=$((FAILURES + 1)); printf '%s FAIL: %s\n' "$PREFIX" "$*" >&2; }

require_doc() {
  if [ ! -f "$1" ]; then
    fail "missing release document: $1"
  elif [ ! -s "$1" ]; then
    warn "$1 is empty; fill it before real release work"
  else
    pass "$1 has content"
  fi
}

for doc in \
  docs/operations/release-checklist.md \
  docs/operations/rollback.md \
  docs/operations/monitoring.md \
  docs/handoff/decisions.md \
  docs/handoff/open-questions.md \
  docs/handoff/next-actions.md
do
  require_doc "$doc"
done

for path in firebase.json .firebaserc fastlane codemagic.yaml .github/workflows .gitlab-ci.yml .circleci; do
  if [ -e "$path" ]; then
    warn "release-affecting config exists: $path; confirm rollback and approval before deploy"
  fi
done

FASTLANE_DIRS="$(find . -maxdepth 3 -type d -name fastlane 2>/dev/null || true)"
if [ -n "$FASTLANE_DIRS" ]; then
  warn "release-affecting Fastlane tooling exists; confirm rollback and approval before deploy"
fi

info "Release readiness checklist: target, build, signing, smoke test, rollback trigger, monitoring, owner approval."
info "This verification script never runs deployment commands."

if [ "$FAILURES" -gt 0 ]; then
  exit 1
fi

if [ "$STRICT" = "1" ] && [ "$WARNINGS" -gt 0 ]; then
  fail "strict mode treats warnings as failures"
  exit 1
fi

pass "prepare-release verification completed with $WARNINGS warning(s)"
exit 0
