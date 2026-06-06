# Tocking State Guide

## 목적

이 문서는 Tocking 프로젝트에서 state를 어떻게 나누고, 기록하고, 다음 작업으로
넘길지 정의합니다.

state는 단순한 UI 상태만 의미하지 않습니다. Tocking에서는 제품 기획 상태,
작업 진행 상태, 앱 런타임 상태, 외부 API 연동 상태, handoff 상태를 분리해
관리합니다.

## 공식 문서 기준

- Codex App Server는 `Thread`, `Turn`, `Item`을 핵심 단위로 설명합니다. Thread는
  사용자와 Codex agent의 대화이고, Turn은 하나의 사용자 요청과 그에 따른 agent
  작업이며, Item은 메시지, 명령 실행, 파일 변경, 도구 호출 같은 입력/출력
  단위입니다.
- OpenAI Agents SDK의 state 문서는 대화 이력 관리 방식으로 `Sessions`,
  `conversation_id`, `previous_response_id`를 구분합니다.
- OpenAI Agents SDK의 `RunState`는 human-in-the-loop 재개를 위한 직렬화 가능한
  실행 스냅샷입니다. context, usage, interruptions, model responses, approval
  state 등을 포함하는 실행 상태로 봅니다.
- OpenAI Agents SDK의 handoff는 agent가 다른 전문 agent에게 대화 제어권을
  넘기는 구조입니다. Tocking에서는 이 개념을 그대로 빌려, 사람이든 Skill이든
  다음 담당자가 이어받기 위해 필요한 맥락을 명확히 남기는 절차로 사용합니다.

### 공식 문서 링크

- Codex App Server: https://developers.openai.com/codex/app-server
- Agents SDK state and conversation management:
  https://openai.github.io/openai-agents-python/running_agents/#state-and-conversation-management
- Agents SDK RunState:
  https://openai.github.io/openai-agents-python/ref/run_state/
- Agents SDK Handoffs:
  https://openai.github.io/openai-agents-python/handoffs/

## State 분류

### 1. Product Planning State

제품의 큰 방향과 기능 단위를 관리합니다.

- 큰 기획: 제품 목표, 사용자 문제, 핵심 가치, 주요 흐름, MVP 범위
- 작은 기획: 큰 기획 안의 단일 기능, 화면, API, 상태, QA 단위
- 결정 사항: 왜 이 방향을 선택했는지
- 보류 사항: 아직 결정하지 않은 질문
- 연결 Skill: `plan-tocking-product`, `design-tocking-ui`

### 2. Work State

현재 작업이 어디까지 진행됐는지 관리합니다.

- 요청 요약
- 사용한 Skill
- 읽은 공식 문서 또는 참고 자료
- 변경한 파일
- 검증한 항목
- 검증하지 못한 항목
- 다음 작업 후보

### 3. App Runtime State

앱 실행 중 사용자에게 보이는 상태를 관리합니다.

- loading
- empty
- ready
- error
- submitting
- refreshing
- rate-limited

UI 구현 시 이 상태들은 화면에 명시적으로 드러나야 하며, API 연동 실패나 빈
응답이 단순한 크래시로 이어지면 안 됩니다.

### 4. Domain State

Tocking의 토론 도메인 상태를 관리합니다.

- 추천 주제 수집 전/후
- 토론 의제 구성 전/후
- 찬성/반대/중립 관점 준비 상태
- 사용자 의견 작성 상태
- AI 요약 또는 질문 생성 상태

도메인 상태는 UI 프레임워크나 외부 API SDK에 직접 의존하지 않습니다.

### 5. External API State

Naver와 OpenAI API 연동 상태를 관리합니다.

- request-ready
- requesting
- success
- empty-response
- invalid-response
- rate-limited
- auth-error
- network-error
- server-error

외부 API 원본 응답, DTO, 도메인 모델은 서로 분리합니다.

## 큰 기획과 작은 기획

큰 기획은 Tocking의 제품 방향을 바꾸거나 여러 기능을 묶는 단위입니다. 작은
기획은 하나의 구현 또는 검증 단위로 끝낼 수 있어야 합니다.

### 큰 기획 템플릿

```md
## 큰 기획: <이름>

- 목표:
- 사용자 문제:
- 핵심 가치:
- 포함 범위:
- 제외 범위:
- 관련 작은 기획:
- 관련 Skill:
- 결정 사항:
- 보류 질문:
```

### 작은 기획 템플릿

```md
### 작은 기획: <이름>

- 소속 큰 기획:
- 사용자 시나리오:
- 최소 기능:
- 필요한 화면:
- 필요한 API:
- 필요한 도메인 상태:
- 완료 조건:
- QA 기준:
```

## Handoff 규칙

handoff는 다음 담당자, 다음 Skill, 또는 다음 작업 단계가 같은 맥락에서 이어갈
수 있도록 제어권과 상태를 넘기는 기록입니다.

handoff를 남겨야 하는 경우:

- 큰 기획에서 작은 기획으로 내려갈 때
- 기획에서 디자인으로 넘길 때
- 디자인에서 UI 구현으로 넘길 때
- UI 구현에서 API 연동 또는 도메인 모델 작업으로 분리될 때
- 구현에서 QA로 넘길 때
- 작업을 중단하고 사용자의 입력을 기다릴 때

### Handoff 템플릿

```md
## Handoff: <대상 또는 다음 Skill>

- 현재 단계:
- 넘기는 이유:
- 완료된 것:
- 남은 것:
- 필요한 입력:
- 관련 파일:
- 관련 큰 기획:
- 관련 작은 기획:
- 검증 상태:
- 주의할 제약:
```

handoff에는 “무엇을 했는지”만 쓰지 않습니다. 반드시 “다음 사람이 무엇을
해야 하는지”와 “어떤 상태를 믿어도 되는지”를 함께 씁니다.

## 운영 규칙

- 큰 기획 없이 작은 기획만 늘리지 않습니다.
- 작은 기획은 하나의 Skill이 처리할 수 있을 정도로 작게 유지합니다.
- state 변경이 하네스 구현에 영향을 주면 `AGENTS.md`에도 요약을 남깁니다.
- handoff가 필요한 작업은 이 문서의 템플릿을 사용합니다.
- 공식 문서와 다른 의미로 `state` 또는 `handoff`를 사용할 때는 Tocking 내부
  의미임을 명확히 표시합니다.
