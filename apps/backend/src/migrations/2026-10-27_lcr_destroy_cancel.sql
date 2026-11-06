DECLARE
  -- =====================================================================
  -- 2026-10-27 LCR 폐기 취소 칸 추가 — ESDBext 적용
  --
  -- 사용자 지시: "LCR 폐기도 취소로 바꿔줘" — 삭제(DELETE) 대신 취소로 남긴다.
  -- 취소된 등록은 행과 자재 내역(IP_LCR_DESTROY_DETAIL)을 그대로 두고 월 누계에서 뺀다.
  -- 사용처: apps/backend/src/modules/quality/services/lcr-destroy.service.ts
  -- IP_LCR_DESTROY 는 2026-10-22_product_destroy_detail_lcr.sql 이 만든다. 없으면 멈춘다.
  -- 칸마다 USER_TAB_COLUMNS 를 보고 없을 때만 더한다. (멱등)
  -- =====================================================================
  n NUMBER;
  PROCEDURE add_column(p_column VARCHAR2, p_definition VARCHAR2) IS
    c NUMBER;
  BEGIN
    SELECT COUNT(*) INTO c FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'IP_LCR_DESTROY' AND COLUMN_NAME = p_column;
    IF c = 0 THEN
      EXECUTE IMMEDIATE 'ALTER TABLE IP_LCR_DESTROY ADD (' || p_column || ' ' || p_definition || ')';
    END IF;
  END;
BEGIN
  SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = 'IP_LCR_DESTROY';
  IF n = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'IP_LCR_DESTROY 가 없습니다. 2026-10-22_product_destroy_detail_lcr.sql 을 먼저 적용하세요.');
  END IF;

  add_column('CANCEL_YN', q'~VARCHAR2(1) DEFAULT 'N' NOT NULL~');
  add_column('CANCEL_DATE', 'DATE');
  add_column('CANCEL_BY', 'VARCHAR2(20)');
  add_column('CANCEL_REASON', 'VARCHAR2(500)');

  SELECT COUNT(*) INTO n FROM USER_CONSTRAINTS WHERE CONSTRAINT_NAME = 'CK_IP_LCR_DESTROY_CANCEL';
  IF n = 0 THEN
    EXECUTE IMMEDIATE q'~ALTER TABLE IP_LCR_DESTROY ADD CONSTRAINT CK_IP_LCR_DESTROY_CANCEL CHECK (CANCEL_YN IN ('Y', 'N'))~';
  END IF;

  EXECUTE IMMEDIATE q'~COMMENT ON COLUMN IP_LCR_DESTROY.CANCEL_YN IS '취소 여부 (Y=취소, N=정상). 취소는 행을 지우지 않고 월 누계에서 뺀다'~';
  EXECUTE IMMEDIATE q'~COMMENT ON COLUMN IP_LCR_DESTROY.CANCEL_DATE IS '취소일시'~';
  EXECUTE IMMEDIATE q'~COMMENT ON COLUMN IP_LCR_DESTROY.CANCEL_BY IS '취소자'~';
  EXECUTE IMMEDIATE q'~COMMENT ON COLUMN IP_LCR_DESTROY.CANCEL_REASON IS '취소 사유'~';
END;
/
