-- =====================================================================
-- 조립라인 런카드 공정 = 포장(W220) (2026-10-19)
-- 사용자: "지금은 포장공정밖에 작업지시를 안내려서 묵시적으로 포장공정이 실적공정인데
--          향후에는 조립라인에 가공공정도 작업지시를 내릴 예정이라서 공정이 있어야 하는건 맞아"
--
-- 1. 공정이 빈 조립라인(라인구분 L) 런카드를 W220(PACKING)으로 채운다 (2022-04 ~ 19,200건).
--    대상 RUN_NO 목록: backups/run-card-workstage-null-L-2026-10-19.csv (원복용)
-- 2. TRG_IP_RUN_CARD_WS_DEFAULT  공정 없이 발행되는 조립라인 런카드(PB 롯트카드 화면)에 W220 을 넣는다.
--    공정을 정해 발행하면(새 MES 롯트카드 화면) 그대로 둔다.
-- 완제품 실적 공정재고 반영은 조립라인 + 포장 공정(W220) 실적만 한다 (work-result.service.ts).
-- =====================================================================
UPDATE IP_PRODUCT_RUN_CARD r
   SET r.WORKSTAGE_CODE = 'W220'
 WHERE r.WORKSTAGE_CODE IS NULL
   AND EXISTS (SELECT 1 FROM IP_PRODUCT_LINE l
                WHERE l.LINE_CODE = r.LINE_CODE AND l.ORGANIZATION_ID = r.ORGANIZATION_ID AND l.LINE_DIVISION = 'L')
/
CREATE OR REPLACE TRIGGER TRG_IP_RUN_CARD_WS_DEFAULT
  /* 공정 없이 발행되는 조립라인 런카드에 포장 공정(W220)을 넣는다. 2026-10-19
     지금 조립라인 지시는 포장 공정뿐이다. 다른 공정 지시는 공정을 정해 발행한다. */
  BEFORE INSERT ON IP_PRODUCT_RUN_CARD
  FOR EACH ROW
  WHEN (NEW.WORKSTAGE_CODE IS NULL)
DECLARE
  v_div IP_PRODUCT_LINE.LINE_DIVISION%TYPE;
BEGIN
  SELECT MAX(LINE_DIVISION) INTO v_div
    FROM IP_PRODUCT_LINE
   WHERE LINE_CODE = :NEW.LINE_CODE AND ORGANIZATION_ID = :NEW.ORGANIZATION_ID;
  IF v_div = 'L' THEN
    :NEW.WORKSTAGE_CODE := 'W220';
  END IF;
END;
/
COMMIT
/
-- 원복: DROP TRIGGER TRG_IP_RUN_CARD_WS_DEFAULT;
--       backups/run-card-workstage-null-L-2026-10-19.csv 의 RUN_NO 만 WORKSTAGE_CODE = NULL 로 되돌린다.
