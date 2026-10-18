-- =====================================================================
-- 포장 시점 소비 (2026-10-18)
-- 사용자 지시: "포장시점에서 빼고 그게 공정에 재고로 되어 있다가 입고 잡으로 공정에서 빠지고 제품재고가 되어야 한다"
-- 설계: docs/specs/2026-10-17-wip-semi-product-from-aoi-design.md (5-6)
--
-- ISYS_CONFIG WIP_PACK_CONSUME_FROM  이 시각 이후 포장한 박스부터:
--   포장 → 반제품·자재 공정출고 + 제품 공정입고(ENTER_BY = 'PACK')
--   제품창고 입고 → 제품 공정출고(ENTER_BY = 'FG_RECEIPT'), 입고취소 → 되돌림
--   (P_WIP_ISSUE_CREATE, 잡 101·102 06:10·17:10 + 잡 162 10분마다)
--   그 전 포장 박스는 예전처럼 입고 때 자재를 뺀다.
-- TRG_IM_WS_RECEIPT_INFAC  제품 공정입고(PACK)는 인팩 전송용에 넣지 않는다 (인팩은 예전처럼 입고 때 BOM 말단).
-- =====================================================================
INSERT INTO ISYS_CONFIG (CONFIG_NAME, ORGANIZATION_ID, CONFIG_DESCRIPTION, CONFIG_VALUE, CONFIG_VALUE_DESCRIPTION,
                         ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY, USE_YN)
VALUES ('WIP_PACK_CONSUME_FROM', 1, '포장 시점 공정 소비 전환 시각', TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS'),
        'YYYY/MM/DD HH24:MI:SS — 이후 포장분은 포장 때 소비',
        SYSDATE, 'ADMIN', SYSDATE, 'ADMIN', 'Y')
/
CREATE OR REPLACE TRIGGER TRG_IM_WS_RECEIPT_INFAC
  /* 인팩 전송용 공정재고: 공정입고(자재 출고 등) + . 조립실적 반제품 입고(AOI_RT·ASSY_MANUAL·ASSY_ADJ),
     공정간 이동 입고(WS_MOVE), 포장 제품 공정입고(PACK)는 넣지 않는다. 2026-10-17 / 2026-10-18 */
  AFTER INSERT OR UPDATE OF RECEIPT_QTY ON IM_ITEM_WORKSTAGE_RECEIPT
  FOR EACH ROW
  WHEN (NVL(NEW.ENTER_BY, '*') NOT IN ('AOI_RT', 'ASSY_MANUAL', 'ASSY_ADJ', 'WS_MOVE', 'PACK'))
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
-- 원복 (전환 취소): DELETE FROM ISYS_CONFIG WHERE CONFIG_NAME = 'WIP_PACK_CONSUME_FROM';
--   단, 이미 K·Y 로 처리된 포장 시점 소비 박스가 있으면 그 박스의 소비·제품 입출고를 먼저 되돌려야 한다.
--   P_WIP_ISSUE_CREATE 는 oracle_db_scripts 의 이전 판(git)으로 다시 배포. 잡 162 제거: DBMS_JOB.REMOVE(162)
