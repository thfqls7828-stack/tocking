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
4. MVVM 패턴에 맞춰 View와 ViewModel 책임을 분리한다.
5. 화면 상태는 Riverpod provider/ViewModel에서 노출하고, View는 상태를 구독해
   렌더링한다.
6. 화면 상태를 로딩, 빈 상태, 오류 상태, 정상 상태로 나누어 구현한다.
7. API 데이터는 주입 가능한 mock 또는 인터페이스로 받아 UI를 먼저 안정화한다.
8. 각 위젯 파일은 가능하면 300줄을 넘지 않도록 역할별로 나눈다. 다만 너무 잘게
   쪼개져 읽기 어려워지는 경우에는 응집도를 우선한다.
9. 구현 후 가능한 렌더링 검증 또는 브라우저 확인을 수행한다.
10. 공통화 후보와 검증 결과를 `AGENTS.md`에 남긴다.

## Boundaries

- API 클라이언트 구현은 `integrate-tocking-api`가 담당한다.
- 도메인 엔티티와 상태 규칙은 `model-tocking-domain`이 담당한다.
- 공통 토큰 추가는 `manage-tocking-core` 기준을 따른다.
- Riverpod provider와 ViewModel이 필요한 경우 프레젠테이션 계층에 두고, 도메인
  규칙을 ViewModel 안에 직접 묻어두지 않는다.
