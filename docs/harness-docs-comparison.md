# Harness Official Docs Comparison

## 비교 일자

- 2026-06-06

## 비교 대상

- `AGENTS.md`
- `docs/state.md`
- `.agents/skills/*/SKILL.md`
- `.agents/skills/*/agents/openai.yaml`

## 공식 문서 기준

### Codex AGENTS.md

공식 문서 기준:

- Codex는 작업 전에 `AGENTS.md`를 읽습니다.
- 전역 scope와 프로젝트 scope를 계층적으로 병합합니다.
- 프로젝트에서는 Git root부터 현재 작업 디렉터리까지 내려오며, 더 가까운
  지침이 나중에 들어가 우선됩니다.
- 기본 `project_doc_max_bytes`는 32 KiB입니다.

비교 결과:

- Tocking의 `AGENTS.md`는 repository root에 있어 프로젝트 지침으로 적절합니다.
- 현재 크기는 32 KiB보다 작아 기본 제한 안에 있습니다.
- 프로젝트 목적, 작업 원칙, Skill 목록, state 기준이 들어 있어 Codex가 작업 전
  읽을 durable guidance로 적합합니다.

판정: 일치

### Codex Skills

공식 문서 기준:

- Skill은 `SKILL.md`가 있는 디렉터리입니다.
- `SKILL.md` frontmatter에는 `name`과 `description`이 필요합니다.
- Codex는 `.agents/skills`를 repository scope Skill 위치로 스캔합니다.
- Skill은 명시적 호출과 description 기반 암시적 호출로 활성화될 수 있습니다.
- description은 명확한 scope와 boundary를 가져야 합니다.
- `agents/openai.yaml`은 UI metadata와 invocation policy, dependency 선언에
  사용할 수 있는 선택 파일입니다.
- 공식 best practice는 각 Skill을 한 가지 작업에 집중시키는 것입니다.

비교 결과:

- 모든 Tocking Skill은 `.agents/skills/<skill-name>/SKILL.md` 구조를 따릅니다.
- 모든 `SKILL.md`에는 `name`과 `description`이 있습니다.
- 모든 Skill에 `agents/openai.yaml`이 있습니다.
- 초기의 넓은 Skill 3개는 실제 작업을 직접 수행하지 않고 세분 Skill로 라우팅하는
  역할로 조정되어, 한 가지 책임 원칙을 크게 해치지 않습니다.
- 세분 Skill은 UI 구현, API 연동, core 관리, 도메인 모델, UI QA, API QA처럼
  최소 기능 단위로 나뉘어 있습니다.

판정: 일치

주의:

- Skill 수가 늘어나면 공식 문서의 초기 Skill 목록 context budget에 걸릴 수
  있으므로 description은 계속 짧고 명확하게 유지합니다.
- 라우터 Skill이 너무 자주 암시 호출되면 description을 더 제한하거나
  `agents/openai.yaml` policy를 조정할 수 있습니다.

### Codex App Server State

공식 문서 기준:

- Codex App Server는 `Thread`, `Turn`, `Item`을 핵심 primitive로 설명합니다.
- Thread는 대화 단위, Turn은 하나의 사용자 요청과 agent 작업 단위, Item은
  메시지, 명령, 파일 변경, 도구 호출 같은 입력/출력 단위입니다.
- Thread는 start/resume/fork할 수 있고, Turn은 start/steer/interrupt 흐름을
  갖습니다.

비교 결과:

- `docs/state.md`는 공식 primitive를 Tocking 작업 state의 참고 기준으로
  인용합니다.
- Tocking 내부의 product/work/runtime/domain/API state는 공식 primitive를
  대체하는 개념이 아니라 프로젝트 운영용 분류로 정의되어 있습니다.

판정: 일치

주의:

- Tocking 내부 state를 Codex App Server의 runtime protocol state처럼 표현하지
  않도록 계속 구분합니다.

### OpenAI Agents SDK State

공식 문서 기준:

- Agents SDK는 대화 state 관리 방식으로 manual conversation management,
  sessions, server-managed conversations를 설명합니다.
- server-managed conversations에는 `conversation_id`와 `previous_response_id`
  방식이 있습니다.
- `RunState`는 human-in-the-loop 재개를 위한 실행 상태 스냅샷 성격입니다.

비교 결과:

- `docs/state.md`는 `Sessions`, `conversation_id`, `previous_response_id`,
  `RunState`를 공식 state 기준으로 분리해 적었습니다.
- Tocking state 문서는 앱 내부 planning/work/runtime/domain/API state를 별도
  분류로 두며, 공식 SDK state와 혼동하지 않도록 운영 규칙을 포함합니다.

판정: 일치

### OpenAI Agents SDK Handoff

공식 문서 기준:

- handoff는 agent가 다른 전문 agent에게 작업을 위임하는 구조입니다.
- handoff는 LLM에게 tool처럼 표현됩니다.
- `handoff()`는 대상 agent, tool name/description override, `on_handoff`,
  `input_type`, `input_filter`, 활성화 여부 등을 지정할 수 있습니다.
- `input_type`은 handoff tool call의 argument schema이며, 다음 agent의 main
  input을 대체하거나 destination을 고르는 장치가 아닙니다.
- handoff가 일어나면 새 agent가 대화를 이어받으며, 필요하면 `input_filter`로
  전달 history를 조정할 수 있습니다.

비교 결과:

- `docs/state.md`는 handoff를 “다음 담당자/다음 Skill/다음 작업 단계가 이어받기
  위한 기록”으로 사용한다고 명시합니다.
- 공식 SDK handoff와 Tocking 내부 handoff 기록이 같은 구현 기능은 아니라는 점을
  운영 규칙에서 구분합니다.
- Tocking handoff 템플릿은 대상, 이유, 완료된 것, 남은 것, 필요한 입력, 관련
  파일, 관련 기획, 검증 상태, 제약을 포함해 다음 담당자가 이어받기 충분합니다.

판정: 일치

주의:

- 실제 Agents SDK 기반 agent orchestration을 구현할 때는 이 문서의 handoff
  기록 템플릿만으로 충분하지 않습니다. 그때는 SDK의 `handoff()`, `input_type`,
  `input_filter` 설계를 별도 구현 단위로 추가해야 합니다.

## 전체 판정

현재 Tocking 하네스는 공식 문서 기준과 충돌하지 않습니다.

가장 중요한 유지 규칙:

- `AGENTS.md`는 repository-level durable guidance로 유지합니다.
- Skill은 `.agents/skills/<name>/SKILL.md` 구조를 유지합니다.
- 각 Skill은 한 가지 책임만 갖게 유지합니다.
- 큰 기획과 작은 기획은 `docs/state.md` 기준으로 분리합니다.
- handoff는 공식 SDK 개념과 Tocking 내부 기록 개념을 혼동하지 않게 표시합니다.

## 다음 보완 후보

- 실제 앱 구조가 생성되면 `docs/state.md`의 runtime/domain/API state를 코드의
  상태 타입 또는 enum과 맞춰 갱신합니다.
- 실제 OpenAI API 호출 하네스를 만들 때 `integrate-tocking-api`에 Responses API
  또는 Agents SDK 중 어떤 표면을 쓰는지 명시합니다.
- 실제 multi-agent orchestration을 구현할 경우 `handoff()` 설계를 별도 작은
  기획으로 분리합니다.
