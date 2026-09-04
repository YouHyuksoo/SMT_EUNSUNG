DECLARE
  -- 설비별 작업 실적관리가 저장한 실적에 LINE_CODE가 비어 있던 건을 작업지시에서 소급 반영한다.
  -- 센서 배치가 넣은 행(LINE_CODE 이미 있음)은 건드리지 않는다. (멱등)
  v_cnt NUMBER;
BEGIN
  UPDATE IP_PRODUCT_SENSOR_ACTUAL s
     SET s.LINE_CODE = (SELECT MAX(r.LINE_CODE)
                          FROM IP_PRODUCT_RUN_CARD r
                         WHERE r.RUN_NO = s.RUN_NO
                           AND r.ORGANIZATION_ID = s.ORGANIZATION_ID)
   WHERE s.LINE_CODE IS NULL
     AND s.RUN_NO IS NOT NULL
     AND EXISTS (SELECT 1 FROM IP_PRODUCT_RUN_CARD r
                  WHERE r.RUN_NO = s.RUN_NO
                    AND r.ORGANIZATION_ID = s.ORGANIZATION_ID
                    AND r.LINE_CODE IS NOT NULL);
  v_cnt := SQL%ROWCOUNT;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('backfilled: ' || v_cnt);
END;
/
