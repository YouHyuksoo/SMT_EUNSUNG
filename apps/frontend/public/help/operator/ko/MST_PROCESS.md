---
menuCode: MST_PROCESS
audience: operator
title: 공정마스터 — 운영 가이드
summary: 공정마스터(IP_PRODUCT_WORKSTAGE) 전체 컬럼의 DB 매핑, 설비 배치(IMCN_MACHINE.WORKSTAGE_CODE) 방식, CRUD/배치 API, 공통코드 연계, 권한, 트러블슈팅
tags: [기준정보, 공정, 마스터, 운영, 설비배치]
keywords: [IP_PRODUCT_WORKSTAGE, IMCN_MACHINE, WORKSTAGE_CODE, WORKSTAGE TYPE, WORKSTAGE CODE GROUP, WORKSTAGE START YN, WORKSTAGE STATUS, BAD RATE CONTROL, ISYS_BASECODE, 공정코드, 설비배치, 멀티테넌시, ORGANIZATION_ID]
related: [MST_PART]
---

# 공정마스터 — 운영 가이드

## 시스템 목적·역할
생산 공정의 기준정보를 보유하는 **마스터 테이블 `IP_PRODUCT_WORKSTAGE`** 관리 화면입니다. 라우팅·생산실적·공정 CAPA가 `WORKSTAGE_CODE`로 이 마스터를 참조합니다. 레거시 PowerBuilder 화면 `d_pln_workstage_mst`가 다루던 필드를 그대로 노출합니다.

## 데이터 구조
```
IP_PRODUCT_WORKSTAGE (PK: WORKSTAGE_CODE, ORGANIZATION_ID)
   ▲
   │ WORKSTAGE_CODE  (설비가 소속 공정을 가리킴 — 중간 테이블 없음)
   │
IMCN_MACHINE (PK: MACHINE_CODE, ORGANIZATION_ID)   ── 오른쪽 그리드 표시값 출처
```

- **공정 1 : 설비 N.** 설비는 한 공정에만 속합니다.
- 배치 = `IMCN_MACHINE.WORKSTAGE_CODE`를 해당 공정 코드로 `UPDATE`.
- 배치 해제 = `WORKSTAGE_CODE`를 미배치 관례값 **`'*'`** 로 되돌림. 설비 행은 삭제하지 않습니다.
- 백엔드 엔티티는 하위호환을 위해 프로퍼티명 `processCode` / `processName` / `processType` / `sortOrder`를 유지합니다(`ProcessMaster` 클래스). 라우팅·SPC·작업지시 등이 이 이름을 참조합니다.
- `EquipMaster` 엔티티는 `IMCN_MACHINE.WORKSTAGE_CODE`를 `processCode`로 매핑합니다.

## ① 공정 — IP_PRODUCT_WORKSTAGE (화면 노출 컬럼)

### 기본 정보

| 화면 항목 | DB 컬럼 | 역할 / 의미 · 운영 포인트 |
|------|------|------|
| 공정코드 | `WORKSTAGE_CODE` | PK 구성(자연키, varchar2 10). 불변 — 라우팅/실적/CAPA가 이 코드로 연결. 수정 폼 비활성. 중복 시 409 ConflictException. |
| 공정명 | `WORKSTAGE_NAME` | 표시명(varchar2 100). NOT NULL. |
| 공정유형 | `WORKSTAGE_TYPE` | 공통코드 `WORKSTAGE TYPE` — **I=일반공정 / L=최종공정 / Q=검사공정**. NOT NULL, DEFAULT `'I'`. `processType` 인덱스 존재. |
| 정렬순서 | `WORKSTAGE_SORT_ORDER` | 목록 정렬 기준(ASC). NOT NULL, `Min(0)` 정수. |
| 시작공정 | `WORKSTAGE_START_YN` | 공통코드 `WORKSTAGE START YN`. DEFAULT `'N'`. |
| 공정그룹 | `WORKSTAGE_CODE_GROUP` | 공통코드 `WORKSTAGE CODE GROUP` — SMT/PBA/PACKING/REPAIR/WAREHOUSE. 목록 다중 필터. |
| 공정상태 | `WORKSTAGE_STATUS` | 공통코드 `WORKSTAGE STATUS`(S=작업중, P=정지, R=수리, A=설비고장 …). nullable. |
| 라인코드 | `LINE_CODE` | 공통코드 `LINE CODE`. NOT NULL, DEFAULT `'*'`(라인 무관). |
| 부서 | `DEPARTMENT_CODE` | 공통코드 `DEPARTMENT CODE`. DEFAULT `'1100'`. |
| 교대 | `SHIFT_CODE` | 공통코드 `SHIFT CODE`(A=1교대, B=2교대). |
| 대표설비 | `MACHINE_CODE` | `IMCN_MACHINE.MACHINE_CODE` 참조. 배치 설비 목록과 **별개** — 실적 집계 기준 설비 1대. |
| 코스트센터 | `COST_CENTER_CODE` | 원가 집계 단위. 공통코드 없음 → 자유 입력. |
| 디스플레이 그룹 | `MES_DISPLAY_GROUP` | 모니터링 화면 묶음. DEFAULT `'*'`. 공통코드 없음 → 자유 입력. |
| PLC 주소 | `ACTUAL_PLC_ADDRESS` | 실적 수집 PLC 주소(varchar2 10). |

### 생산능력 / 표준시간

| 화면 항목 | DB 컬럼 |
|------|------|
| UPH | `UPH_VALUE` |
| 표준수량 | `STANDARD_QTY` |
| 생산능력 / 능력단위 | `CAPACITY` / `CAPACITY_UOM` (공통코드 `CAPACITY UOM` — ST, KG) |
| 가동률(%) | `USE_RATE` |
| 작업효율(%) / 설비효율(%) | `WORKING_EFFICIENCY` / `MACHINE_EFFICIENCY` |
| 작업자수 / 설비대수 | `WORKSTAGE_WORKER_QTY` / `WORKSTAGE_MACHINE_QTY` |
| 정상시간(ST) / 초과시간(OT) | `ST_VALUE` / `OT_VALUE` |
| 작업자시간 / 설비시간 | `WORKSTAGE_WORKER_WORK_TIME` / `WORKSTAGE_MACHINE_WORK_TIME` |
| 준비 / 대기 / 이동 시간 | `WORKSTAGE_PREPARE_TIME` / `WORKSTAGE_WAIT_TIME` / `WORKSTAGE_MOVE_TIME` |
| 총작업시간 | `TOTAL_WORK_TIME` |

### 원가 / 불량·기타

| 화면 항목 | DB 컬럼 | 비고 |
|------|------|------|
| 임률 / 경비율 / 기계경비율 | `WAGE_RATE` / `EXPENSE_RATE` / `MACHINERY_RATE` | |
| 조립비 반영 | `ASSY_EXP_YN` | 공통코드 `ASSY EXP YN` |
| 불량률 통제 | `BAD_RATE_CONTROL` | 공통코드 `BAD RATE CONTROL` — Y=불량통제함, N=통제안함 |
| 최대 불량률(%) | `BAD_MAX_RATE` | 불량률 통제=Y일 때만 의미 |
| 불량수량 추출 | `BAD_QTY_EXTRACT_YN` | **공통코드 없음** → 화면에서 Y/N 셀렉트로 처리 |
| 반제품 생성 | `GEN_SUB_MFS_YN` | 공통코드 `GEN SUB MFS YN` |

### 집계 / 감사 / 테넌시

| 화면 항목 | DB 컬럼 | 비고 |
|------|------|------|
| 설비수 | (집계) | DB 컬럼 아님. `GET /master/processes/equipment-counts`가 `IMCN_MACHINE`을 `WORKSTAGE_CODE`로 GROUP BY COUNT 한 값. `'*'` 및 NULL은 제외. |
| 감사 | `ENTER_BY`, `ENTER_DATE`, `LAST_MODIFY_BY`, `LAST_MODIFY_DATE` | 생성/수정 이력 |
| 멀티테넌시 | `ORGANIZATION_ID` | PK 구성. 모든 조회/변경에 스코프 적용 |

> **화면에 노출하지 않는 컬럼**: `ACTION_DATE`, `MES_DISPLAY_SEQUENCE`. 레거시 PB 화면에도 없던 항목이라 그대로 둡니다.
>
> **테이블에 없는 필드**: `USE_YN`, `REMARK`, `LINE_TYPE`(LV/HV/CM). 현재 모델에 없는 필드로 화면에서 제거되었습니다.

## ② 배치 설비 표시값 — IMCN_MACHINE (오른쪽 그리드, 읽기 전용)

> `findEquipments`가 `IMCN_MACHINE`에서 `WORKSTAGE_CODE = :processCode`로 직접 조회합니다. 값 편집은 설비마스터에서 합니다.

| 화면 항목 | DB 컬럼 | 역할 / 의미 |
|------|------|------|
| 설비코드 | `MACHINE_CODE` | 설비 식별 코드. |
| 설비명 | `MACHINE_NAME` | 설비명. |
| 설비유형 | `MACHINE_TYPE` | 공통코드 `EQUIP_TYPE`. nullable → 화면 `-`. |
| 모델명 | `MACHINE_MODEL_NAME` | nullable → `-`. |
| 제조사 | `SUPPLIER_CODE` | nullable → `-`. |
| 라인코드 | `LINE_CODE` | nullable → `-`. |
| 상태 | `MACHINE_STATUS_CODE` | 공통코드 `EQUIP_STATUS`. |
| 사용여부 | `MES_DISPLAY_YN` | 배치 후보는 `Y`인 설비만(`GET /equipment/equips?useYn=Y`). |

## API 엔드포인트
- `GET /master/processes` — 공정 목록(페이징·`search`·`processType`·`codeGroup`·`lineCode` 필터). 정렬: `WORKSTAGE_SORT_ORDER` ASC, `WORKSTAGE_CODE` ASC.
- `GET /master/processes/equipment-counts` — 공정별 배치 설비수(`IMCN_MACHINE` GROUP BY, `'*'`/NULL 제외).
- `GET /master/processes/:id` — 공정 상세.
- `POST /master/processes` — 생성(코드 중복 시 409).
- `PUT /master/processes/:id` — 수정(부분 업데이트, `WORKSTAGE_CODE` 불변). 서비스의 `UPDATABLE_FIELDS` 화이트리스트에 없는 필드는 무시.
- `DELETE /master/processes/:id` — 삭제(**하드 삭제**). 배치 설비의 `WORKSTAGE_CODE`는 자동 정리되지 않으므로 삭제 전 배치를 해제할 것.
- `GET /master/processes/:id/equipments` — 배치 설비 목록.
- `POST /master/processes/:id/equipments` (body `equipCode`) — 설비 배치. **다른 공정에 배치된 설비면 이 공정으로 이동**. 미존재 설비 404, 같은 공정에 이미 배치 시 409.
- `DELETE /master/processes/:id/equipments/:equipCode` — 배치 해제(`WORKSTAGE_CODE = '*'` UPDATE).

## 사전 설정 (마스터·공통코드)
- 공통코드(`ISYS_BASECODE.CODE_TYPE`, **공백 포함 표기 그대로**): `WORKSTAGE TYPE`, `WORKSTAGE CODE GROUP`, `WORKSTAGE START YN`, `WORKSTAGE STATUS`, `LINE CODE`, `DEPARTMENT CODE`, `SHIFT CODE`, `CAPACITY UOM`, `BAD RATE CONTROL`, `ASSY EXP YN`, `GEN SUB MFS YN`. 설비 표시용 `EQUIP_TYPE`·`EQUIP_STATUS`.
- 설비 배치 전 **설비마스터(IMCN_MACHINE)에 설비가 등록·`MES_DISPLAY_YN='Y'`** 상태여야 후보로 나옵니다.

## 운영 절차
1. 공통코드 선등록(위 목록).
2. 공정 등록 — 코드·명·유형·정렬순서 필수. 생산 흐름 순서대로 `WORKSTAGE_SORT_ORDER` 부여.
3. 시작 공정에 `WORKSTAGE_START_YN='Y'` 지정.
4. 공정 선택 후 설비 배치 — 사용 중인 설비만 셀렉트에 노출.

## 권한
기준정보 관리자(공정 등록/수정/삭제, 설비 배치/해제). 일반 사용자는 조회.

## 문제 해결 (트러블슈팅)
| 증상 | 원인 | 조치 |
|------|------|------|
| 저장 시 코드 중복 오류(409) | 동일 `WORKSTAGE_CODE` 존재 | 코드 변경(불변 키, 중복 불가) |
| 저장이 안 됨(필수 미입력) | `processCode`/`processName`/`processType`/`sortOrder` 누락 | 4개 필수값 입력 후 저장 |
| 설비 배치 시 "이미 배치된 설비"(409) | **같은 공정**에 이미 배치됨 | 중복 배치 불가(셀렉트에서 자동 제외) |
| 설비를 배치했더니 다른 공정에서 사라짐 | 설비는 공정 1개에만 속함 — 이동이 정상 동작 | 의도한 동작. 이전 공정 설비수가 1 감소 |
| 설비 배치 시 설비 못 찾음(404) | `MACHINE_CODE`가 `IMCN_MACHINE`에 없음 | 설비마스터 등록 확인 |
| 셀렉트에 설비가 없음 | 후보 설비 `MES_DISPLAY_YN='N'` 또는 이미 이 공정에 전량 배치 | 설비마스터에서 사용여부 Y 확인 |
| 설비수 배지가 0인데 설비가 있음 | 설비의 `WORKSTAGE_CODE`가 `'*'` 또는 NULL | 설비 배치 재수행 |
| 공정 삭제 후에도 설비가 그 코드를 가리킴 | 배치는 CASCADE 되지 않음 | 삭제 전 배치 해제. 이미 삭제했다면 설비마스터에서 `WORKSTAGE_CODE` 정리 |

## 데이터·연계
- 테이블: `IP_PRODUCT_WORKSTAGE`(마스터), `IMCN_MACHINE`(배치 대상·표시 출처), `ISYS_BASECODE`(공통코드)
- 연계: 라우팅, 생산실적, 공정 CAPA — `WORKSTAGE_CODE` 참조
- 스코프: `ORGANIZATION_ID`
