---
name: manage-tocking-state
description: Tocking 프로젝트의 state와 handoff를 정리하는 스킬. 사용자가 state 정리, 작업 상태 기록, 큰 기획/작은 기획 분리, handoff 작성, 다음 Skill로 넘길 맥락 정리, 공식 문서 기반 state 규칙 갱신을 요청할 때 사용한다.
---

# Tocking State 관리

## Overview

Tocking의 제품 state, 작업 state, 앱 런타임 state, 도메인 state, API state,
handoff 기록을 정리한다. 구현을 직접 하기보다 다음 Skill이 이어받을 수 있는
상태와 경계를 명확히 남긴다.

## Workflow

1. `AGENTS.md`와 `docs/state.md`를 먼저 읽는다.
2. 요청이 큰 기획, 작은 기획, 작업 state, 앱 state, handoff 중 어디에 해당하는지
   분류한다.
3. 큰 기획은 제품 목표와 여러 작은 기획의 묶음으로 작성한다.
4. 작은 기획은 하나의 Skill이 처리할 수 있는 최소 기능 단위로 작성한다.
5. handoff가 필요하면 대상 Skill, 완료된 것, 남은 것, 검증 상태, 주의할 제약을
   명확히 쓴다.
6. state 규칙이 바뀌면 `docs/state.md`와 `AGENTS.md`를 함께 갱신한다.

## Boundaries

- UI 구현은 `build-tocking-ui`가 담당한다.
- API 연동은 `integrate-tocking-api`가 담당한다.
- 도메인 모델 구현은 `model-tocking-domain`이 담당한다.
- QA는 `qa-tocking-ui` 또는 `qa-tocking-api`가 담당한다.

이 Skill은 작업을 이어받기 위한 상태 정리와 handoff 명확화에 집중한다.
