---
name: qa-tocking
description: Tocking QA 요청을 세분 스킬로 나누어 진행하도록 안내하는 스킬. 사용자가 넓은 범위의 QA, 출시 전 점검, 하네스 재비교를 요청했지만 UI QA와 API QA 중 어느 영역인지 불명확할 때 사용한다.
---

# Tocking QA

## Routing

- 화면, 반응형 레이아웃, 토론 UX, 접근성, 상태 표현은 `qa-tocking-ui`를 사용한다.
- Naver/OpenAI API, DTO, 실패 처리, 비밀값 노출, fixture 검증은 `qa-tocking-api`를 사용한다.

QA 결과에서 반복 규칙이 드러나면 `AGENTS.md` 갱신 후보로 남긴다.
