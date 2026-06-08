---
name: manage-tocking-core
description: Tocking 앱의 core 공통 영역을 관리하는 스킬. 사용자가 테마, 색상, 타이포그래피, shadow, width, height, spacing, radius, 공통 컴포넌트, 공통 유틸리티, 클린 아키텍처 기반 공통 계층 정리를 요청할 때 사용한다.
---

# Tocking Core 관리

## Overview

Tocking의 공통 기반을 기능 화면과 분리해 관리한다. feature 구현은 하지 않고,
공통 토큰과 재사용 가능한 기반만 다룬다.

## Core Scope

- 앱 테마
- 색상과 타이포그래피
- shadow, width, height, spacing, radius 같은 디자인 토큰
- 공통 위젯 또는 컴포넌트
- 공통 유틸리티와 에러 타입
- 공통 네트워크/로깅 추상화의 인터페이스
- Riverpod provider 공통 패턴 또는 provider observer 같은 앱 공통 상태 관리
  기반

## Rules

- feature 화면 안에 중복 토큰을 만들지 않는다.
- 도메인 특화 규칙은 core에 넣지 않는다.
- feature 전용 ViewModel은 core에 넣지 않는다.
- UI 구현 중 공통화할 값이 2회 이상 반복되면 core 후보로 검토한다.
- core 변경은 영향 범위가 넓으므로 사용처와 검증 방법을 `AGENTS.md`에 남긴다.
