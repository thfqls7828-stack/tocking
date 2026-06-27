#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
cd "$ROOT" || exit 1

PREFIX="[verify-change]"
STRICT="${HARNESS_STRICT:-0}"
WARNINGS=0
FAILURES=0

info() { printf '%s INFO: %s\n' "$PREFIX" "$*"; }
pass() { printf '%s PASS: %s\n' "$PREFIX" "$*"; }
warn() { WARNINGS=$((WARNINGS + 1)); printf '%s WARN: %s\n' "$PREFIX" "$*" >&2; }
fail() { FAILURES=$((FAILURES + 1)); printf '%s FAIL: %s\n' "$PREFIX" "$*" >&2; }

for doc in docs/development/testing.md docs/development/commands.md docs/harness/quality-gates.md; do
  if [ ! -f "$doc" ]; then
    fail "missing verification document: $doc"
  elif [ ! -s "$doc" ]; then
    warn "$doc is empty"
  else
    pass "$doc has content"
  fi
done

if [ -f pubspec.yaml ]; then
  pass "Flutter/Dart project detected"
  if [ -d test ] && find test -type f -name '*_test.dart' | grep -q .; then
    if command -v flutter >/dev/null 2>&1; then
      flutter test || fail "flutter test failed"
    else
      fail "flutter command not found; cannot run flutter test"
    fi
  else
    warn "no Flutter *_test.dart files found"
  fi
else
  info "No pubspec.yaml found; skipping Flutter tests"
fi

if [ "$FAILURES" -gt 0 ]; then
  exit 1
fi

if [ "$STRICT" = "1" ] && [ "$WARNINGS" -gt 0 ]; then
  fail "strict mode treats warnings as failures"
  exit 1
fi

pass "verify-change verification completed with $WARNINGS warning(s)"
exit 0
