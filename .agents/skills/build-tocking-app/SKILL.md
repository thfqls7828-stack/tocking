---
name: build-tocking-app
description: Tocking 앱 개발 요청을 세분 스킬로 나누어 진행하도록 안내하는 스킬. 사용자가 넓은 범위의 앱 개발, 기능 구현, 하네스 구현을 요청했지만 UI/API/core/domain 중 어느 영역인지 불명확할 때 사용한다.
---

# Tocking 앱 개발

## Routing

- UI 화면과 컴포넌트 구현은 `build-tocking-ui`를 사용한다.
- Naver/OpenAI API, DTO, repository, 외부 연동은 `integrate-tocking-api`를 사용한다.
- 도메인 엔티티, 유스케이스, 상태 전이는 `model-tocking-domain`을 사용한다.
- 공통 theme, shadow, width, height, spacing, radius, 유틸리티는 `manage-tocking-core`를 사용한다.

## Development Rules

- Flutter 상태 관리는 Riverpod을 사용한다.
- 프레젠테이션 계층은 MVVM 패턴을 따른다.
- View는 렌더링과 사용자 입력 전달에 집중한다.
- ViewModel은 Riverpod provider로 상태와 액션을 노출한다.
- Model은 도메인 엔티티와 DTO/data model을 구분한다.
- 각 기능과 위젯은 최소 기능 단위를 기준으로 작게 유지하고, 가능하면 파일당
  300줄을 넘지 않도록 나눈다. 단, 응집도와 가독성을 해치며 무리하게 줄이지는
  않는다.

각 작업은 최소 기능 단위로 수행하고, 구현 결정과 검증 결과는 `AGENTS.md`에 남긴다.
