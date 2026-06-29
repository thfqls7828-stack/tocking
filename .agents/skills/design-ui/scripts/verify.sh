#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
cd "$ROOT" || exit 1

PREFIX="[design-ui]"
STRICT="${HARNESS_STRICT:-0}"
WARNINGS=0
FAILURES=0
PLACEHOLDER_PATTERN='Short title|^- [A-Z][A-Za-z0-9 /-]+:[[:space:]]*$|^- Option [A-Z]:[[:space:]]*$|^- [[:space:]]*$'

info() { printf '%s INFO: %s\n' "$PREFIX" "$*"; }
pass() { printf '%s PASS: %s\n' "$PREFIX" "$*"; }
warn() { WARNINGS=$((WARNINGS + 1)); printf '%s WARN: %s\n' "$PREFIX" "$*" >&2; }
fail() { FAILURES=$((FAILURES + 1)); printf '%s FAIL: %s\n' "$PREFIX" "$*" >&2; }

require_doc() {
  if [ ! -f "$1" ]; then
    fail "missing required document: $1"
  elif [ ! -s "$1" ]; then
    warn "$1 is empty; UI decision context may be missing"
  else
    pass "$1 has content"
  fi
}

check_placeholders() {
  for doc in "$@"; do
    if [ -f "$doc" ] && grep -Eq "$PLACEHOLDER_PATTERN" "$doc"; then
      warn "template placeholder remains in $doc; do not treat this as confirmed project facts"
    fi
  done
}

for doc in \
  docs/design/ux-principles.md \
  docs/design/ui-principles.md \
  docs/design/design-system.md \
  docs/design/screen-flows.md \
  docs/design/states.md \
  docs/project/constraints.md
do
  require_doc "$doc"
done

check_placeholders \
  docs/design/ux-principles.md \
  docs/design/ui-principles.md \
  docs/design/design-system.md \
  docs/design/screen-flows.md \
  docs/design/states.md \
  docs/project/constraints.md

if [ -f docs/design/states.md ] && [ -s docs/design/states.md ]; then
  for state in loading empty error success disabled; do
    if grep -Eiq "$state" docs/design/states.md; then
      pass "state coverage mentions $state"
    else
      warn "states doc does not mention $state"
    fi
  done
fi

info "Manual visual checklist: layout, overflow, tap target, loading, empty, error, disabled, accessibility, contrast, navigation feedback."

if [ -f pubspec.yaml ]; then
  if [ ! -d test ]; then
    warn "Flutter project has no test/ directory for UI verification"
  elif command -v rg >/dev/null 2>&1 && rg -q 'testWidgets|WidgetTester|matchesGoldenFile|golden' test; then
    if command -v flutter >/dev/null 2>&1; then
      flutter test || fail "flutter UI/widget/golden tests failed"
    else
      fail "flutter command not found for UI/widget/golden tests"
    fi
  elif grep -RIEq 'testWidgets|WidgetTester|matchesGoldenFile|golden' test 2>/dev/null; then
    if command -v flutter >/dev/null 2>&1; then
      flutter test || fail "flutter UI/widget/golden tests failed"
    else
      fail "flutter command not found for UI/widget/golden tests"
    fi
  else
    warn "no widget/golden UI tests detected; use manual visual verification"
  fi
else
  info "No pubspec.yaml found; skipping Flutter UI tests"
fi

if [ "$FAILURES" -gt 0 ]; then
  exit 1
fi

if [ "$STRICT" = "1" ] && [ "$WARNINGS" -gt 0 ]; then
  fail "strict mode treats warnings as failures"
  exit 1
fi

pass "design-ui verification completed with $WARNINGS warning(s)"
exit 0
