-- =====================================================================
-- 2026-10-07 공정 월마감(IM_ITEM_WORKSTAGE_INV_CLOSE)에 재고조정 칸 추가 — ESDBext 적용 (적용 당시 0행)
--
-- 공정실사 조정(공정출고, LAST_MODIFY_BY='INV ADJUST')을 일반 출고에서 떼어 따로 보인다.
-- 출고 합계(MM_ISSUE_QTY/AMT)에는 그대로 포함된다. 기초 + 입고 − 출고 = 기말.
-- 사용처: apps/backend/src/modules/inventory-query/wip-close.service.ts
-- =====================================================================

ALTER TABLE IM_ITEM_WORKSTAGE_INV_CLOSE ADD (MM_ADJUST_QTY NUMBER, MM_ADJUST_AMT NUMBER);
/
COMMENT ON COLUMN IM_ITEM_WORKSTAGE_INV_CLOSE.MM_ADJUST_QTY IS '재고조정 수량 (공정실사 차이, 공정출고 INV ADJUST. 모자람 +, 남음 -)';
/
COMMENT ON COLUMN IM_ITEM_WORKSTAGE_INV_CLOSE.MM_ADJUST_AMT IS '재고조정 금액 (월평균단가)';
/

-- 되돌리기
-- ALTER TABLE IM_ITEM_WORKSTAGE_INV_CLOSE DROP (MM_ADJUST_QTY, MM_ADJUST_AMT);
