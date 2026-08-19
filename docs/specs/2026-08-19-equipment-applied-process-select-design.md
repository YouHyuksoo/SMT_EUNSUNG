# 설비마스터 적용공정 선택 전환 설계

## 목적

설비마스터의 생산라인 필터와 등록·수정 항목을 공정마스터 기반의 `적용공정` 선택으로 전환한다. 콤보 항목은 `공정코드 | 공정명 | 공정유형 한글명` 형식으로 표시하고 선택값은 `IMCN_MACHINE.WORKSTAGE_CODE`에 저장한다.

## 현재 문제

- 설비마스터 상단 필터와 폼이 `LineSelect`를 사용하고 `lineCode`를 조회·저장한다.
- 공용 `ProcessSelect`의 데이터 원천도 `/equipment/equips/metadata/processes`여서 등록된 설비가 없으면 선택지가 사라진다.
- 공정마스터의 `processType`과 한글 유형명이 선택지에 표시되지 않는다.

## 설계

### 공정 선택 데이터

`useProcessOptions`는 `/master/processes?limit=5000`에서 공정마스터를 조회한다. 각 항목은 `processCode`, `processName`, `processType`을 포함한다. 기존 소비 화면에는 현재와 동일한 `공정코드 - 공정명` 옵션과 로딩 상태를 제공한다.

### 선택지 표시

공용 `ProcessSelect`에 선택적 `showProcessType` 속성을 추가한다.

- 기본값은 `false`로 두어 BOM·창고·라우팅 화면의 표시를 보존한다.
- `true`일 때 `WORKSTAGE TYPE` 공통코드 맵으로 `processType`을 한글명으로 변환한다.
- 설비마스터에서는 `공정코드 | 공정명 | 공정유형 한글명` 형식으로 표시한다.
- 유형 코드가 공통코드에 없으면 원시 `processType`을 대체 표시해 항목 자체가 사라지지 않게 한다.
- 필터의 `전체` 옵션은 기존 `labelPrefix` 동작을 유지한다.

### 설비마스터 계약

- 상단 상태 `lineFilter`를 `processFilter`로 변경한다.
- 상단 `LineSelect`를 `ProcessSelect showProcessType`으로 바꾸고 제목을 `적용공정`으로 표시한다.
- 조회 파라미터는 `lineCode`가 아니라 `processCode`를 전송한다.
- 폼 상태는 `lineCode` 대신 `processCode`를 사용한다.
- 편집 시 `equip.processCode`를 선택값으로 복원한다.
- 저장 body는 `processCode`를 전송하고 `lineCode`는 전송하지 않는다.
- 폼 라벨과 도움말은 `적용공정`, `IMCN_MACHINE.WORKSTAGE_CODE`로 변경한다.
- 설비 그리드의 기존 `공정` 컬럼 제목과 설비 화면 번역 키도 `적용공정`으로 변경한다.
- 기존 저장 검증, 이미지, 통신, BOM 패널 구성은 변경하지 않는다.

## 오류 및 빈 값 처리

- 공정마스터 조회 중에는 콤보를 비활성화한다.
- 공정이 없거나 조회가 실패하면 빈 선택지를 표시한다.
- 적용공정은 기존 라인 항목과 동일하게 선택 사항으로 유지하며, 빈 값은 `processCode` 미지정으로 저장한다.

## 테스트

- `useProcessOptions`가 공정마스터 API와 `processType`을 사용하고 설비 메타데이터 API에 의존하지 않는지 검증한다.
- `showProcessType` 선택지 생성에 여러 공정과 공통코드 맵을 넣어 `코드 | 명칭 | 한글 유형명` 동작을 검증한다.
- 기본 `ProcessSelect` 표시가 기존 형식을 유지하는지 검증한다.
- 설비마스터의 필터·폼·조회·저장·편집 복원이 모두 `processCode`로 연결되는지 검증한다.
- 상단 필터, 등록·수정 폼, 그리드 컬럼 제목이 모두 `적용공정`인지 검증한다.
- `LineSelect`, `lineFilter`, 폼 `lineCode`가 해당 흐름에 남지 않는지 검증한다.
- 대상 테스트, 프론트 전체 테스트, 프론트 typecheck를 실행한다.

## 비범위

- 기존 DB 행의 `LINE_CODE`를 `WORKSTAGE_CODE`로 마이그레이션
- 다른 화면의 공정 콤보 표시 형식 변경
- 공정마스터 CRUD 및 공정유형 공통코드 변경
