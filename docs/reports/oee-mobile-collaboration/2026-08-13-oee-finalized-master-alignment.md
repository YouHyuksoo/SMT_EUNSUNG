# OEE 확정 기준정보 정합화 결과

- 작성일: 2026-08-13
- 작성 계기: 확정된 `IP_PRODUCT_LINE`, `IP_PRODUCT_WORKSTAGE`, `IMCN_MACHINE` 데이터와 다른 OEE 화면·API 수정
- 대상 DB: `EUNSUNG_DEV_ESDBPDB`, schema `INFINITY21_JSMES`

## 요약 (결론 먼저)

- OEE의 SMT 라인과 ASM 셀 기준정보를 모두 `IP_PRODUCT_LINE`으로 통일했다.
- ASM 셀 조회와 이벤트 처리에서 `PLANTS`, `2F`, `PROD2` 의존성을 제거했다.
- 설비명은 `IMCN_MACHINE`, 라인명은 `IP_PRODUCT_LINE`, 공정명은 `IP_PRODUCT_WORKSTAGE`에서 조회한다.
- 개발 DB의 OEE 리소스는 SMT 12건, ASM 15건이며 확정 라인 마스터와 차이가 0건이다.
- 기존 ASM 이벤트 한 건의 `PARENT_LINE_CODE='PROD2'`를 실제 `RESOURCE_CODE`로 이관했다.

## 상세

### 확정 데이터 분류

- SMT: `LINE_DIVISION='D'`, `LINE_CODE_GROUP='SMD'`, `MES_DISPLAY_YN='Y'` 12건
- ASM CELL: `LINE_DIVISION='L'`, `LINE_CODE_GROUP='ASM'` 15건
- `IP_PRODUCT_WORKSTAGE`: 조직 1 기준 11건
- `IMCN_MACHINE`: 조직 1 기준 140건

### 수정 화면 및 API

- `/oee/entry`
  - SMT와 ASM 모두 `IP_PRODUCT_LINE`에서 조회한다.
  - ASM 셀에 `PROD2`를 표시하거나 전송하지 않는다.
  - 이벤트 호환 컬럼 `parentLineCode`에는 실제 `resourceCode`를 사용한다.
- `/oee/dashboard/drilldown`
  - 리소스 코드·유형·명칭을 반환한다.
  - 명칭은 `OEE_RESOURCE` 복사값이 아니라 `IP_PRODUCT_LINE.LINE_NAME`을 직접 사용한다.
- `/oee/master/equip-reason-map` 및 공용 설비 API
  - 설비 목록에 `IP_PRODUCT_LINE.LINE_NAME`과 `IP_PRODUCT_WORKSTAGE.WORKSTAGE_NAME`을 조인한다.
- `/oee/equip-downtime-mobile`
  - `E01~E05` 샘플 설비를 제거했다.
  - 스캔·수동 입력 코드를 `/equipment/equips/code/:code`로 조회한다.
- `/oee/equip-work-result`, `/oee/equip-ops-analysis`
  - 확정 마스터와 무관한 샘플 행을 제거했다.
  - 실제 실적 API가 없으므로 가짜 데이터를 표시하지 않고 빈 상태를 유지한다.

### SQL 및 DB

- `09_seed_dashboard_resources.sql`은 `IP_PRODUCT_LINE`만 사용한다.
- 더 이상 유효하지 않은 `08_seed_production2_cells.sql`을 삭제했다.
- 적용 후 결과:
  - 활성 SMT LINE 12건
  - 활성 ASSY CELL 15건
  - 확정 마스터 대비 코드·명칭·분류 차이 0건
  - ASM 이벤트의 `PARENT_LINE_CODE <> RESOURCE_CODE` 0건
  - `V_OEE_PLAN_TIME`, `V_OEE_LIVE`, `P_OEE_BUILD_SUMMARY` 모두 `VALID`

### 검증

- backend focused Jest: 6 suites, 70 tests passed
- backend typecheck: passed
- frontend structure tests: 35 tests passed
- frontend typecheck: passed
- `git diff --check`: passed
- 드릴다운·설비 모바일·설비 작업실적·설비 운영분석 화면: HTTP 200
- ASSY 드릴다운 실제 응답: `RESOURCE_CODE=50`, `RESOURCE_NAME=CMA`, `RESOURCE_TYPE=CELL`

## 후속 조치

- 설비 작업실적·운영분석 화면에 실제 행을 표시하려면 확정된 작업지시·생산실적 API 계약이 추가로 필요하다. 그 전에는 잘못된 목업 대신 빈 상태를 유지한다.
- 기존 `PLANTS` 행은 다른 회사/사업장 기능에서 사용할 수 있어 이번 작업에서 삭제하지 않았다. OEE 코드와 SQL만 더 이상 참조하지 않는다.
