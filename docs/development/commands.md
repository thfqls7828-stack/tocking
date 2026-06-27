# Commands

## Purpose

이 문서는 Flutter app 개발 중 반복 실행하는 명령을 기록한다.

## Read When

- Flutter dependency 설치, 분석, 테스트, 포맷, 빌드 명령을 실행할 때
- Riverpod Generator나 build_runner 같은 code generation 명령이 필요할 때
- asset 변경 후 필요한 명령을 고를 때
- harness 또는 skill verification script를 실행할 때

## Update Policy

Codex는 사용자 요청이 있거나, 실제 프로젝트 명령이 코드/설정/script에서 확인되었고 사용자 승인을 받은 경우에만 이 문서를 수정한다.
확인되지 않은 flavor, target, signing, deploy 명령은 추측으로 기록하지 않는다.

## Related Docs

| Topic | Source |
| --- | --- |
| Development conventions | `docs/development/conventions.md` |
| Test strategy | `docs/development/testing.md` |
| Setup requirements | `docs/development/setup.md` |
| Release commands and readiness | `docs/operations/release-checklist.md` |
| Verification gates | `docs/harness/quality-gates.md` |

## Baseline Flutter

```bash
flutter pub get
flutter analyze
flutter test
```

## Focused Verification

가장 작은 유효 검증부터 실행한다.

```bash
flutter test test/path/to_test.dart
flutter test --name "test name"
```

## Formatting

```bash
dart format .
```

## Code Generation

프로젝트가 code generation을 사용하면 실제 명령을 기록한다. 기본 명령은 다음과 같다.

```bash
dart run build_runner build --delete-conflicting-outputs
```

Run code generation when:

- `@riverpod` provider/notifier를 추가, 삭제, 이름 변경할 때
- provider parameter나 generated provider 선언에 영향을 주는 source를 바꿀 때
- `part '*.g.dart';`를 추가하거나 변경할 때
- `*.g.dart`가 없거나 stale/conflicting 상태일 때
- analyze/build가 generated code mismatch를 보고할 때

Usually do not run code generation when:

- 기존 provider를 소비하는 UI 코드만 바뀔 때
- notifier method body만 바뀌고 선언부가 그대로일 때
- 테스트나 문서만 바뀔 때

`*.g.dart` 파일은 직접 수정하지 않는다. Project-specific command가 확인되면 이 section에 추가하고 그 명령을 우선한다.

## Build

앱별 build, flavor, signing 명령은 확인된 뒤에만 기록한다. Release나 deploy 목적의 명령은 `docs/operations/release-checklist.md`와 `docs/harness/quality-gates.md`도 함께 확인한다.

```bash
# Project-specific build commands go here.
```

## Asset Changes

Asset을 추가, 삭제, 이동하거나 `pubspec.yaml` asset entry를 바꾸면 다음을 고려한다.

```bash
flutter pub get
flutter analyze
```

관련 화면이 있으면 widget test, screenshot, manual visual verification 중 가능한 검증을 함께 고려한다.

## Harness Verification

```bash
.agents/skills/implement-feature/scripts/verify.sh
.agents/skills/verify-change/scripts/verify.sh
.agents/skills/design-ui/scripts/verify.sh
.agents/skills/prepare-release/scripts/verify.sh
```

## Diagnostics

진단 명령은 원인 파악에 필요한 경우에만 실행한다.

```bash
flutter doctor
flutter devices
flutter pub outdated
```

## Command Rules

- 가장 좁고 빠른 명령부터 실행한다.
- 실패한 명령은 command, failure summary, next step을 함께 보고한다.
- deploy, delete, reset, migration, signing, production config 명령은 명시적 확인 없이 실행하지 않는다.
- 앱별 flavor, target, env file을 추측해서 명령에 넣지 않는다.
