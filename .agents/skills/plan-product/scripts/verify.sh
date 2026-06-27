#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
cd "$ROOT" || exit 1

PREFIX="[plan-product]"
STRICT="${HARNESS_STRICT:-0}"
WARNINGS=0
FAILURES=0

pass() { printf '%s PASS: %s\n' "$PREFIX" "$*"; }
warn() { WARNINGS=$((WARNINGS + 1)); printf '%s WARN: %s\n' "$PREFIX" "$*" >&2; }
fail() { FAILURES=$((FAILURES + 1)); printf '%s FAIL: %s\n' "$PREFIX" "$*" >&2; }

require_doc() {
  if [ ! -f "$1" ]; then
    fail "missing required document: $1"
  elif [ ! -s "$1" ]; then
    warn "$1 is empty; product decisions may not be captured yet"
  else
    pass "$1 has content"
  fi
}

for doc in \
  docs/product/problem.md \
  docs/product/target-users.md \
  docs/product/mvp-scope.md \
  docs/product/success-metrics.md \
  docs/product/roadmap.md \
  docs/handoff/decisions.md \
  docs/handoff/open-questions.md \
  docs/handoff/next-actions.md
do
  require_doc "$doc"
done

if [ -f docs/product/mvp-scope.md ] && [ -s docs/product/mvp-scope.md ]; then
  if grep -Eiq 'must|should|could|out-of-scope|out of scope' docs/product/mvp-scope.md; then
    pass "MVP scope includes prioritization language"
  else
    warn "MVP scope does not mention must/should/could/out-of-scope"
  fi
fi

if [ -f docs/product/success-metrics.md ] && [ -s docs/product/success-metrics.md ]; then
  if grep -Eiq 'metric|measure|success|target|baseline|conversion|retention|activation' docs/product/success-metrics.md; then
    pass "success metrics include measurable language"
  else
    warn "success metrics may not be measurable yet"
  fi
fi

if [ "$FAILURES" -gt 0 ]; then
  exit 1
fi

if [ "$STRICT" = "1" ] && [ "$WARNINGS" -gt 0 ]; then
  fail "strict mode treats warnings as failures"
  exit 1
fi

pass "plan-product verification completed with $WARNINGS warning(s)"
exit 0
