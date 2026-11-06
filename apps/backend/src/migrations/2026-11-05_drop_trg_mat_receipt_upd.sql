BEGIN
  -- TRG_MAT_RECEIPT_UPD: UPDATE OF LAST_MODIFY_DATE 에서만 돌고, 살아 있는 코드는
  -- "재고 행이 없으면 입고 OLD 값으로 재고 행 INSERT" 하나뿐이다. 나머지는 전부 주석이다.
  -- 입고 전 기간에 LAST_MODIFY_DATE 가 바뀐 행이 15건뿐이고 이를 바꾸는 앱·PL/SQL 이 없다.
  -- 복구 DDL: docs/reports/2026-11-05-trg-mat-receipt-upd-dropped.md
  EXECUTE IMMEDIATE 'DROP TRIGGER TRG_MAT_RECEIPT_UPD';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -4080 THEN RAISE; END IF;  -- 이미 없으면 통과
END;
/
