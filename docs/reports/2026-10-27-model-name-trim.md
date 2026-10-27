# 모델명 끝 공백 정리 기록 — 2026-10-27

## 배경

- 웹 계획 등록(`PlanFormPanel`, `SmtPlanDeployModal`)과 웹 조회는 모델명 앞뒤 공백을 자른다.
- ID_ITEM·모델 마스터에는 끝 공백이 붙은 모델명이 있어, 웹으로 넣은 계획이 마스터와 이어지지 않았다(예: `NE-EV-VOLT-SNSG-FRT-2P6S `).
- 사용자 결정: 기준정보 + 진행 데이터만 정리하고, 입출고·검사·백업 같은 과거 이력은 그대로 둔다.

## 대상 모델 (ESDBext, 실제값)

`'NE-EV-VOLT-SNSG-FRT-2P6S '`, `'NE-EV-CURRENT-SENSOR '`, `'SRM30-E    '`, `'SVM28-TT '`, `'PTM28-LX2-HSG-BRUSH CARD ASSY '`

## 적용 (2026-10-27 17:07:02 시작, 한 트랜잭션)

| 테이블 | 처리 | 행 |
|---|---|---|
| IP_PRODUCT_MODEL_MASTER | 공백 없는 이름으로 행 복사 추가 | 3 |
| IP_PRODUCT_MODEL_MASTER | 공백 있는 옛 행 DATEEND 9999-12-31 → 2026-10-26 | 3 |
| ID_ITEM | MODEL_NAME TRIM | 21 |
| ID_ENG_BOM_SMT | 〃 | 54 |
| IM_ITEM_SOLDER_MASTER | 〃 | 741 |
| IP_PRODUCT_ST_MASTER | 〃 | 1 |
| IP_PRODUCT_MODEL_ST_MASTER | 〃 | 2 |
| ISYS_LABEL_FORM | 〃 | 2 |
| IP_PRODUCT_LINE | 〃 | 1 |
| IP_PRODUCT_YEAR_BASE | 〃 | 3 |
| IP_PRODUCT_SMD_PLAN | 〃 | 388 |
| IP_PRODUCT_MI_PLAN | 〃 | 675 |
| IB_PRODUCT_PLANDATA | 〃 | 54 |
| IP_PRODUCT_RUN_CARD | 〃 | 1051 |
| IP_PRODUCT_RUN_CARD_INV | 〃 | 7 |
| IP_PRODUCT_FG_INVENTORY | 〃 | 13984 |
| IP_PRODUCT_FG_INV_CLOSE | 〃 | 2 |
| IP_PRODUCT_PACK_MASTER | 〃 | 13953 |
| IP_PRODUCT_SENSOR_ACTUAL | 〃 | 1 |

- 모델 마스터는 이름을 바꿀 수 없다: `IP_PRODUCT_2D_BARCODE` 가 FK(`FKIP_PRODUCT_2D_BARCODE`, MODEL_NAME+ORGANIZATION_ID)로 공백 있는 옛 이름을 참조한다. 그래서 옛 행은 남기고 종료 처리했다.
- 대상 테이블의 UPDATE 트리거는 모두 `UPDATE OF` 다른 칸이라 MODEL_NAME 변경에 반응하지 않는다.
- 먼저 롤백 모드로 시험 실행해 오류·키 충돌이 없음을 확인한 뒤 반영했다.

## 손대지 않은 것 (과거 이력)

IP_PRODUCT_FG_RECEIPT·FG_ISSUE, IP_PRODUCT_RUN_CARD_IO(_BACK), IP_PRODUCT_WORKSTAGE_IO, IP_PRODUCT_SENSOR_ACTUAL_TIME/HOUR/_BACK, IB_PRODUCT_PLANDATA_BACKUP, IM_ITEM_ISSUE(_LOSS), IMCN_JIG/SAMPLE_INPUT_HIST, IB_SMT_LINE_ONOFF_HISTORY, IQ_MACHINE_INSPECT_*, ID_ITEM_HISTORY, IP_PRODUCT_2D_BARCODE. 이 테이블들에는 공백 있는 이름이 남아 있어 모델별 과거 집계가 두 이름으로 나뉠 수 있다.

## 결과

- 계획(SMD·MI) 모델명 중 마스터에 없는 것: 80 → 78 (NE-EV-VOLT-SNSG-FRT-2P6S 해소). 남은 78건은 옛 모델·테스트 입력.
- ID_ITEM 모델명 앞뒤 공백: 21 → 0.

## 롤백

시작 전부터 공백 없는 이름이던 행의 ROWID 는 `2026-10-27-model-name-trim-pre-rowids.json` 의 `pre_trimmed_rowids` 에 있다. 테이블별로:

```sql
-- 예: IP_PRODUCT_RUN_CARD, 대상 모델 하나씩
UPDATE IP_PRODUCT_RUN_CARD SET MODEL_NAME = 'NE-EV-VOLT-SNSG-FRT-2P6S '
 WHERE MODEL_NAME = 'NE-EV-VOLT-SNSG-FRT-2P6S'
   AND ROWIDTOCHAR(ROWID) NOT IN (/* pre_trimmed_rowids.IP_PRODUCT_RUN_CARD */)
   AND ENTER_DATE < TO_DATE('2026-10-27 17:07:02','YYYY-MM-DD HH24:MI:SS');
-- 모델 마스터
UPDATE IP_PRODUCT_MODEL_MASTER SET DATEEND = DATE '9999-12-31'
 WHERE MODEL_NAME IN ('NE-EV-VOLT-SNSG-FRT-2P6S ','NE-EV-CURRENT-SENSOR ','SRM30-E    ');
DELETE FROM IP_PRODUCT_MODEL_MASTER
 WHERE MODEL_NAME IN ('NE-EV-VOLT-SNSG-FRT-2P6S','NE-EV-CURRENT-SENSOR','SRM30-E');  -- 이후 2D 바코드가 새 이름으로 쌓였으면 FK 로 막힌다
```
