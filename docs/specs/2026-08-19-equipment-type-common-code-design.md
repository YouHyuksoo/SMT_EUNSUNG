# 설비유형 공통코드 선택지 전환 설계

## 목적

설비마스터의 유형 필터와 등록·수정 콤보박스가 등록된 설비 데이터가 아니라 `ISYS_BASECODE`의 `MACHINE TYPE` 공통코드를 사용하도록 변경한다. 설비가 0건이어도 현재 등록된 9개 유형을 모두 선택할 수 있어야 한다.

## 현재 문제

- `useEquipTypeOptions`는 `/equipment/equips/metadata/types`를 호출한다.
- 백엔드 응답은 `IMCN_MACHINE.MACHINE_TYPE`의 실제 등록값을 집계한다.
- 설비 전체 삭제 후 응답이 빈 배열이 된다.
- 등록 폼은 빈 배열일 때 초기값 `TEMP`를 예비 옵션으로 만들어 `TEMP` 하나만 표시한다.

## 설계

### 데이터 흐름

`useEquipTypeOptions`의 외부 반환 계약(`options`, `isLoading`)은 유지하되 내부 데이터 원천을 공통코드 전체 조회 훅으로 바꾼다.

1. `useComCodes()`가 `/master/com-codes/all-active`를 조회한다.
2. `resolveComCodeGroup`으로 공백 표기 차이를 허용하면서 `MACHINE TYPE` 그룹을 찾는다.
3. 각 항목을 `{ value: detailCode, label: "코드 - 명칭" }` 형태로 변환한다.
4. 기존 React Query 캐시를 공유하여 중복 네트워크 요청을 만들지 않는다.

### 화면 동작

- 필터 콤보와 등록·수정 콤보 모두 같은 공통코드 옵션을 사용한다.
- 신규 폼의 `equipType` 기본값은 `TEMP`에서 빈 문자열로 변경한다.
- 공통코드가 로딩 중이거나 비어 있을 때 임의의 `TEMP` 옵션을 만들지 않는다.
- 필수값 검증은 기존대로 빈 유형에서 저장 버튼을 비활성화한다.
- 백엔드 메타데이터 API는 이번 변경에서 제거하지 않는다. 다른 잠재 소비자와의 호환성을 보존하되 설비마스터 화면에서는 더 이상 호출하지 않는다.

## 오류 처리

- 공통코드 조회 실패 시 옵션은 빈 배열로 유지한다.
- 존재하지 않는 예비 코드를 표시하지 않는다.
- 사용자는 유형을 선택하기 전까지 저장할 수 없다.

## 테스트

구조 회귀 테스트로 다음을 검증한다.

- `useEquipTypeOptions`가 `MACHINE TYPE` 공통코드를 사용한다.
- 기존 `/equipment/equips/metadata/types`에 의존하지 않는다.
- 신규 폼 기본값과 빈 목록 예비 옵션에 `TEMP`가 남아 있지 않다.
- 필터와 등록 폼이 동일한 `equipTypeOptions`를 계속 사용한다.

검증 명령은 대상 구조 테스트, 프론트 전체 구조 테스트, 프론트 typecheck 순으로 실행한다.

## 비범위

- `MACHINE TYPE` 데이터 자체의 추가·수정·삭제
- 백엔드 메타데이터 API 제거
- 설비 등록 폼의 다른 필드나 레이아웃 변경
