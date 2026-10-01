# 설비별 작업 실적 — 구 테이블 복원 + 센서 프로시저 연계

- 작성일: 2026-09-30
- 대상 화면: `OEE_EQUIP_WORK_RESULT` 설비별 작업 실적관리 (`/oee/equip-work-result`)
- 되돌리는 대상: 2026-09-02 전환 (`6871e12` 전환 · `dee4f7e` 이관·폐기, `docs/plans/2026-09-02-work-result-table-switch.md`)

## 배경

2026-09-02에 실적 저장을 `IP_PRODUCT_WORK_RESULT` → `IP_PRODUCT_SENSOR_ACTUAL`로 옮겼다.
레거시 PL/SQL과 연결하려는 의도였다. 이번에 그 위에 `P_INTERLOCK_SENSOR_ACTUAL_NEO`를
호출하도록 만들려 했으나, 프로시저 구조가 건별 이력 모델과 맞지 않았다.

프로시저(`neo.sql:270~352`)는 `IP_PRODUCT_SENSOR_ACTUAL`을 `(LINE_CODE, MODEL_NAME,
ORGANIZATION_ID)` 단위 **누적 행 1개**로 다룬다.

```sql
SELECT COUNT(*) INTO LVI_COUNT FROM IP_PRODUCT_SENSOR_ACTUAL
 WHERE LINE_CODE = LVS_LINE_CODE AND MODEL_NAME IN (...) 
   AND ORGANIZATION_ID = 1 AND IS_LAST_YN = 'Y';

IF NVL(LVI_COUNT,0) = 0 THEN
   INSERT ... (IS_LAST_YN='Y', RECEIPT_SEQUENCE = SEQ_PRODUCT_SENSOR.NEXTVAL)
ELSE
   UPDATE IP_PRODUCT_SENSOR_ACTUAL
      SET PRODUCT_ACTUAL_QTY = NVL(PRODUCT_ACTUAL_QTY,0) + (P_ACC_COUNT * lvl_carrier_qty),
          ORIGIN_COUNT = P_COUNT, ENTER_BY = 'SENSOR ACTUAL NEO', RUN_NO = LVS_RUN_NO
    WHERE LINE_CODE = LVS_LINE_CODE AND MODEL_NAME IN (...) AND ORGANIZATION_ID = 1;
END IF;
```

따라서 같은 테이블에 건별 수기 실적을 쌓으면 세 가지 문제가 생긴다.

1. 두 번째 등록부터 INSERT가 아니라 기존 행에 **가산**된다. 건별 이력이 만들어지지 않는다.
2. UPDATE 분기에 `IS_LAST_YN`·`RECEIPT_SEQUENCE` 한정이 없어 **같은 라인·모델의 기존 수기
   실적 행까지 전부** 수량이 가산되고 `RUN_NO`·`ENTER_BY`가 덮어씌워진다.
3. 새로 만든/고친 행을 특정할 수 없다. INSERT 분기는 `SEQ_PRODUCT_SENSOR.NEXTVAL`을
   `_ACTUAL`·`_TIME`·`_HOUR` 세 곳에서 각각 뽑으므로 호출 후 `CURRVAL`은 `_HOUR` 값이다.

## 방침

실적 이력 원장과 센서 누적을 분리한다.

- **실적 이력 원장** — `IP_PRODUCT_WORK_RESULT`를 복원해 건별로 관리한다. 이 테이블은
  `RUN_NO + SEQ_NO + ORGANIZATION_ID` PK에 `WORK_TIME`·`WORKER_COUNT`·`WORKER_NAME`·
  `RESULT_STATUS`를 모두 갖고 있어 화면 계약과 그대로 맞는다.
- **센서 누적** — 처리구분이 완료(`DONE`)가 되는 순간 `P_INTERLOCK_SENSOR_ACTUAL_NEO`를
  1회 호출한다. `IP_PRODUCT_SENSOR_ACTUAL`·`_TIME`·`_HOUR` 갱신은 프로시저에 맡긴다.

## 파라미터 매칭 (사용자 확정)

| 파라미터 | 값 | 근거 |
|---|---|---|
| `P_LINE_CODE` | 작업지시의 `LINE_CODE` | 설비의 `LINE_CODE`는 전부 `'*'`(미배정) |
| `P_WORKSTAGE_CODE` | 폼의 공정코드 | 직접 대응 |
| `P_MACHINE_CODE` | 폼의 설비코드 | 실적 행에는 안 남고 `P_INTERLOCK_SET_JIG`에만 전달된다 |
| `P_COUNT` | `1` 고정 | `neo.sql:291` `-- P_COUNT 는 계속 1 만 넘어와야 함` |
| `P_ACC_COUNT` | 완료 시점의 `RESULT_QTY` | 계수 개수로 그대로 전달 (사용자 확정) |
| `P_OUT` | `'OK'` 여부로 성패 판정 | `'OK'` 외에는 원문을 보존해 화면에 노출 |

`RUN_NO`는 프로시저가 `IP_PRODUCT_LINE`에서 라인의 현재 작업지시를 직접 읽는다. 팝업이 고른
작업지시와 다를 수 있으나 **라인 기준을 그대로 인정**하기로 확정했다.

## 확정 결정

| # | 항목 | 결정 | 근거 |
|---|---|---|---|
| 1 | 호출 시점 | 처리구분이 `DONE`일 때만 1회 | 완료된 실적은 앱이 수정 불가로 막으므로 재호출이 생기지 않는다 |
| 2 | `P_ACC_COUNT` | 완료 시점의 `RESULT_QTY` | 진행 중 수량이 바뀌어도 확정값만 반영된다 |
| 3 | 프로시저 실패 시 | 실적은 커밋하고 경고 문구 노출 | 활성 계획 없는 설비도 실적 등록은 되어야 한다 |
| 4 | 실패 표기 | 이력의 처리구분을 빨간색으로 | 미반영 실적을 목록에서 바로 식별한다 |
| 5 | 재시도 | '실적 이력' 타이틀 옆 `실적반영` 버튼 | 실패 건을 수동으로 다시 반영한다 |
| 6 | 반영 상태 저장 | 복원 테이블에 컬럼 2개 추가 | 빨간색 표기와 재호출 버튼이 둘 다 이 상태를 읽어야 한다 |
| 7 | `autoCommit` | `callProcScalar`에 옵션 추가 | 기본값 `false`라 그대로 쓰면 프로시저 쓰기가 롤백된다 |

### 추가 컬럼

| 컬럼 | 타입 | 의미 |
|---|---|---|
| `SENSOR_APPLY_YN` | `VARCHAR2(1) DEFAULT 'N'` | 프로시저 반영 성공 여부 |
| `SENSOR_APPLY_MSG` | `VARCHAR2(1000)` | 마지막 `P_OUT` 원문 |

진행(`WIP`)은 애초에 호출하지 않으므로 `'N'`이지만 실패가 아니다. 빨간색 조건은
`RESULT_STATUS = 'DONE' AND NVL(SENSOR_APPLY_YN,'N') <> 'Y'` 하나로 표현된다.

## 변경 범위

백엔드 `work-result` 모듈과 프론트 `WorkResultForm` 안에 갇힌다. 화면 계약
(`seqNo`·`resultStatus` WIP/DONE)은 원래 구 테이블 용어라 원복이 자연스럽다.

- `apps/backend/src/entities/product-work-result.entity.ts` — 복원 + 컬럼 2개
- `apps/backend/src/database/database.module.ts` — 엔티티 등록
- `apps/backend/src/modules/work-result/work-result.module.ts` — `forFeature` 교체
- `apps/backend/src/modules/work-result/work-result.service.ts` — 조회·저장 테이블 교체, 프로시저 호출, 재반영
- `apps/backend/src/modules/work-result/work-result.dto.ts` — 재반영 DTO
- `apps/backend/src/modules/work-result/work-result.controller.ts` — 재반영 엔드포인트
- `apps/backend/src/common/services/oracle.service.ts` — `callProcScalar` autoCommit 옵션
- `apps/frontend/src/components/shared/WorkResultForm.tsx` — 빨간색 표기, `실적반영` 버튼, 경고 노출
- `apps/backend/src/migrations/2026-09-30_restore_work_result.sql` — 복원 DDL

## 미결 항목

| 항목 | 상태 |
|---|---|
| DDL 적용 대상 | ES_JSIDC 1521 차단으로 접속 불가. es_mesi 적용 여부 미정 |
| ES_JSIDC 휴지통 | `BIN$koAumyN1TTaJP/V4de49KQ==$0` 생존 여부 미확인 (접속 불가) |
| 기존 수기 실적 역이관 | 2026-09-02 이후 `IP_PRODUCT_SENSOR_ACTUAL`에 직접 쌓인 건수 미실측 |
