# Harness Recommendations

## 작성 일자

- 2026-06-06

## 기준

- `docs/harness-docs-comparison.md`의 공식 문서 재비교 결과
- 현재 `AGENTS.md`, `docs/state.md`, `.agents/skills/*` 구조
- Tocking의 제품 목적: Naver 추천 주제와 OpenAI API를 활용한 토론 앱

## 우선순위 높은 추천

### 1. OpenAI API 표면 결정

현재 `integrate-tocking-api`는 OpenAI API 연동을 다루지만, 실제 구현에서
Responses API를 쓸지, Agents SDK를 쓸지, 또는 단순 서버 API wrapper를 둘지
아직 정하지 않았습니다.

추천:

- 작은 기획: `OpenAI 토론 보조 API 표면 결정`
- 담당 Skill: `plan-tocking-product`, `integrate-tocking-api`
- 결정할 것:
  - 토론 주제 재구성에 사용할 API 표면
  - structured output 필요 여부
  - 안전성/검증/재시도 방식
  - 클라이언트에서 직접 호출하지 않고 서버 경계를 둘지 여부

### 2. Naver 주제 수집 경계 정의

Naver 추천 주제를 사용한다는 제품 방향은 정해졌지만, 실제 데이터 출처와 수집
방식은 아직 하네스에 구체화되어 있지 않습니다.

추천:

- 작은 기획: `Naver 추천 주제 수집 방식 정의`
- 담당 Skill: `plan-tocking-product`, `integrate-tocking-api`, `qa-tocking-api`
- 결정할 것:
  - 공식 API 사용 여부
  - scraping 금지/허용 범위
  - 캐싱, 빈 응답, rate limit 대응
  - 원본 주제와 토론용 가공 주제의 분리 방식

### 3. 큰 기획 저장소 추가

`docs/state.md`에 큰 기획/작은 기획 템플릿은 있지만, 실제 기획들을 모아둘
위치가 아직 없습니다.

추천:

- 추가 파일: `docs/planning.md`
- 담당 Skill: `manage-tocking-state`, `plan-tocking-product`
- 포함할 것:
  - 큰 기획 목록
  - 각 큰 기획의 작은 기획 목록
  - 진행 상태
  - handoff 기록 링크

### 4. Handoff 로그 위치 추가

handoff 템플릿은 있지만 실제 handoff 기록을 어디에 쌓을지 정해지지 않았습니다.

추천:

- 추가 파일: `docs/handoff-log.md`
- 담당 Skill: `manage-tocking-state`
- 포함할 것:
  - 날짜
  - 넘기는 Skill
  - 받는 Skill
  - 관련 큰 기획/작은 기획
  - 믿어도 되는 상태
  - 남은 작업

### 5. Core 토큰 명세 추가

`manage-tocking-core`와 `AGENTS.md`는 core 관리 원칙을 갖고 있지만, 실제 theme,
shadow, width, height, spacing, radius 토큰 이름과 기본값은 아직 없습니다.

추천:

- 추가 파일: `docs/core-tokens.md`
- 담당 Skill: `manage-tocking-core`, `design-tocking-ui`, `build-tocking-ui`
- 포함할 것:
  - color token
  - typography token
  - spacing token
  - radius token
  - shadow token
  - width/height/layout token

## 중간 우선순위 추천

### 6. 도메인 모델 초안 추가

도메인 모델 Skill은 있지만 실제 Tocking의 핵심 엔티티 초안은 아직 없습니다.

추천:

- 추가 파일: `docs/domain-model.md`
- 담당 Skill: `model-tocking-domain`
- 포함할 후보:
  - `DebateTopic`
  - `DebateIssue`
  - `Viewpoint`
  - `UserOpinion`
  - `AiDebateAssist`
  - `TopicSource`
  - `ApiFailure`

### 7. QA 체크리스트 통합 문서 추가

UI QA와 API QA Skill은 분리되어 있지만, 출시 전 또는 큰 기능 단위 QA 체크리스트는
아직 없습니다.

추천:

- 추가 파일: `docs/qa-checklist.md`
- 담당 Skill: `qa-tocking`, `qa-tocking-ui`, `qa-tocking-api`
- 포함할 것:
  - UI QA
  - API QA
  - state/handoff QA
  - 보안/비밀값 QA
  - 모바일 QA

### 8. Skill 라우팅 표 추가

현재 `AGENTS.md`에는 Skill 목록이 있지만, “이 요청이면 어떤 Skill?”을 표로
빠르게 판단하는 문서는 없습니다.

추천:

- 추가 파일 또는 `AGENTS.md` 섹션: `Skill 라우팅 표`
- 담당 Skill: `manage-tocking-state`
- 효과:
  - 라우터 Skill의 과도한 암시 호출을 줄임
  - 작업 시작 전에 최소 단위 Skill을 더 빠르게 선택

## 낮은 우선순위 추천

### 9. Router Skill 암시 호출 제한 검토

공식 문서는 `agents/openai.yaml`의 `policy.allow_implicit_invocation`으로 암시
호출을 제한할 수 있다고 설명합니다. 현재 라우터 Skill도 암시 호출될 수 있습니다.

추천:

- 당장은 유지합니다.
- 실제 사용 중 라우터 Skill이 너무 자주 선택되면 다음 라우터 Skill에
  `allow_implicit_invocation: false`를 추가합니다.
  - `plan-design-tocking`
  - `build-tocking-app`
  - `qa-tocking`

### 10. 실제 앱 생성 후 state enum과 문서 동기화

현재 `docs/state.md`의 runtime/API state는 문서상의 기준입니다. 실제 코드가
생기면 enum, sealed class, type union 등 코드 표현과 맞춰야 합니다.

추천:

- 앱 골격 생성 후 `docs/state.md`를 코드 상태 타입과 재비교합니다.
- 담당 Skill: `model-tocking-domain`, `build-tocking-ui`, `integrate-tocking-api`

## 이번 단계에서 바로 수정할 필요가 없는 것

- 현재 Skill 구조 자체는 공식 문서 기준과 충돌하지 않습니다.
- `AGENTS.md`는 아직 기본 32 KiB 제한 안에 있으므로 분할이 필요하지 않습니다.
- `agents/openai.yaml` dependency 선언은 아직 구체 MCP/API dependency가 없으므로
  보류하는 편이 낫습니다.

## 추천 실행 순서

1. `docs/planning.md` 생성
2. `docs/handoff-log.md` 생성
3. `docs/core-tokens.md` 생성
4. OpenAI API 표면 결정
5. Naver 주제 수집 경계 정의
6. `docs/domain-model.md` 생성
7. `docs/qa-checklist.md` 생성
