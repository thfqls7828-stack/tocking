# Flutter App Codex Harness

Flutter 앱 개발자가 기존 프로젝트에 붙여서 바로 사용할 수 있는 Codex harness 템플릿이다.

이 템플릿 자체는 `lib/`, 화면, viewmodel, repository 같은 Flutter 앱 소스 코드나 `pubspec.yaml`을 포함하지 않는다. 사용자의 실제 Flutter 프로젝트 루트에 이 파일들을 붙여 넣으면, Codex가 요청을 분류하고 필요한 skill, 문서, 검증만 사용하도록 돕는다.

## 핵심 개념

| 구성 | 역할 |
| --- | --- |
| `AGENTS.md` | Codex가 항상 먼저 읽는 프로젝트 최상위 지침 |
| `.agents/skills/` | 요청 intent별 작업 workflow |
| `.agents/skills/*/scripts/verify.sh` | skill별 수동/명시 검증 script |
| `.codex/` | Codex 설정과 hooks |
| `docs/` | 프로젝트 기준, 앱별 사실, handoff, harness 정책 |

Codex는 모든 요청을 먼저 `intent`, `scope`, `risk`로 분류한다. 문서 갱신은 항상 “갱신 필요성 보고 -> 사용자 요청 또는 승인 후 기록”을 원칙으로 한다.

## 빠른 사용법

1. 이 템플릿 파일들을 실제 Flutter 프로젝트 루트에 복사한다.
2. Codex를 프로젝트 루트에서 실행한다.
3. Codex가 `AGENTS.md`를 읽고 요청에 맞는 skill을 선택한다.
4. 필요한 경우 Codex가 관련 문서만 읽는다.
5. 문서 갱신이 필요하면 Codex가 먼저 보고하고, 사용자가 요청하거나 승인한 뒤 기록한다.
6. 기능/검증/배포 작업은 관련 skill script 또는 Flutter 명령으로 검증한다.

예시 요청:

```text
프로필 수정 화면을 추가해줘.
버튼 UX 테스트 부탁해.
로그인 토큰 저장 구조를 검토해줘.
릴리스 전 체크리스트 확인해줘.
```

## Codex가 하는 일

- 요청의 intent, scope, risk를 분류한다.
- 필요한 최소 skill만 선택한다.
- 선택된 skill의 `Context Loading`에 있는 문서만 조건부로 읽는다.
- 기존 코드와 문서가 충돌하면 코드를 확인하고 갱신 필요성을 보고한다.
- 불명확한 요청은 바로 확정하지 않고 질문하거나 선택지를 제시한다.
- high-risk 작업은 사용자 확인, 검증, rollback 또는 residual risk를 함께 보고한다.
- 문서 갱신은 사용자 요청 또는 승인 후에만 수행한다.

## 사용자가 결정하는 일

- 앱의 제품 목적, 사용자, MVP 범위
- 디자인 원칙, 화면 흐름, 브랜드/토큰 결정
- 아키텍처, API, 데이터 모델, 인증/권한 정책
- release, rollback, monitoring, incident 기준
- domain docs로 옮길 handoff 후보의 최종 승인
- 새 의존성 추가, 데이터 삭제, 배포 실행, 외부 서비스 설정 변경

Codex는 초안, 후보, 선택지, 검증을 도울 수 있지만 앱별 사실을 추측해서 확정하지 않는다.

## Skill Map

| Skill | 사용 상황 | Script |
| --- | --- | --- |
| `plan-product` | 문제, 사용자, MVP, 지표, 로드맵이 불명확할 때 | `.agents/skills/plan-product/scripts/verify.sh` |
| `design-ui` | UX/UI, 화면 흐름, 상태, 접근성, 반응형 UI를 다룰 때 | `.agents/skills/design-ui/scripts/verify.sh` |
| `plan-architecture` | 구조, API, 데이터, 인증/권한, migration을 판단할 때 | `.agents/skills/plan-architecture/scripts/verify.sh` |
| `implement-feature` | Flutter/Dart 코드, 설정, 리팩터링, 기능 구현을 할 때 | `.agents/skills/implement-feature/scripts/verify.sh` |
| `verify-change` | 테스트, 분석, 회귀 검증, CI 실패를 다룰 때 | `.agents/skills/verify-change/scripts/verify.sh` |
| `prepare-release` | release, deploy, signing, rollout, rollback 준비를 할 때 | `.agents/skills/prepare-release/scripts/verify.sh` |
| `operate-app` | monitoring, incident, support, post-release feedback을 다룰 때 | `.agents/skills/operate-app/scripts/verify.sh` |

## Hooks와 Scripts

| 구분 | 자동/수동 | 역할 |
| --- | --- | --- |
| `PreToolUse` hook | 자동 | 위험 명령과 secret-like payload를 사전 점검 |
| `PostToolUse` hook | 자동 | 변경된 경로에서 high-risk hint 경고 |
| `Stop` hook | 자동 | 최종 응답 전 harness 구조와 syntax를 lightweight 점검 |
| skill `verify.sh` | Codex 또는 사용자가 명시 실행 | 선택된 skill의 문서/검증 기준 확인 |
| Flutter command | 실제 Flutter 프로젝트에서 실행 | `flutter analyze`, `flutter test` 등 앱 코드 검증 |

Hooks는 safety check이며 Flutter test나 skill script를 대체하지 않는다.

## Docs 구조

`docs/`는 공식 Codex 필수 구조가 아니라 이 harness의 프로젝트-local 문서 규약이다.

### `docs/project/`

프로젝트 전체에 영향을 주는 배경, 용어, 제약을 기록한다.

| 파일 | 설명 | 주 입력자 |
| --- | --- | --- |
| `README.md` | project 문서 목록과 사용 기준 | 사용자/Codex 승인 후 |
| `overview.md` | 앱 이름, 목적, 대상 platform, 현재 단계 | 사용자 |
| `glossary.md` | 프로젝트 고유 용어, 약어, 도메인 용어 | 사용자/Codex 승인 후 |
| `constraints.md` | platform, product, technical, safety 제약 | 사용자 |

### `docs/product/`

제품 방향과 범위를 기록한다.

| 파일 | 설명 | 주 입력자 |
| --- | --- | --- |
| `README.md` | product 문서 목록과 사용 기준 | 사용자/Codex 승인 후 |
| `problem.md` | 해결하려는 문제와 desired outcome | 사용자 |
| `target-users.md` | primary/secondary/excluded user | 사용자 |
| `mvp-scope.md` | must/should/could/out-of-scope | 사용자/Codex 승인 후 |
| `success-metrics.md` | 성공 기준, guardrail, learning goal | 사용자 |
| `roadmap.md` | now/next/later, dependency, deferred decision | 사용자 |

### `docs/design/`

UX/UI 기준, 화면 흐름, 상태, design system을 기록한다.

| 파일 | 설명 | 주 입력자 |
| --- | --- | --- |
| `README.md` | design 문서 목록과 사용 기준 | 사용자/Codex 승인 후 |
| `ux-principles.md` | 사용자 목표, friction, feedback, recovery 기준 | 사용자/Codex 승인 후 |
| `ui-principles.md` | layout, hierarchy, responsive, accessibility 기준 | 사용자/Codex 승인 후 |
| `design-system.md` | color, typography, spacing, breakpoint, component contract | 사용자/Codex 승인 후 |
| `screen-flows.md` | 화면 이동, route, guard, display 크기별 flow | 사용자/Codex 승인 후 |
| `states.md` | loading, empty, error, success, disabled, permission 상태 | 사용자/Codex 승인 후 |

### `docs/architecture/`

Flutter 앱 구조와 기술 결정을 기록한다.

| 파일 | 설명 | 주 입력자 |
| --- | --- | --- |
| `README.md` | architecture 문서 목록과 사용 기준 | 사용자/Codex 승인 후 |
| `overview.md` | `lib/core`, `data`, `domain`, `view`, `widgets` 구조 | 사용자/Codex 승인 후 |
| `api.md` | REST, Firebase/serverless, external SDK contract | 사용자/Codex 승인 후 |
| `data-model.md` | Entity, DTO, mapper, repository, storage, migration | 사용자/Codex 승인 후 |
| `auth-permissions.md` | auth, permission, privacy, token/session, secret 경계 | 사용자/Codex 승인 후 |
| `adr/README.md` | 되돌리기 비싼 기술 결정의 ADR 작성 기준 | 사용자/Codex 승인 후 |

### `docs/development/`

코드 작성과 검증 기준을 기록한다.

| 파일 | 설명 | 주 입력자 |
| --- | --- | --- |
| `README.md` | development 문서 목록과 사용 기준 | 사용자/Codex 승인 후 |
| `setup.md` | Flutter/Dart SDK, platform tool, local config 준비 | 사용자/Codex 승인 후 |
| `commands.md` | `flutter pub get`, `flutter analyze`, `flutter test`, build_runner 기준 | 사용자/Codex 승인 후 |
| `conventions.md` | naming, folder, Riverpod, generated code, error, navigation, logging, responsive 기준 | 사용자/Codex 승인 후 |
| `testing.md` | unit/widget/integration/golden/manual verification 기준 | 사용자/Codex 승인 후 |

### `docs/operations/`

release, rollback, monitoring, incident 대응 기준을 기록한다.

| 파일 | 설명 | 주 입력자 |
| --- | --- | --- |
| `README.md` | operations 문서 목록과 사용 기준 | 사용자/Codex 승인 후 |
| `release-checklist.md` | release target, required checks, approval 기준 | 사용자 |
| `rollback.md` | rollback trigger, plan, recovery 검증 | 사용자 |
| `monitoring.md` | crash/error/latency/support signal, release watch | 사용자 |
| `incident-playbook.md` | incident triage, communication, after action | 사용자/Codex 승인 후 |

### `docs/handoff/`

이전 세션을 자동 기억하는 공간이 아니다. 다음 세션이 빠르게 이어받기 위한 rolling snapshot이다.

| 파일 | 설명 | 주 입력자 |
| --- | --- | --- |
| `README.md` | handoff 사용법, size limit, Domain Insert Candidate 형식 | 사용자/Codex 승인 후 |
| `current-state.md` | 최신 focus, 변경, 검증, 다음 continuation point | Codex 제안, 사용자 승인 후 |
| `decisions.md` | 현재 유효한 확정 결정과 domain insert 후보 | Codex 제안, 사용자 승인 후 |
| `open-questions.md` | 답이 없으면 진행이 위험하거나 애매한 질문 | Codex 제안, 사용자 승인 후 |
| `next-actions.md` | 다음에 실행 가능한 후보 작업 | Codex 제안, 사용자 승인 후 |

`handoff`는 계속 쌓는 로그가 아니다. 완료, 폐기, domain docs로 이동된 항목은 오래 남기지 않는다.

### `docs/harness/`

Codex harness 자체의 운영 정책을 기록한다.

| 파일 | 설명 | 주 입력자 |
| --- | --- | --- |
| `README.md` | harness 문서 목록과 사용 기준 | 사용자/Codex 승인 후 |
| `prompt-routing.md` | intent, scope, risk, skill 선택 흐름 | 사용자/Codex 승인 후 |
| `risk-policy.md` | low/medium/high risk 기준과 high-risk trigger | 사용자/Codex 승인 후 |
| `quality-gates.md` | 변경 유형별 완료 기준과 검증 선택 | 사용자/Codex 승인 후 |
| `event-map.md` | prompt, skill, docs, hooks, scripts, completion lifecycle | 사용자/Codex 승인 후 |
| `documentation-ownership.md` | docs ownership, write timing, 기록 규칙 | 사용자/Codex 승인 후 |

## Handoff 작성 방식

Handoff 문서는 짧게 유지한다.

- `current-state.md`: 다음 세션이 이어받기 위한 최신 상태만 기록
- `decisions.md`: 확정 결정만 기록. 순수 제안은 기록하지 않음
- `open-questions.md`: 답이 필요한 질문과 선택지 기록
- `next-actions.md`: 다음 실행 후보와 검증 기준 기록

오래 유지될 규칙은 `Domain Insert Candidate`로 정리한다.

```md
### Candidate: Short title

- Status: pending-domain-insert
- Target doc: `docs/...`
- Insert section: `## Section Name`
- Related doc:
- Reason:

#### Content

- domain docs로 옮길 본문만 작성한다.
```

사용자가 승인하면 Codex가 domain docs에 반영할 수 있다.

## High-risk 기준

다음은 항상 high-risk로 본다.

- 인증, 권한, 세션, 토큰, credential
- 결제, 구독, 구매 복원
- 개인정보, 민감정보, privacy
- 데이터 삭제, import, export, migration
- secret, API key, signing key, service account
- release, deploy, signing, production config
- rollback, monitoring, incident response

High-risk 작업은 검증, rollback 또는 mitigation, residual risk를 함께 확인한다.

## 검증 명령

템플릿 자체 검증:

```bash
python3 .codex/hooks/stop_quality_gate.py
.agents/skills/plan-product/scripts/verify.sh
.agents/skills/design-ui/scripts/verify.sh
.agents/skills/plan-architecture/scripts/verify.sh
.agents/skills/implement-feature/scripts/verify.sh
.agents/skills/verify-change/scripts/verify.sh
.agents/skills/prepare-release/scripts/verify.sh
.agents/skills/operate-app/scripts/verify.sh
```

실제 Flutter 프로젝트에 `pubspec.yaml`이 있으면 Codex는 변경 유형에 따라 다음을 고려한다.

```bash
flutter analyze
flutter test
dart format .
dart run build_runner build --delete-conflicting-outputs
```

## 이 템플릿이 하지 않는 것

- 이 템플릿 자체는 `lib/`, view, viewmodel, repository 같은 Flutter 앱 소스 코드를 포함하지 않는다.
- 실제 Flutter 프로젝트에 붙인 뒤에는 Codex가 사용자 요청에 따라 앱 코드를 작성하거나 수정할 수 있다.
- `pubspec.yaml`을 포함하지 않는다.
- 앱별 제품/디자인/아키텍처 결정을 추측하지 않는다.
- secret, token, credential 값을 문서화하지 않는다.
- hooks만으로 테스트나 빌드 검증을 대체하지 않는다.
