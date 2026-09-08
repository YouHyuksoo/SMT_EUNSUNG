DECLARE
  -- 라인 정지 시 어느 설비가 원인이었는지 표시한다.
  -- 라인 모드로 여러 대를 한 번에 비가동 처리할 때, 체크한 설비의 행에만 'Y'가 붙는다.
  -- 원인은 여러 대일 수 있어 단일 CAUSE_MACHINE_CODE가 아니라 행별 플래그로 둔다.
  -- "이 정지의 원인은?" = 같은 라인·시간대 행 중 CAUSE_YN='Y' 인 것들. (멱등)
  c NUMBER;
BEGIN
  SELECT COUNT(*) INTO c FROM USER_TAB_COLUMNS
   WHERE TABLE_NAME = 'IP_EQUIP_DOWNTIME_RESULT' AND COLUMN_NAME = 'CAUSE_YN';
  IF c = 0 THEN
    EXECUTE IMMEDIATE q'[ALTER TABLE IP_EQUIP_DOWNTIME_RESULT ADD (CAUSE_YN VARCHAR2(1) DEFAULT 'N')]';
  END IF;
  EXECUTE IMMEDIATE q'[COMMENT ON COLUMN IP_EQUIP_DOWNTIME_RESULT.CAUSE_YN IS '원인설비 여부: Y=이 설비가 라인 정지의 원인, N=동반 정지']';

  -- 기존 행은 원인 정보가 없다. NULL을 남기지 않고 'N'으로 채운다.
  -- 정적 SQL로 쓰면 블록 컴파일 시점에 아직 없는 컬럼을 참조해 ORA-00904가 난다.
  EXECUTE IMMEDIATE q'[UPDATE IP_EQUIP_DOWNTIME_RESULT SET CAUSE_YN = 'N' WHERE CAUSE_YN IS NULL]';
  COMMIT;
END;
/
