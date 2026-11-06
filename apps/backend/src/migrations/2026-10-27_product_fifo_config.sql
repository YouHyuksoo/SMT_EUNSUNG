-- =====================================================================
-- 2026-10-27 제품 선입선출(PRODUCT_FIFO_YN) 설정 추가 — ESDBext 적용
--
-- 307 제품출하관리는 이 값이 Y 면 먼저 들어온 같은 모델 박스가 제품창고(P01)에 남아 있을 때
-- 출하를 막는다 (apps/backend/src/modules/product/services/product-fg.service.ts assertFifo).
-- 판정 범위는 기존 PRODUCT_DEAD_STOCK_DAYS(장기재고 기준일) 안에 들어온 박스다.
-- 기본은 사용(Y) — 사용자 지시 "선입선출 사용으로 기본으로 해줘". 환경설정 화면에서 관리자만 켜고 끈다. (멱등)
-- =====================================================================

MERGE INTO ISYS_CONFIG t
USING (SELECT 'PRODUCT_FIFO_YN' AS CONFIG_NAME, 1 AS ORGANIZATION_ID FROM DUAL) s
ON (t.CONFIG_NAME = s.CONFIG_NAME AND t.ORGANIZATION_ID = s.ORGANIZATION_ID)
WHEN NOT MATCHED THEN
  INSERT (CONFIG_NAME, ORGANIZATION_ID, CONFIG_DESCRIPTION, CONFIG_VALUE, CONFIG_VALUE_DESCRIPTION,
          ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY, USE_YN)
  VALUES (s.CONFIG_NAME, s.ORGANIZATION_ID, '제품 선입선출사용', 'Y', 'Y=사용 , N=미사용 (제품출하 시 먼저 들어온 박스 우선)',
          SYSDATE, 'SYSTEM', SYSDATE, 'SYSTEM', 'Y');
/
