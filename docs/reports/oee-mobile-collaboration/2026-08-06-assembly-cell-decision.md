# OEE MOBILE 2층 조립 셀 기준 결정

- 작성일: 2026-08-06
- 작성 계기: Master가 2층 조립공정 OEE 입력 단위를 셀로 확정함
- 결정 상태: **승인됨**
- 적용 범위: OEE MOBILE 요구사항, 화면설계, 리소스·저장 계약

## 요약 (결론 먼저)

- 1층 SMT OEE 입력 단위는 **라인**이다.
- 2층 조립공정 OEE 입력 단위는 **셀**이다.
- 조립 라인을 셀 대신 입력 단위로 사용하는 fallback은 허용하지 않는다.
- 후공정 셀은 설비가 없어도 셀 자체를 OEE 리소스로 사용한다.
- 개발 DB에 셀 데이터가 없으므로 화면은 셀 기준으로 설계하되, 실제 구현·검증 전에 셀 기준정보를 확정하고 적재해야 한다.

## 상세

### 1. 결정 근거

Master 지시와 기존 계획이 일치한다.

| 근거 | 내용 |
|---|---|
| Master 결정 | 2층 조립공정은 셀 기준으로 OEE 입력 |
| `docs/plans/2026-07-10-inventory-oee-development-plan.md:421-424` | SMT는 라인 단위, 후공정은 셀 방식 |
| `docs/plans/2026-07-10-inventory-oee-development-plan.md:685-686` | SMT 라인·후공정 셀 관리 방향 동의 기록 |
| `docs/plans/2026-07-10-oee-master-data-development-plan.md:44-49` | `PLANTS` 조직트리를 라인/셀 SSOT로 하고 CELL 노드 자체를 OEE 리소스로 정의 |
| `docs/plans/2026-07-10-oee-master-data-development-plan.md:73-78` | SMT=LINE, 후공정=CELL이며 후공정 셀은 설비 매핑 없이 실적·무작업 귀속 |

### 2. 개발 DB 상태

- `PLANTS` 테이블은 존재하지만 현재 0건이다.
- 실제 `PLANTS`에는 `PLANT_CODE`, `SHOP_CODE`, `LINE_CODE`, `CELL_CODE`, `PLANT_TYPE` 계층 컬럼이 있다.
- 실제 DB에는 `COMPANY`, `PLANT_CD`가 필수 컬럼으로 존재한다.
- 코드의 `Plant` entity는 `ORGANIZATION_ID`를 기대하지만 실제 DB describe 결과에는 해당 컬럼이 없다.
- 따라서 현재 entity를 그대로 사용해 조립 CELL을 조회·저장하는 계약은 성립하지 않는다.
- `IP_PRODUCT_LINE`에는 조립 H/Y/A/D/B/K 라인이 있지만 셀 목록을 대신하지 않는다.

### 3. 화면설계 반영

조립 작업자는 다음 맥락을 확인해야 한다.

1. 작업자 사번 식별
2. 2층 조립공정 확인
3. 승인된 셀 선택 또는 셀 바코드 스캔
4. 선택 셀의 코드·명칭·상위 라인 확인
5. 해당 셀의 현재 OEE 상태와 진행 중 비가동 확인
6. 비가동 시작·사유·선택 메모·종료 입력

셀 기준정보가 비어 있으면 라인 입력으로 우회하지 않고 `등록된 조립 셀이 없습니다` 차단 상태를 표시한다.

### 4. 데이터 계약 선행조건

- 실제 2층 조립 셀 코드·명칭·상위 라인 목록 확정
- `PLANTS` 계층에서 사용할 `PLANT_CODE`, `SHOP_CODE`, `LINE_CODE`, `CELL_CODE` 값 확정
- `COMPANY`, `PLANT_CD` 필수값과 조직 격리 방식 확정
- `Plant` entity와 실제 DB 컬럼 불일치 해소
- 셀 바코드가 있다면 스캔 payload와 `CELL_CODE` 매핑 확정
- OEE 리소스가 CELL 노드를 직접 참조하는 키와 적용기간 확정
- 셀별 실적·비가동·근무시간 귀속 규칙 확정

## 후속 조치

1. `luna_planner`는 조립 화면을 CELL 기준으로 설계한다.
2. Coach는 셀 목록 미등록을 구현 blocker로 관리한다.
3. 실제 셀 목록을 받기 전에는 임의 `CELL01` 같은 코드를 생성하지 않는다.
4. `lunar_impl` Task에는 셀 기준정보 계약이 승인된 뒤 backend·frontend acceptance criteria를 포함한다.
