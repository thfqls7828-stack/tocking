#!/usr/bin/env python3
"""Final lightweight quality gate for the Flutter Codex harness.

This hook checks the harness itself before completion. It intentionally avoids
running Flutter commands or skill verification scripts, because those remain
workflow-level checks selected by Codex for the current task.
"""

from __future__ import annotations

import ast
import json
import os
import subprocess
import sys
from pathlib import Path
from typing import Any


STRICT_ENV = "HARNESS_STOP_STRICT"

REQUIRED_FILES = (
    "AGENTS.md",
    ".codex/config.toml",
    ".codex/hooks.json",
    ".codex/hooks/pre_tool_use_policy.py",
    ".codex/hooks/post_tool_use_review.py",
    ".codex/hooks/stop_quality_gate.py",
    "docs/harness/quality-gates.md",
    "docs/harness/risk-policy.md",
    "docs/harness/prompt-routing.md",
)

SKILL_NAMES = (
    "plan-product",
    "design-ui",
    "plan-architecture",
    "implement-feature",
    "verify-change",
    "prepare-release",
    "operate-app",
)

HIGH_RISK_PATH_HINTS = (
    "firebase.json",
    ".firebaserc",
    "google-services.json",
    "GoogleService-Info.plist",
    "Info.plist",
    "build.gradle",
    "build.gradle.kts",
    "pubspec.yaml",
    ".env",
    "secrets",
    "auth",
    "permission",
    "migration",
    "release",
    "rollback",
)


class Gate:
    def __init__(self) -> None:
        self.warnings = 0
        self.failures = 0

    def info(self, message: str) -> None:
        print(f"[harness-stop] INFO: {message}", file=sys.stderr)

    def warn(self, message: str) -> None:
        self.warnings += 1
        print(f"[harness-stop] WARN: {message}", file=sys.stderr)

    def fail(self, message: str) -> None:
        self.failures += 1
        print(f"[harness-stop] FAIL: {message}", file=sys.stderr)

    def finish(self) -> int:
        if self.failures:
            print(
                f"[harness-stop] Final gate failed with {self.failures} failure(s) "
                f"and {self.warnings} warning(s).",
                file=sys.stderr,
            )
            return 2
        if os.environ.get(STRICT_ENV) == "1" and self.warnings:
            print(
                f"[harness-stop] {STRICT_ENV}=1 treats {self.warnings} warning(s) as failure.",
                file=sys.stderr,
            )
            return 2
        if self.warnings:
            print(
                f"[harness-stop] Final gate completed with {self.warnings} warning(s).",
                file=sys.stderr,
            )
        return 0


def repo_root() -> Path:
    try:
        output = subprocess.check_output(
            ["git", "rev-parse", "--show-toplevel"],
            stderr=subprocess.DEVNULL,
            text=True,
        ).strip()
        if output:
            return Path(output)
    except Exception:
        pass
    return Path.cwd()


def load_payload() -> Any:
    raw = sys.stdin.read()
    if not raw.strip():
        return {}
    try:
        return json.loads(raw)
    except json.JSONDecodeError:
        return {"raw": raw}


def check_required_files(root: Path, gate: Gate) -> None:
    for relative in REQUIRED_FILES:
        path = root / relative
        if not path.is_file():
            gate.fail(f"missing required harness file: {relative}")
        elif path.stat().st_size == 0:
            gate.fail(f"empty required harness file: {relative}")


def check_hooks_json(root: Path, gate: Gate) -> None:
    path = root / ".codex/hooks.json"
    if not path.is_file():
        return
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:
        gate.fail(f"invalid .codex/hooks.json: {exc}")
        return

    hooks = data.get("hooks")
    if not isinstance(hooks, dict):
        gate.fail(".codex/hooks.json must contain a hooks object")
        return

    for event in ("PreToolUse", "PostToolUse", "Stop"):
        entries = hooks.get(event)
        if not isinstance(entries, list) or not entries:
            gate.fail(f".codex/hooks.json is missing non-empty {event} hooks")


def check_python_syntax(root: Path, gate: Gate) -> None:
    for relative in (
        ".codex/hooks/pre_tool_use_policy.py",
        ".codex/hooks/post_tool_use_review.py",
        ".codex/hooks/stop_quality_gate.py",
    ):
        path = root / relative
        if not path.is_file():
            continue
        try:
            ast.parse(path.read_text(encoding="utf-8"), filename=relative)
        except SyntaxError as exc:
            gate.fail(f"python syntax error in {relative}: {exc}")


def check_shell_syntax(root: Path, gate: Gate) -> None:
    for skill_name in SKILL_NAMES:
        relative = f".agents/skills/{skill_name}/scripts/verify.sh"
        path = root / relative
        if not path.is_file():
            gate.fail(f"missing skill verification script: {relative}")
            continue
        result = subprocess.run(
            ["sh", "-n", str(path)],
            cwd=root,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.PIPE,
            text=True,
            check=False,
        )
        if result.returncode != 0:
            detail = result.stderr.strip() or "sh -n failed"
            gate.fail(f"shell syntax error in {relative}: {detail}")


def check_skill_frontmatter(root: Path, gate: Gate) -> None:
    for skill_name in SKILL_NAMES:
        relative = f".agents/skills/{skill_name}/SKILL.md"
        path = root / relative
        if not path.is_file():
            gate.fail(f"missing skill file: {relative}")
            continue
        lines = path.read_text(encoding="utf-8").splitlines()
        if len(lines) < 4 or lines[0] != "---":
            gate.fail(f"missing YAML frontmatter in {relative}")
            continue
        try:
            end = lines[1:].index("---") + 1
        except ValueError:
            gate.fail(f"unterminated YAML frontmatter in {relative}")
            continue
        frontmatter = "\n".join(lines[1:end])
        if f"name: {skill_name}" not in frontmatter:
            gate.fail(f"skill name must match folder in {relative}")
        if "description:" not in frontmatter:
            gate.fail(f"missing description in {relative}")


def changed_paths(root: Path) -> list[str]:
    try:
        output = subprocess.check_output(
            ["git", "status", "--porcelain"],
            cwd=root,
            stderr=subprocess.DEVNULL,
            text=True,
        )
    except Exception:
        return []

    paths: list[str] = []
    for line in output.splitlines():
        if not line.strip():
            continue
        path = line[3:].strip()
        if " -> " in path:
            path = path.split(" -> ", 1)[1]
        paths.append(path)
    return paths


def check_high_risk_changes(root: Path, gate: Gate) -> None:
    risky = [
        path
        for path in changed_paths(root)
        if any(hint.lower() in path.lower() for hint in HIGH_RISK_PATH_HINTS)
    ]
    if not risky:
        return

    gate.warn("high-risk path changes are present; confirm risk, verification, and residual risk before final response")
    for path in risky[:20]:
        gate.warn(f"high-risk path changed: {path}")


def main() -> int:
    _ = load_payload()
    root = repo_root()
    gate = Gate()

    check_required_files(root, gate)
    check_hooks_json(root, gate)
    check_python_syntax(root, gate)
    check_shell_syntax(root, gate)
    check_skill_frontmatter(root, gate)
    check_high_risk_changes(root, gate)

    if not (root / "pubspec.yaml").exists():
        gate.info("template mode detected; Flutter project checks are left to skill scripts after pubspec.yaml exists")

    return gate.finish()


if __name__ == "__main__":
    raise SystemExit(main())
