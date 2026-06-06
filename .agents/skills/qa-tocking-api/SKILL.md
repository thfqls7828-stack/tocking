---
name: qa-tocking-api
description: Tocking 앱의 API 연동과 데이터 경계를 검증하는 스킬. 사용자가 Naver/OpenAI API QA, DTO 검증, 오류 처리, 빈 응답, 속도 제한, 비밀값 노출, mock/fixture, repository 테스트, 하네스 재비교를 요청할 때 사용한다.
---

# Tocking API QA

## Overview

Naver와 OpenAI API 연동이 안전하고 예측 가능하게 동작하는지 검증한다. UI
레이아웃보다 데이터 경계, 실패 처리, 비밀값 노출 여부를 우선 확인한다.

## Checklist

- API 키와 비밀값이 코드, 로그, 클라이언트 번들에 노출되지 않는가
- 성공, 실패, 빈 응답, 지연, 속도 제한 경로가 처리되는가
- 외부 DTO와 도메인 모델이 분리되는가
- OpenAI 응답 구조 검증 또는 방어적 파싱이 있는가
- Naver 원본 데이터와 토론용 가공 데이터가 구분되는가
- mock 또는 fixture로 재현 가능한 테스트가 있는가

## Output

심각도 높은 API 문제, 테스트한 경로, 확인하지 못한 외부 조건, 수정 추천을
정리한다. 새 API 제약은 `AGENTS.md` 갱신 후보로 남긴다.
