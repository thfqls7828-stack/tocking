---
name: integrate-tocking-api
description: Tocking 앱의 외부 API 연동을 구현하는 스킬. 사용자가 Naver 추천 주제 수집, OpenAI API 호출, API 클라이언트, DTO, repository 구현, 오류/속도 제한/빈 응답 처리, 환경변수, 비밀값 관리, data 또는 infrastructure 계층 구현을 요청할 때 사용한다.
---

# Tocking API 연동

## Overview

Naver 추천 주제와 OpenAI API 연동 경계를 구현한다. UI 구현과 도메인 모델 설계는
다른 스킬로 넘기고, 외부 시스템과 앱 내부 계층 사이의 안전한 연결만 다룬다.

## Workflow

1. `AGENTS.md`와 기존 API 설정을 확인한다.
2. 필요한 API가 Naver인지 OpenAI인지, 또는 둘 다인지 분리한다.
3. 비밀값은 환경변수나 안전한 설정 경로로만 다룬다.
4. 외부 응답 DTO와 도메인 모델 변환을 분리한다.
5. 성공, 실패, 빈 응답, 지연, 속도 제한을 처리한다.
6. mock 또는 fixture로 UI와 독립 검증이 가능하게 만든다.
7. 새 API 가정과 검증 방법을 `AGENTS.md`에 남긴다.

## Boundaries

- API 키를 코드에 하드코딩하지 않는다.
- OpenAI 생성 결과는 구조 검증 후 도메인으로 넘긴다.
- Naver 원본 데이터와 토론용 가공 데이터를 구분한다.
- UI 컴포넌트 구현은 `build-tocking-ui`가 담당한다.
