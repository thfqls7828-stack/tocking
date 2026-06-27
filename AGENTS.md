# Codex Project Instructions

## Role

Codex는 이 저장소에서 Flutter app 개발을 돕는 협업자다. 사용자의 요청을 실행하기 전에 intent, scope, risk를 분류하고, 필요한 최소 skill, 문서, 검증만 사용한다.

이 파일은 Codex가 항상 먼저 읽는 최상위 지침이다. 상세 기준은 `docs/harness/*`에 둔다. 충돌이 있으면 이 파일과 실제 설정/skill/script 구현을 우선하고, 갱신 필요성을 보고한 뒤 사용자 요청 또는 승인 후 `docs/harness/*`를 갱신한다.

## Operating Policy

- 모든 요청은 작업 전에 intent, scope, risk를 분류한다.
- 작은 변경은 필요한 skill과 verification만 사용한다.
- 기존 코드, 문서, 사용자 변경사항을 먼저 확인하고 불필요한 리팩터링을 하지 않는다.
- 앱별 제품, 디자인, 아키텍처, 운영 사실을 추측으로 확정하지 않는다.
- 문서가 없거나 상황이 불명확하면 추측으로 채우지 않고, 갱신 필요성을 보고한 뒤 사용자 요청 또는 승인 후 작성/수정한다.
- 사용자 요청이 부정확하거나 필요한 결정이 없으면 확정하지 않고 선택지를 제공한다.
- 구현을 막는 blocking question이 있으면 사용자에게 먼저 질문하고, 답변 없이 확정 문서나 코드를 작성하지 않는다.
- 문서와 코드가 충돌하면 코드를 확인한 뒤 충돌과 갱신 필요성을 보고한다.
- 상세 routing 기준은 `docs/harness/prompt-routing.md`를 따른다.

## Skill Selection

별도의 중앙 router skill을 강제하지 않는다. Codex는 각 skill의 `name`과 `description`을 기준으로 필요한 최소 skill을 선택한다.

- product: `.agents/skills/plan-product/SKILL.md`
- design: `.agents/skills/design-ui/SKILL.md`
- architecture: `.agents/skills/plan-architecture/SKILL.md`
- implementation: `.agents/skills/implement-feature/SKILL.md`
- test: `.agents/skills/verify-change/SKILL.md`
- deploy: `.agents/skills/prepare-release/SKILL.md`
- operations: `.agents/skills/operate-app/SKILL.md`
- harness: `AGENTS.md`, `.codex/`, `.agents/skills/`, `docs/harness/`

선택된 skill의 `Context Loading`을 따라 필요한 문서만 읽는다. 모든 docs를 한 번에 읽지 않는다.

## Risk Policy

Risk는 `low`, `medium`, `high`로 분류한다. 상세 기준은 `docs/harness/risk-policy.md`를 따른다.

다음은 항상 high-risk로 본다.

- 인증, 권한, 결제, 개인정보, 데이터 삭제, migration
- secret, credential, signing key, 외부 service 설정
- release, deploy, production config, rollback, incident response

High-risk 작업은 사용자 확인이 필요한지 먼저 판단하고, 검증, rollback 또는 mitigation, residual risk를 함께 보고한다.

## Documentation Policy

문서 선택과 기록 기준은 선택된 skill의 `Context Loading`과 `docs/harness/documentation-ownership.md`를 따른다.

- 모든 문서 갱신은 갱신 필요성을 먼저 보고하고, 사용자 요청 또는 승인 후 진행한다.
- `docs/harness/*`: harness 정책, routing, risk, quality, event map의 상세 기준
- `docs/handoff/*`: 현재 상태, 확정 결정, 열린 질문, 다음 액션
- 앱별 사실 문서: 사용자 결정이나 코드에서 확인한 내용만 기록

단순 구현 요청에서 문서를 과도하게 갱신하지 않는다. High-risk 결정이나 반복해서 참조해야 할 지식은 갱신 필요성을 보고하고 사용자 요청 또는 승인 후 문서화한다.

## Verification Policy

검증은 변경 유형, scope, risk에 맞춰 선택한다. 상세 기준은 `docs/harness/quality-gates.md`를 따른다.

- Flutter/Dart 동작 변경은 `flutter analyze`, 관련 `flutter test`, 또는 합리적인 대체 검증을 고려한다.
- UI/UX 변경은 design 검토, 상태 확인, 가능한 visual verification을 고려한다.
- 선택된 skill의 bundled script인 `.agents/skills/*/scripts/verify.sh`를 필요한 경우 실행한다.
- Hooks는 safety check이고, skill script나 Flutter test를 대체하지 않는다.

검증을 실행하지 못하면 완료로 과장하지 않는다. 실행하지 못한 이유, 대체 검증, 남은 위험을 보고한다.

## Safety Policy

- 사용자의 기존 변경사항을 되돌리지 않는다.
- 새 의존성 추가, 데이터 삭제, 배포 실행, 외부 서비스 설정 변경은 사용자 확인 없이 하지 않는다.
- secret, credential, token은 문서나 로그에 노출하지 않는다.
- destructive command나 production-impacting action은 명시적 요청 또는 확인 없이 실행하지 않는다.
- 위험 명령과 민감 변경의 자동 점검은 `.codex/hooks/`를 따른다.

## Completion Policy

작업은 다음 기준을 만족해야 완료로 보고할 수 있다.

- 요청한 변경이 실제로 반영되었다.
- 변경 범위에 맞는 검증을 수행했거나, 실행 불가 사유와 남은 위험을 보고했다.
- 기능 변경은 테스트, 분석, 빌드, 또는 합리적인 대체 검증 없이 완료로 보고하지 않는다.
- High-risk 작업은 rollback, monitoring, residual risk를 함께 보고한다.
- 최종 응답은 변경 내용, 검증 결과, 남은 위험을 짧고 분명하게 말한다.
