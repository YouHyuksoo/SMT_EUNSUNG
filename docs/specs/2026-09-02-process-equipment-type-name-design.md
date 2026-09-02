# 공정관리 배치 설비 유형 코드명 표시 설계

## 목적

공정관리 하단의 배치된 설비 목록에서 `IMCN_MACHINE.MACHINE_TYPE` 원시 코드 대신 `MACHINE TYPE` 공통코드명을 표시한다.

## 현재 문제

`ProcessEquipGrid`는 설비유형 셀에서 `ComCodeBadge`에 `EQUIP_TYPE`을 전달한다. 은성전장 설비유형의 실제 `ISYS_BASECODE.CODE_TYPE`은 `MACHINE TYPE`이므로 코드명을 찾지 못하고 원시 코드로 폴백한다.

## 설계

- `apps/frontend/src/app/(authenticated)/master/process/components/ProcessEquipGrid.tsx`의 설비유형 배지만 `groupCode="MACHINE TYPE"`으로 변경한다.
- 별도 API 호출, 로컬 코드 맵, 백엔드 응답 필드는 추가하지 않는다.
- 값이 없으면 기존처럼 `-`, 코드마스터에 없는 값은 `ComCodeBadge`의 기존 원시 코드 폴백을 유지한다.
- 상태와 사용여부 등 다른 컬럼 동작은 변경하지 않는다.

## 검증

- `apps/frontend/src/app/(authenticated)/master/process/process-equipment-type-name.eunsung.structure.test.mjs` 구조 테스트가 `ProcessEquipGrid` 안의 `MACHINE TYPE` 사용을 강제하고 같은 파일의 `EQUIP_TYPE` 사용을 금지한다.
- 테스트를 변경 전에 실행해 실패를 확인하고, 최소 구현 후 재실행한다.
- 프론트엔드 typecheck로 타입과 페이지 레지스트리를 검증한다.
