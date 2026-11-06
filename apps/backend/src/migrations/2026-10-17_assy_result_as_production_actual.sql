-- =====================================================================
-- 2026-10-17 생산실적 원천을 센서실적 → 조립실적(IP_ASSEMBLY_RESULT)으로 바꾼다
--
-- 설계: docs/specs/2026-10-17-wip-semi-product-from-aoi-design.md
-- 사용자 지시: "기존에 sensor_actual 을 사용하던 실적을 assembly_result 로 전환",
--              "조립실적 보정 기능을 따로 만들어야지 당연히 수기도 조립실적에 넣어야함"
-- 구성
--   IP_ASSEMBLY_RESULT.TIME_DIVISION   시간대 A~J (F_GET_WORKTIME_ZONE, 센서실적과 같은 구분)
--   IP_ASSEMBLY_RESULT.REMARK          수기: 작업실적 키 / 보정: 사유
--   ENTER_BY  AOI_JOB = AOI 실시간, WORK_RESULT = 수기 작업실적, ASSY_ADJUST = 보정
--   IP_PRODUCT_MODEL_MASTER.PCB_TOTAL_QTY  AOI PID 1개 수량. 어레이 판 하나에 PID 하나인 모델(캐리어 42) = 42
--   IP_ASSEMBLY_RESULT_SENSOR_V        조립실적을 센서 시간대 테이블과 같은 모양으로 보여준다
--   IP_ASSEMBLY_ACTUAL_TIME_V · _DAY_V · _MONTH_V · IP_PRODUCT_ACTUAL_MONTH_V
--                                      센서 시간대 테이블 대신 위 뷰를 읽는다 (원본 정의: docs/sql/sensor-actual-views-before-2026-10-17.sql)
--   TRG_IM_WS_RECEIPT_INFAC            수기·보정 반제품 공정입고(ASSY_MANUAL·ASSY_ADJ)도 인팩 전송용에서 뺀다
-- 프로시저 (oracle_db_scripts): P_ASSY_RESULT_ADD (신규), P_ASSY_RESULT_ADD_PID
-- =====================================================================
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE IP_ASSEMBLY_RESULT ADD (TIME_DIVISION VARCHAR2(1), REMARK VARCHAR2(200))';
  EXECUTE IMMEDIATE q'[COMMENT ON COLUMN IP_ASSEMBLY_RESULT.TIME_DIVISION IS '시간대 A~J (F_GET_WORKTIME_ZONE)']';
  EXECUTE IMMEDIATE q'[COMMENT ON COLUMN IP_ASSEMBLY_RESULT.REMARK IS '수기 작업실적 키 또는 보정 사유']';
  EXECUTE IMMEDIATE q'[COMMENT ON COLUMN IP_PRODUCT_MODEL_MASTER.PCB_TOTAL_QTY IS 'AOI PID 1개 수량 (어레이 판 하나에 PID 하나인 모델은 판당 개수)']';
END;
/
UPDATE IP_PRODUCT_MODEL_MASTER
   SET PCB_TOTAL_QTY = 42, LAST_MODIFY_BY = 'ADMIN', LAST_MODIFY_DATE = SYSDATE
 WHERE ORGANIZATION_ID = 1 AND MODEL_NAME IN ('SM100-SUB-PCB ASSY', 'SM110-PCB ASSY', 'SM110-PCB ASSY-REV01')
/
CREATE OR REPLACE VIEW IP_ASSEMBLY_RESULT_SENSOR_V AS
SELECT a.PRODUCT_DATE                 AS RECEIPT_DATE,
       a.PRODUCT_SEQUENCE             AS RECEIPT_SEQUENCE,
       a.LINE_CODE,
       r.MODEL_NAME,
       NVL(m.MODEL_SUFFIX, '*')       AS MODEL_SUFFIX,
       r.PCB_ITEM,
       a.TIME_DIVISION,
       a.PRODUCT_ACTUAL_QTY,
       a.PRODUCT_ACTUAL_QTY           AS PRODUCT_ACTUAL_SUM,
       0                              AS PRODUCT_ACTUAL_LOST_QTY,
       CAST(NULL AS NUMBER)           AS ORIGIN_COUNT,
       CASE WHEN a.ENTER_BY = 'ASSY_ADJUST' THEN a.PRODUCT_ACTUAL_QTY ELSE 0 END AS ADJUST_QTY,
       'N'                            AS ACTUAL_TYPE,
       'N'                            AS IS_LAST_YN,
       a.PRODUCT_ACTUAL_TIME          AS LAST_RECEIPT_DATE,
       a.WORKSTAGE_CODE,
       CAST(NULL AS VARCHAR2(30))     AS MACHINE_CODE,
       m.SMT_MODEL_NAME,
       a.ITEM_CODE,
       a.MFS                          AS RUN_NO,
       a.ENTER_BY                     AS ACTUAL_SOURCE,   -- AOI_JOB · WORK_RESULT · ASSY_ADJUST
       a.REMARK,
       a.WORKSTAGE_ISSUE_YN,
       a.ORGANIZATION_ID,
       a.ENTER_DATE,
       a.ENTER_BY,
       a.LAST_MODIFY_DATE,
       a.LAST_MODIFY_BY
  FROM IP_ASSEMBLY_RESULT a
  JOIN IP_PRODUCT_RUN_CARD r ON r.RUN_NO = a.MFS AND r.ORGANIZATION_ID = a.ORGANIZATION_ID
  LEFT JOIN IP_PRODUCT_MODEL_MASTER m ON m.MODEL_NAME = r.MODEL_NAME AND m.ORGANIZATION_ID = r.ORGANIZATION_ID
 WHERE a.ENTER_BY IN ('AOI_JOB', 'WORK_RESULT', 'ASSY_ADJUST')
/
CREATE OR REPLACE TRIGGER TRG_IM_WS_RECEIPT_INFAC
  /* 인팩 전송용 공정재고: 공정입고(자재 출고 등) + . 조립실적 반제품 입고(AOI_RT·ASSY_MANUAL·ASSY_ADJ)는 넣지 않는다. 2026-10-17 */
  AFTER INSERT OR UPDATE OF RECEIPT_QTY ON IM_ITEM_WORKSTAGE_RECEIPT
  FOR EACH ROW
  WHEN (NVL(NEW.ENTER_BY, '*') NOT IN ('AOI_RT', 'ASSY_MANUAL', 'ASSY_ADJ'))
DECLARE
  v_qty NUMBER := NVL(:NEW.RECEIPT_QTY, 0) - NVL(:OLD.RECEIPT_QTY, 0);
  v_cnt NUMBER;
BEGIN
  IF v_qty = 0 THEN RETURN; END IF;
  SELECT COUNT(*) INTO v_cnt FROM ID_ITEM WHERE ITEM_CODE = :NEW.ITEM_CODE AND SUPPLIER_CODE = 'IP' AND ROWNUM = 1;
  IF v_cnt = 0 THEN RETURN; END IF;
  MERGE INTO IM_ITEM_WS_INV_INFAC t
  USING (SELECT :NEW.ITEM_CODE c, :NEW.ORGANIZATION_ID o FROM DUAL) s
     ON (t.ITEM_CODE = s.c AND t.ORGANIZATION_ID = s.o)
   WHEN MATCHED THEN UPDATE SET t.INVENTORY_QTY = NVL(t.INVENTORY_QTY, 0) + v_qty, t.LAST_MODIFY_DATE = SYSDATE, t.LAST_MODIFY_BY = 'WS RECEIPT'
   WHEN NOT MATCHED THEN INSERT (ITEM_CODE, ORGANIZATION_ID, INVENTORY_QTY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
                         VALUES (s.c, s.o, v_qty, SYSDATE, 'WS RECEIPT');
END;
/
COMMIT
/
-- 뷰 4개는 원본 정의의 FROM 의 IP_PRODUCT_SENSOR_ACTUAL_TIME 을 IP_ASSEMBLY_RESULT_SENSOR_V 로 바꿔 다시 만든다
-- (배포 스크립트가 USER_VIEWS 원문에서 치환). 되돌리기: docs/sql/sensor-actual-views-before-2026-10-17.sql 실행.
