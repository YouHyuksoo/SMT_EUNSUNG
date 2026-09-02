---
sources:
  - apps/backend/src/entities/product-sensor-actual.entity.ts
  - apps/backend/src/modules/work-result/work-result.service.ts
  - apps/backend/src/migrations/2026-09-02_sensor_actual_work_columns.sql
  - apps/backend/src/migrations/2026-09-02_migrate_work_result_to_sensor_actual.sql
verifiedCommit: dee4f7e
---

# IP_PRODUCT_SENSOR_ACTUAL — 생산 실적

## 확인된 역할

은성 레거시 생산실적 테이블이다. 원래 센서 수집 배치(`P_INTERLOCK_SENSOR_ACTUAL_NEO`)가
라인별 실적을 자동으로 쌓는 용도였고, 2026-09-02부터 **설비별 작업 실적관리 화면의 수기
실적도 이 테이블에 저장**한다(기존 `IP_PRODUCT_WORK_RESULT`는 폐기).

## 키 구조

```
PK  RECEIPT_DATE + RECEIPT_SEQUENCE + ORGANIZATION_ID
    (제약이 아니라 UNIQUE 인덱스 XPKIP_PRODUCT_SENSOR_ACTUAL)
```

`RUN_NO`는 PK가 아닌 일반 컬럼이다. 따라서 **작업지시 1 : 실적 N** 이 성립한다.
`RECEIPT_SEQUENCE`는 전역 시퀀스 `SEQ_PRODUCT_SENSOR`로 채번하며 센서 배치와 공용이다.

## 주요 컬럼

| 컬럼 | 의미 |
|---|---|
| `RECEIPT_DATE` | 입고일자 — 수기 실적은 등록일자를 그대로 넣는다 |
| `RECEIPT_SEQUENCE` | 입고항번 = 실적 차수 항번 |
| `RUN_NO` | 작업지시번호 (`IP_PRODUCT_RUN_CARD`) |
| `PRODUCT_ACTUAL_QTY` | 실적수량 |
| `PRODUCT_ACTUAL_SUM` | 누적실적 (센서 배치가 관리) |
| `IS_LAST_YN` | 처리구분 — **Y=완료(수정불가), N=진행**. 화면에는 DONE/WIP로 변환해 준다 |
| `ACTUAL_TYPE` | 실적유형. 센서 배치는 `'N'`을 넣는다 |
| `LINE_CODE` · `WORKSTAGE_CODE` | 라인·공정 |
| `ORIGIN_COUNT` · `ADJUST_QTY` · `PRODUCT_ACTUAL_LOST_QTY` | 센서 집계 보조 |

### 2026-09-02 추가 — 수기 실적 전용

| 컬럼 | 의미 |
|---|---|
| `MACHINE_CODE` | 설비코드 (`IMCN_MACHINE`) |
| `WORK_TIME` | 작업시간(분) |
| `WORKER_NAME` | 작업자명 |
| `WORKER_COUNT` | 작업인원 |

센서 배치는 이 4개를 채우지 않으므로 NULL일 수 있다.

## 파생 테이블

`IP_PRODUCT_SENSOR_ACTUAL_HOUR` · `_TIME` 이 같은 21컬럼 구조로 존재한다(시간대별 집계).
2026-09-02 기준 ES_JSIDC에서는 둘 다 0건이다.

## 참조 오브젝트

```
FUNCTION   F_GET_RUN_LINE_ACTUAL_QTY        ← 해당 조회 블록은 주석 처리 상태
PROCEDURE  P_INTERLOCK_SENSOR_ACTUAL
PROCEDURE  P_INTERLOCK_SENSOR_ACTUAL_NEO    ← 센서 수집 배치(실제 사용)
PROCEDURE  P_INTERLOCK_RESET_LINE (_BAK/_SHS)
```

## 주의

- **센서 실적과 수기 실적이 한 테이블에 섞인다.** 화면 조회가 `RUN_NO` 기준이라 센서 배치가
  넣은 행도 함께 나온다. 구분이 필요하면 `ACTUAL_TYPE`을 구분자로 써야 한다.
- FK 제약이 없다. `RUN_NO`·`MACHINE_CODE`·`WORKSTAGE_CODE` 연결은 애플리케이션 규약이다.
- 사이트별로 데이터 유무가 다르다 — 2026-09-02 기준 ES_JSIDC 3건, esh_mes 11건(운영 중).
  신규 4개 컬럼 DDL은 ES_JSIDC에만 적용돼 있다.
