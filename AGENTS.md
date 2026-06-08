# Tocking 에이전트 가이드

## 프로젝트 목적

Tocking은 토론 앱입니다.

이 앱은 Naver에서 추천하는 주제를 바탕으로 사용자가 토론할 수 있는
공간을 제공합니다. OpenAI API를 사용해 추천 주제를 토론하기 좋은 형태로
정리하고, 사용자가 주장과 반론을 탐색하며 다양한 관점을 비교하고 구조화된
대화에 참여할 수 있도록 돕습니다.

## 제품 방향

- 앱 제목: `Tocking`
- 핵심 영역: 토론과 의견 교환
- 주제 출처: Naver 추천 주제
- AI 기능: OpenAI API를 활용한 주제 구성, 토론 보조, 요약, 관점 탐색
- 핵심 사용자 가치: 사용자가 토론 구조를 처음부터 직접 만들지 않아도,
  현재 추천되는 주제에 대해 명확하고 흥미롭게 토론할 수 있는 공간을 제공

## 작업 원칙

- 구현 선택은 토론 중심의 제품 경험에 맞춥니다.
- 토론을 더 명확하고 균형 있게 만들며, 사용자가 쉽게 참여할 수 있도록 돕는
  기능을 우선합니다.
- 앱 개발은 클린 아키텍처를 준수합니다. 도메인, 데이터, 프레젠테이션,
  외부 연동 책임을 분리하고, UI나 API 구현 세부사항이 도메인 규칙에 새지
  않도록 관리합니다.
- 앱 상태 관리는 Riverpod 라이브러리를 사용합니다. 화면 상태, 비동기 API 상태,
  의존성 주입은 Riverpod provider 계층으로 관리하고, 임시 지역 UI 상태를
  제외한 주요 상태는 위젯 내부에 흩어놓지 않습니다.
- 프레젠테이션 계층은 MVVM 패턴을 따릅니다. View는 화면 렌더링과 사용자 입력
  전달에 집중하고, ViewModel은 Riverpod을 통해 상태와 액션을 노출하며, Model은
  도메인 엔티티와 데이터 모델을 명확히 구분합니다.
- 각 기능과 위젯은 최소 기능 단위를 기준으로 작게 유지합니다. 가능하면 하나의
  기능 파일이나 위젯 파일이 300줄을 넘지 않도록 분리하되, 가독성이나 응집도를
  해치면서까지 무리하게 줄이지는 않습니다.
- `core` 영역은 공통 기반으로 따로 관리합니다. 앱 테마, 색상, 타이포그래피,
  앱 내 shadow, width, height, spacing, radius 같은 디자인 토큰과 공통
  유틸리티는 기능 화면에 흩어놓지 않고 `core`에서 재사용할 수 있게 둡니다.
- Naver 주제 수집과 OpenAI API 동작은 중요한 제품 경계로 취급합니다. 해당
  영역을 구현할 때는 가정과 제약을 문서화합니다.
- 새로운 하네스, 워크플로, 연동을 추가할 때는 관련 참고 자료와 결정 사항을
  이 문서 또는 연결된 문서에 덧붙입니다.
- 이 세션에서 하네스를 구현하거나 수정할 때는 코드 변경과 함께
  `AGENTS.md`도 같이 갱신합니다. 새로 확인한 공식 문서, 구현 결정, 제약,
  검증 방법, 후속 개선 후보를 이 문서에 남깁니다.
- 개발, 기획, 디자인, QA 작업은 가능한 한 최소 기능 단위의 Skill로 나눠
  수행합니다. 예를 들어 UI 구현과 API 연동은 같은 개발 작업이라도 서로 다른
  Skill에서 다루며, 각 Skill은 한 가지 책임만 보장합니다.
- state는 `docs/state.md`를 기준으로 관리합니다. 큰 기획과 작은 기획을
  분리하고, handoff가 필요한 작업은 대상 Skill, 완료된 것, 남은 것, 검증
  상태, 주의할 제약을 명확히 남깁니다.

## Tocking 전용 Skills

- `plan-design-tocking`: 넓은 기획/디자인 요청을 세분 Skill로 나눌 때
  사용합니다.
- `plan-tocking-product`: 제품 요구사항, 사용자 시나리오, MVP 범위를 작게
  정의할 때 사용합니다.
- `manage-tocking-state`: state, handoff, 큰 기획/작은 기획 구조를 정리할 때
  사용합니다.
- `design-tocking-ui`: 화면 구조, 상태별 UI, 토론 UX를 설계할 때 사용합니다.
- `build-tocking-app`: 넓은 앱 개발 요청을 세분 Skill로 나눌 때 사용합니다.
- `manage-tocking-core`: theme, shadow, width, height, spacing, radius,
  공통 유틸리티 등 `core` 공통 기반을 관리할 때 사용합니다.
- `model-tocking-domain`: 토론 주제, 의견, 관점, 상태 전이 등 도메인 모델을
  정의할 때 사용합니다.
- `build-tocking-ui`: 화면과 컴포넌트를 구현할 때 사용합니다.
- `integrate-tocking-api`: Naver/OpenAI API, DTO, repository, 외부 연동 경계를
  구현할 때 사용합니다.
- `qa-tocking`: 넓은 QA 요청을 세분 Skill로 나눌 때 사용합니다.
- `qa-tocking-ui`: 화면, 반응형 레이아웃, 토론 UX, 접근성을 검증할 때
  사용합니다.
- `qa-tocking-api`: API 연동, 실패 처리, 비밀값 노출, fixture를 검증할 때
  사용합니다.

## 참고 자료

추가 참고 자료는 하네스들을 구현하면서 덧붙입니다.

## 공식 문서 재비교 기록

- 2026-06-06: 전체 하네스를 Codex `AGENTS.md`, Codex Skills, Codex App Server,
  OpenAI Agents SDK state/handoff 문서와 재비교했습니다. 결과는
  `docs/harness-docs-comparison.md`에 기록했습니다. 현재 구조는 공식 문서 기준과
  충돌하지 않으며, handoff는 공식 SDK 기능과 Tocking 내부 기록 개념을 구분해서
  사용합니다.

## 추가/수정 추천 기록

- 2026-06-06: 공식 문서 재비교 이후 추가하거나 수정할 만한 하네스 후보를
  `docs/harness-recommendations.md`에 정리했습니다. 우선 후보는 OpenAI API 표면
  결정, Naver 주제 수집 경계 정의, 큰 기획 저장소, handoff 로그, core 토큰
  명세입니다.

## UI 구현 기록

- 2026-06-06: 홈 화면 UI 작업을 시작하며 Flutter 프로젝트 골격을 생성하고
  `lib/core`에 홈 app bar 치수, spacing, 색상 토큰을 추가했습니다. 홈 app bar는
  720x828 기준 프레임 안에서 상하좌우 12px padding을 사용하고, 로고는
  166.5x36px, 검색 액션의 돋보기 박스는 36x36px로 검증합니다. 검증 명령은
  `flutter analyze`, `flutter test`입니다.
- 2026-06-06: 앱 시작 라우팅을 `go_router` 기반으로 전환했습니다.
  `lib/core/router`에서 홈 경로 `/`와 `GoRouter` 구성을 관리하고, `main.dart`는
  `MaterialApp.router`를 사용합니다.

## 개발 원칙 기록

- 2026-06-06: Flutter 앱 상태 관리는 Riverpod을 사용하고, 프레젠테이션 계층은
  MVVM 패턴을 따르도록 개발단에 추가했습니다. 주요 화면 상태와 비동기 API
  상태는 Riverpod provider/ViewModel로 관리하고, View는 렌더링과 입력 전달에
  집중합니다.
- 2026-06-06: 각 기능과 위젯은 최소 기능 단위를 기준으로 작게 유지하고,
  가능하면 파일당 300줄을 넘지 않도록 개발단에 추가했습니다. 단, 응집도와
  가독성을 해치면서까지 무리하게 줄이지는 않습니다.
