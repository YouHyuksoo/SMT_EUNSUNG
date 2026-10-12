-- ICOM_SUPPLIER 보강 롤백 (2026-09-30)
-- 구매품목마스터·단가·입고·품목·재고가 참조하지만 공급처 마스터에 없던 코드 59개를
-- ENTER_BY = 'SUPPLIER_SYNC_0930' 로 추가했다. 아래 한 문장으로 되돌린다.
-- 주의: 되돌리면 478 발주계획 생성이 다시 ORA-02291(R_524)로 실패한다.
DELETE FROM ICOM_SUPPLIER
 WHERE ENTER_BY = 'SUPPLIER_SYNC_0930'
   AND ORGANIZATION_ID = 1;
COMMIT;
