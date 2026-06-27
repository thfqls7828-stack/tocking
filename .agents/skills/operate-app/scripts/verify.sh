#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
cd "$ROOT" || exit 1

PREFIX="[operate-app]"
STRICT="${HARNESS_STRICT:-0}"
WARNINGS=0
FAILURES=0

pass() { printf '%s PASS: %s\n' "$PREFIX" "$*"; }
warn() { WARNINGS=$((WARNINGS + 1)); printf '%s WARN: %s\n' "$PREFIX" "$*" >&2; }
fail() { FAILURES=$((FAILURES + 1)); printf '%s FAIL: %s\n' "$PREFIX" "$*" >&2; }

require_doc() {
  if [ ! -f "$1" ]; then
    fail "missing operations document: $1"
  elif [ ! -s "$1" ]; then
    warn "$1 is empty; operational context may not be captured yet"
  else
    pass "$1 has content"
  fi
}

for doc in \
  docs/operations/monitoring.md \
  docs/operations/incident-playbook.md \
  docs/operations/rollback.md \
  docs/handoff/current-state.md \
  docs/handoff/decisions.md \
  docs/handoff/open-questions.md \
  docs/handoff/next-actions.md
do
  require_doc "$doc"
done

if [ -f docs/operations/incident-playbook.md ] && [ -s docs/operations/incident-playbook.md ]; then
  if grep -Eiq 'severity|impact|owner|timeline|rollback|escalation' docs/operations/incident-playbook.md; then
    pass "incident playbook includes incident handling language"
  else
    warn "incident playbook may not include severity, impact, owner, timeline, rollback, or escalation"
  fi
fi

if [ "$FAILURES" -gt 0 ]; then
  exit 1
fi

if [ "$STRICT" = "1" ] && [ "$WARNINGS" -gt 0 ]; then
  fail "strict mode treats warnings as failures"
  exit 1
fi

pass "operate-app verification completed with $WARNINGS warning(s)"
exit 0
