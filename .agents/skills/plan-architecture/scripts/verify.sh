#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
cd "$ROOT" || exit 1

PREFIX="[plan-architecture]"
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
    warn "$1 is empty; architecture decision context may be missing"
  else
    pass "$1 has content"
  fi
}

for doc in \
  docs/architecture/overview.md \
  docs/architecture/api.md \
  docs/architecture/data-model.md \
  docs/architecture/auth-permissions.md \
  docs/development/testing.md \
  docs/project/constraints.md
do
  require_doc "$doc"
done

if [ -d docs/architecture/adr ]; then
  pass "ADR directory exists"
  if find docs/architecture/adr -type f -name '*.md' | grep -q .; then
    pass "ADR directory contains markdown files"
  else
    warn "ADR directory has no markdown files"
  fi
else
  fail "missing ADR directory: docs/architecture/adr"
fi

if [ -f docs/architecture/auth-permissions.md ] && [ -s docs/architecture/auth-permissions.md ]; then
  if grep -Eiq 'auth|permission|role|privacy|token|credential' docs/architecture/auth-permissions.md; then
    pass "auth-permissions doc includes security language"
  else
    warn "auth-permissions doc may not describe auth, permissions, or privacy"
  fi
fi

if [ "$FAILURES" -gt 0 ]; then
  exit 1
fi

if [ "$STRICT" = "1" ] && [ "$WARNINGS" -gt 0 ]; then
  fail "strict mode treats warnings as failures"
  exit 1
fi

pass "plan-architecture verification completed with $WARNINGS warning(s)"
exit 0
