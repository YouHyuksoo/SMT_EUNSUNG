# 설비별 작업 실적 저장 테이블 전환 (IP_PRODUCT_SENSOR_ACTUAL)

- 작성일: 2026-09-02
- 대상 화면: `OEE_EQUIP_WORK_RESULT` 설비별 작업 실적관리 (`/oee/equip-work-result`)
- 커밋: `6871e12` (전환) · `dee4f7e` (이관·폐기)

## 배경

실적을 `IP_PRODUCT_WORK_RESULT`에 저장하고 있었다. 이 테이블은 2026-08-24에 이 프로젝트가
만든 것으로, 은성 레거시 PL/SQL·뷰와 단절돼 있었다(참조 오브젝트 0개). 반면
`IP_PRODUCT_SENSOR_ACTUAL`은 레거시 생산실적 테이블이며 센서 수집 배치가 실제로 쓰고 있다.

## 사전 실측 (전환 전)

| 항목 | 값 |
|---|---|
| `IP_PRODUCT_WORK_RESULT` | 2건 (모두 2026-08-24 ADMIN 테스트) · PL/SQL 참조 **0개** |
| `IP_PRODUCT_SENSOR_ACTUAL` | ES_JSIDC 0건 / esh_mes 11건(운영 중, `ENTER_BY='SENSOR ACTUAL NEO'`) |
| 참조 오브젝트 | `F_GET_RUN_LINE_ACTUAL_QTY`, `P_INTERLOCK_SENSOR_ACTUAL(_NEO)` 등 6개 |
| PK | `RECEIPT_DATE + RECEIPT_SEQUENCE + ORGANIZATION_ID` (RUN_NO는 일반 컬럼 → 1:N) |
| 항번 시퀀스 | `SEQ_PRODUCT_SENSOR` |

`F_GET_RUN_LINE_ACTUAL_QTY`의 `IP_PRODUCT_SENSOR_ACTUAL` 조회 블록은 **주석 처리** 상태라
쓰기가 그 함수 결과를 바꾸지 않는 것을 확인했다.

## 컬럼 매핑

| 기존 `IP_PRODUCT_WORK_RESULT` | 신규 `IP_PRODUCT_SENSOR_ACTUAL` |
|---|---|
| `SEQ_NO` (PK, 작업지시별 01~99) | `RECEIPT_SEQUENCE` (PK, 항번) |
| — | `RECEIPT_DATE` = 등록일자 |
| `RESULT_QTY` | `PRODUCT_ACTUAL_QTY` |
| `RESULT_STATUS` WIP/DONE | `IS_LAST_YN` N/Y |
| `RUN_NO` · `ORGANIZATION_ID` | 동일 |
| `MACHINE_CODE` · `WORK_TIME` · `WORKER_NAME` · `WORKER_COUNT` | **신규 추가** |
| `WORKSTAGE_CODE` | 기존 컬럼 재사용 |
| 등록자·등록일·최종수정자·최종수정일 | 동일 |

## 확정 결정

| # | 항목 | 결정 | 근거 |
|---|---|---|---|
| 1 | 항번 채번 | 레거시 전역 시퀀스 `SEQ_PRODUCT_SENSOR.NEXTVAL` | 작업지시별 01·02로 매기면 PK가 `(RECEIPT_DATE, RECEIPT_SEQUENCE, ORG)`라 같은 등록시각의 다른 작업지시끼리 충돌한다. 센서 배치도 같은 시퀀스를 쓴다 |
| 2 | 신규 컬럼 | 4개만 추가 (`MACHINE_CODE`/`WORK_TIME`/`WORKER_NAME`/`WORKER_COUNT`) | 공정코드는 `WORKSTAGE_CODE`로 이미 존재 |
| 3 | 신규 컬럼 NULL 허용 | 허용 | 센서 배치는 채우지 않는다 |
| 4 | 화면 계약 | `seqNo`/`resultStatus`(WIP·DONE) 유지 | 서버가 `RECEIPT_SEQUENCE`·`IS_LAST_YN`로 변환. 프론트 무변경 |
| 5 | 이관 시 `RECEIPT_DATE` | 원본 `ENTER_DATE` 사용 | 이관 때문에 등록시각이 오늘로 바뀌면 안 된다 |
| 6 | 구 테이블 | `PURGE` 없이 `DROP` | 휴지통에 남아 `FLASHBACK` 복구 가능 |

## 적용 결과 (ES_JSIDC)

| 단계 | 결과 |
|---|---|
| DDL — 컬럼 추가 | 21 → **25컬럼** |
| 데이터 이관 | 건수 2 → 2, 실적수량 29,300 → 29,300 **일치** |
| 구 테이블 폐기 | `DROP` 완료, 휴지통 `BIN$koAumyN1TTaJP/V4de49KQ==$0` 복구가능=YES |
| 코드 | 엔티티 `ProductWorkResult` → `ProductSensorActual` 교체, 루트 엔티티 배열 포함 |

화면 왕복 검증에서 등록 1건·수정 1건이 정상 반영됐고, 같은 작업지시에 실적 2건이 쌓여
**1:N이 실제로 동작**하는 것을 확인했다.

## 산출물

```
apps/backend/src/migrations/2026-09-02_sensor_actual_work_columns.sql
apps/backend/src/migrations/2026-09-02_migrate_work_result_to_sensor_actual.sql
docs/sql/2026-09-02-IP_PRODUCT_WORK_RESULT-폐기전-스냅샷.sql
apps/backend/src/entities/product-sensor-actual.entity.ts
```

## 남은 과제

- **센서 실적과 수기 실적이 한 테이블에 섞인다.** 조회가 `RUN_NO` 기준이라 센서 배치 행도
  함께 나온다. 구분이 필요하면 `ACTUAL_TYPE`을 구분자로 쓰는 것이 자연스럽다(센서는 현재 `'N'`).
- `WORKER_NAME` 은 화면 왕복 검증에서 값이 들어간 사례가 아직 없다.
- 다른 사이트(`esh_mes`)에는 이 DDL이 적용되지 않았다.
