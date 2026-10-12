-- =====================================================================
-- 2026-10-02 원자재 월마감(271)에 재고조정 칸 추가  — ESDBext 적용 완료 (적용 당시 표 0행)
--
-- 재고조정(272 실사 차이, 출고계정 M009, 그 달 말일 날짜)을 기타출고에서 떼어 따로 보인다.
-- 출고 합계(MM_ISSUE_QTY/AMT)에는 그대로 포함된다. 기초 + 입고 − 출고 = 기말.
-- 사용처: apps/backend/src/modules/inventory-query/inventory-close.service.ts
-- =====================================================================

ALTER TABLE IM_ITEM_INVENTORY_CLOSE ADD (MM_ADJUST_QTY NUMBER, MM_ADJUST_AMT NUMBER);
/
COMMENT ON COLUMN IM_ITEM_INVENTORY_CLOSE.MM_ADJUST_QTY IS '재고조정 수량 (출고계정 M009, 실사 차이. 모자람 +, 남음 -)';
/
COMMENT ON COLUMN IM_ITEM_INVENTORY_CLOSE.MM_ADJUST_AMT IS '재고조정 금액 (월평균단가)';
/

-- 되돌리기
-- ALTER TABLE IM_ITEM_INVENTORY_CLOSE DROP (MM_ADJUST_QTY, MM_ADJUST_AMT);
