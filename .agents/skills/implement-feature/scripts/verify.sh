#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
cd "$ROOT" || exit 1

PREFIX="[implement-feature]"
STRICT="${HARNESS_STRICT:-0}"
WARNINGS=0
FAILURES=0
PLACEHOLDER_PATTERN='Short title|^- [A-Z][A-Za-z0-9 /-]+:[[:space:]]*$|^- Option [A-Z]:[[:space:]]*$|^- [[:space:]]*$'

info() { printf '%s INFO: %s\n' "$PREFIX" "$*"; }
pass() { printf '%s PASS: %s\n' "$PREFIX" "$*"; }
warn() { WARNINGS=$((WARNINGS + 1)); printf '%s WARN: %s\n' "$PREFIX" "$*" >&2; }
fail() { FAILURES=$((FAILURES + 1)); printf '%s FAIL: %s\n' "$PREFIX" "$*" >&2; }

check_placeholders() {
  for doc in "$@"; do
    if [ -f "$doc" ] && grep -Eq "$PLACEHOLDER_PATTERN" "$doc"; then
      warn "template placeholder remains in $doc; do not treat this as confirmed project facts"
    fi
  done
}

if [ -f pubspec.yaml ]; then
  pass "Flutter/Dart project detected"
  if command -v flutter >/dev/null 2>&1; then
    flutter analyze || fail "flutter analyze failed"
  else
    fail "flutter command not found; cannot run flutter analyze"
  fi

  if [ ! -d lib ]; then
    warn "pubspec.yaml exists but lib/ directory was not found"
  fi

  if [ ! -d test ]; then
    warn "no test/ directory found; behavior changes should be covered by verify-change"
  fi
else
  info "No pubspec.yaml found; skipping Flutter analyze"
fi

for doc in docs/development/commands.md docs/development/conventions.md docs/development/testing.md; do
  if [ ! -f "$doc" ]; then
    fail "missing development document: $doc"
  elif [ ! -s "$doc" ]; then
    warn "$doc is empty"
  else
    pass "$doc has content"
  fi
done

check_placeholders docs/development/commands.md docs/development/conventions.md docs/development/testing.md

if [ "$FAILURES" -gt 0 ]; then
  exit 1
fi

if [ "$STRICT" = "1" ] && [ "$WARNINGS" -gt 0 ]; then
  fail "strict mode treats warnings as failures"
  exit 1
fi

pass "implement-feature verification completed with $WARNINGS warning(s)"
exit 0
