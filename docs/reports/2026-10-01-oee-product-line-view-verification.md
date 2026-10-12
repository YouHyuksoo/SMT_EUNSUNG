# OEE 제품 라인 뷰 적용 및 미완료 화면 검증

- 작성일: 2026-10-01
- 작성 계기: OEE 공통 라인 조회를 `V_OEE_PRODUCT_LINE`으로 전환하고 실제 Oracle 적용 결과와 남은 검증을 기록한다.

## 요약 (결론 먼저)

- `ESFA_EXTDB`에 `V_OEE_PRODUCT_LINE`을 두 번 적용했고 두 실행 모두 성공했다.
- 뷰는 `VALID`이며 `USER_ERRORS` 오류가 없다.
- 현재 뷰 36건과 동일 조건의 `IP_PRODUCT_LINE` 36건이 일치한다.
- `SORT_ORDER`는 `MES_DISPLAY_SEQUENCE`의 별칭이며 Oracle에서 `UPDATABLE=YES`로 확인했다.
- 백엔드 테스트·타입 검사와 프론트 테스트·타입 검사는 통과했다.
- 백엔드 3003과 프론트 3100이 모두 기동되지 않아 인증 API와 렌더 화면 검증은 수행하지 못했다.

## 상세

- 뷰 필터: `PROCESS_CODE IN ('SMT','ASSY')`, `RESOURCE_TYPE IN ('LINE','CELL')`, `LINE_CODE/LINE_NAME IS NOT NULL`
- 현재 분포: SMT 12건, ASSY 24건
- 활성/표시값을 조회 필터에 사용하지 않아 `ACTIVE_YN='N'` 또는 `NULL`, `MES_DISPLAY_YN='N'`인 행도 포함된다.
- `(ORGANIZATION_ID, LINE_CODE)` 중복은 0건이다.
- base-minus-view 비교 결과는 0건이다.
- `SORT_ORDER` 정렬은 `NULLS LAST`, 이후 `LINE_CODE` 순이다.

## 후속 조치

1. 사용자가 백엔드 3003과 프론트 3100 개발 서버를 기동한다.
2. 인증된 `GET /oee/mobile/resources?processCode=SMT`와 `ASSY` 응답을 확인한다.
3. `/oee/multi-entry`와 `/oee/result-entry`에서 실제 라인 순서, 선택, 상태 조회와 행 렌더링을 확인한다.
4. START/END는 테스트 데이터에 영향을 주므로 승인된 검증 대상과 시간대에서만 실행한다.
