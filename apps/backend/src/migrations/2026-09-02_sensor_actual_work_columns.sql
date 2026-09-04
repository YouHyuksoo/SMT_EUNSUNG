DECLARE
  -- 설비별 작업 실적관리의 실적 저장을 IP_PRODUCT_WORK_RESULT -> IP_PRODUCT_SENSOR_ACTUAL 로 옮긴다.
  -- 수기 실적에 필요한 4개 컬럼만 추가한다(공정코드 WORKSTAGE_CODE는 이미 존재).
  -- 센서 배치(P_INTERLOCK_SENSOR_ACTUAL_NEO)는 이 컬럼들을 채우지 않으므로 NULL 허용이다. (멱등)
  n NUMBER;
  PROCEDURE add_col(p_col VARCHAR2, p_ddl VARCHAR2, p_comment VARCHAR2) IS
    c NUMBER;
  BEGIN
    SELECT COUNT(*) INTO c FROM USER_TAB_COLUMNS
     WHERE TABLE_NAME = 'IP_PRODUCT_SENSOR_ACTUAL' AND COLUMN_NAME = p_col;
    IF c = 0 THEN
      EXECUTE IMMEDIATE 'ALTER TABLE IP_PRODUCT_SENSOR_ACTUAL ADD (' || p_ddl || ')';
    END IF;
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN IP_PRODUCT_SENSOR_ACTUAL.' || p_col || ' IS ''' || p_comment || '''';
  END;
BEGIN
  add_col('MACHINE_CODE', 'MACHINE_CODE VARCHAR2(30)',  '설비코드 (IMCN_MACHINE.MACHINE_CODE) - 수기 실적 전용, 센서 배치는 NULL');
  add_col('WORK_TIME',    'WORK_TIME NUMBER',           '작업시간(분) - 수기 실적 전용');
  add_col('WORKER_NAME',  'WORKER_NAME VARCHAR2(100)',  '작업자명 - 수기 실적 전용');
  add_col('WORKER_COUNT', 'WORKER_COUNT NUMBER',        '작업인원 - 수기 실적 전용');

  -- 처리구분 매핑을 주석으로 남긴다(WIP -> N, DONE -> Y).
  EXECUTE IMMEDIATE q'[COMMENT ON COLUMN IP_PRODUCT_SENSOR_ACTUAL.IS_LAST_YN IS '최종여부/처리구분: Y=완료(수정불가), N=진행']';
END;
/
