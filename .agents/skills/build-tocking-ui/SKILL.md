---
name: build-tocking-ui
description: Tocking 앱의 UI 화면과 컴포넌트를 구현하는 스킬. 사용자가 프론트엔드 화면, 컴포넌트, 레이아웃, 반응형 UI, 토론 주제 목록, 토론 상세 화면, 입력 폼, 로딩/빈/오류 상태 구현을 요청할 때 사용한다.
---

# Tocking UI 구현

## Overview

Tocking의 화면과 컴포넌트를 구현한다. API 호출 구현과 도메인 모델 설계는
다른 스킬로 넘기고, UI 계층의 최소 기능을 보장한다.

## Workflow

1. `AGENTS.md`와 필요한 UI 디자인 산출물을 확인한다.
2. 기존 프레임워크와 컴포넌트 구조를 읽는다.
3. theme, shadow, width, height, spacing, radius 값은 `core` 재사용을 우선한다.
4. 화면 상태를 로딩, 빈 상태, 오류 상태, 정상 상태로 나누어 구현한다.
5. API 데이터는 주입 가능한 mock 또는 인터페이스로 받아 UI를 먼저 안정화한다.
6. 구현 후 가능한 렌더링 검증 또는 브라우저 확인을 수행한다.
7. 공통화 후보와 검증 결과를 `AGENTS.md`에 남긴다.

## Boundaries

- API 클라이언트 구현은 `integrate-tocking-api`가 담당한다.
- 도메인 엔티티와 상태 규칙은 `model-tocking-domain`이 담당한다.
- 공통 토큰 추가는 `manage-tocking-core` 기준을 따른다.
