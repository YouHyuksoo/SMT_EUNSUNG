-- =====================================================================
-- 완제품 실적을 IP_PRODUCT_RESULT 로 통일 (2026-10-19)
-- 사용자 지시: "IP_PRODUCT_RESULT 를 이용하자 실적과 포장은 다른 이야기 임",
--              "IP_PRODUCT_WORK_RESULT 를 쓰지말고 IP_PRODUCT_RESULT 로 통일하는걸로 진행해",
--              "oee 에서는 smt 실적을 입력받지 않음"
-- 설계: docs/specs/2026-10-17-wip-semi-product-from-aoi-design.md (5-7)
--
-- 1. IP_PRODUCT_RESULT 기존 트리거 4개 삭제 — 사출용(계획·금형·설비능력·LQC) 로직이고 모두 INVALID 였다
--    (INSERT 하면 ORA-04098). 원본: docs/sql/ip-product-result-triggers-before-2026-10-19.sql
-- 2. 작업지시별 실적 등록(OEE 실적입력·설비별 작업실적관리)에 필요한 칼럼 추가
--      RUN_NO · SEQ_NO       런카드(작업지시) · 작업지시 안 실적 순번 (01~99)
--      WORK_TIME · WORKER_COUNT · WORKER_NAME
--      RESULT_STATUS         처리구분 WIP=진행 / DONE=완료 / CANCEL=취소 (취소면 PRODUCT_ACTUAL_STATUS 도 'C')
--      WIP_APPLY_MSG         공정재고 반영 실패 원문 (반영 여부는 기존 WORKSTAGE_ISSUE_YN: Y 반영 / N 미반영 / X 대상 아님 / C 취소 되돌림)
-- 3. TRG_IM_WS_RECEIPT_INFAC  완제품 실적 제품 공정입고(PROD_RT)는 인팩 전송용에 넣지 않는다
-- 4. 포장 시점 소비(WIP_PACK_CONSUME_FROM, 처리된 박스 0건)를 걷어내고 완제품 실적 소비 전환 시각을 둔다
--    WIP_RESULT_CONSUME_FROM 이후 완제품 실적 → 제품 공정입고 + 반제품·자재 소모 (P_PRODUCT_RESULT_WIP)
--    그 뒤 포장 박스는 소비 없이, 제품창고 입고 때 제품 공정출고만 (P_WIP_ISSUE_CREATE)
--    잡 162(10분마다 P_WIP_ISSUE_CREATE) 제거 — 제품 공정출고는 06:10·17:10 잡으로 충분하다
-- IP_PRODUCT_WORK_RESULT 테이블은 남겨 둔다 (취소된 시험 1건뿐).
-- =====================================================================
DROP TRIGGER TRG_IP_PRODUCT_RESULT_INS
/
DROP TRIGGER TRG_IP_PRODUCT_RESULT_UPD
/
DROP TRIGGER TRG_IP_PRODUCT_RESULT_DEL
/
DROP TRIGGER TRG_PRODUCT_RESULT_MANUAL
/
ALTER TABLE IP_PRODUCT_RESULT ADD (
  RUN_NO        VARCHAR2(30),
  SEQ_NO        VARCHAR2(2),
  WORK_TIME     NUMBER,
  WORKER_COUNT  NUMBER,
  WORKER_NAME   VARCHAR2(100),
  RESULT_STATUS VARCHAR2(10),
  WIP_APPLY_MSG VARCHAR2(1000)
)
/
COMMENT ON COLUMN IP_PRODUCT_RESULT.RUN_NO IS '런카드(작업지시) 번호'
/
COMMENT ON COLUMN IP_PRODUCT_RESULT.SEQ_NO IS '작업지시 안 실적 순번 01~99'
/
COMMENT ON COLUMN IP_PRODUCT_RESULT.RESULT_STATUS IS '처리구분: WIP=진행, DONE=완료, CANCEL=취소'
/
COMMENT ON COLUMN IP_PRODUCT_RESULT.WIP_APPLY_MSG IS '공정재고 반영 실패 원문 (반영 여부는 WORKSTAGE_ISSUE_YN)'
/
CREATE UNIQUE INDEX UX_IP_PRODUCT_RESULT_RUN ON IP_PRODUCT_RESULT (RUN_NO, SEQ_NO, ORGANIZATION_ID)
/
CREATE OR REPLACE TRIGGER TRG_IM_WS_RECEIPT_INFAC
  /* 인팩 전송용 공정재고: 공정입고(자재 출고 등) + . 조립실적 반제품 입고(AOI_RT·ASSY_MANUAL·ASSY_ADJ),
     공정간 이동 입고(WS_MOVE), 포장 제품 공정입고(PACK), 완제품 실적 제품 공정입고(PROD_RT)는 넣지 않는다.
     2026-10-17 / 2026-10-18 / 2026-10-19 */
  AFTER INSERT OR UPDATE OF RECEIPT_QTY ON IM_ITEM_WORKSTAGE_RECEIPT
  FOR EACH ROW
  WHEN (NVL(NEW.ENTER_BY, '*') NOT IN ('AOI_RT', 'ASSY_MANUAL', 'ASSY_ADJ', 'WS_MOVE', 'PACK', 'PROD_RT'))
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
-- oracle_db_scripts/P_PRODUCT_RESULT_WIP.sql, oracle_db_scripts/P_WIP_ISSUE_CREATE.sql 배포 뒤
-- (P_WIP_ISSUE_CREATE 를 다시 배포하면 P_JOB_INFAC_DATA_* 가 INVALID 가 된다 — 바로 다시 컴파일)
DELETE FROM ISYS_CONFIG WHERE CONFIG_NAME = 'WIP_PACK_CONSUME_FROM'
/
BEGIN
  DBMS_JOB.REMOVE(162);
END;
/
COMMIT
/
-- ---------------------------------------------------------------------
-- 전환 (백엔드 배포와 같은 때): 이 뒤 조립라인 완료 실적이 공정재고를 움직이고, 포장은 소비하지 않는다.
-- 백엔드보다 먼저 넣으면 그 사이 포장·입고된 박스의 자재가 빠지지 않는다.
-- ---------------------------------------------------------------------
INSERT INTO ISYS_CONFIG (CONFIG_NAME, ORGANIZATION_ID, CONFIG_DESCRIPTION, CONFIG_VALUE, CONFIG_VALUE_DESCRIPTION,
                         ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY, USE_YN)
VALUES ('WIP_RESULT_CONSUME_FROM', 1, '완제품 실적 공정 소비 전환 시각', TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS'),
        'YYYY/MM/DD HH24:MI:SS — 이후 완제품 실적이 제품입고·소모',
        SYSDATE, 'ADMIN', SYSDATE, 'ADMIN', 'Y')
/
COMMIT
/
-- 원복:
--   DELETE FROM ISYS_CONFIG WHERE CONFIG_NAME = 'WIP_RESULT_CONSUME_FROM';  (이미 반영된 완제품 실적·K 박스가 있으면 먼저 되돌린다)
--   P_WIP_ISSUE_CREATE 는 git 이전 판으로 다시 배포, DROP PROCEDURE P_PRODUCT_RESULT_WIP
--   DROP INDEX UX_IP_PRODUCT_RESULT_RUN;
--   ALTER TABLE IP_PRODUCT_RESULT DROP (RUN_NO, SEQ_NO, WORK_TIME, WORKER_COUNT, WORKER_NAME, RESULT_STATUS, WIP_APPLY_MSG);
--   트리거: docs/sql/ip-product-result-triggers-before-2026-10-19.sql
--   인팩 트리거: 2026-10-18_wip_pack_consume.sql 의 판
