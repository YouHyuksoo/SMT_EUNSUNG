PROCEDURE "P_INSERT_NPM2_RAW" (
   p_data     IN ARRAY3_PARAMS_T,
   p_info     IN ARRAY3_PARAMS_T
)
IS
     LVS_ERRORMSG      VARCHAR2 (300);
     LVS_FILE_NAME     VARCHAR2 (50) := '';
     LVS_LINE_CODE     VARCHAR2 (30) := '';
     LVS_MACHINE_CODE     VARCHAR2 (30) := '';

     LI_START_POSITION    INT := 4;     -- 4th folder delemeter
     LVS_PATH_NAME     VARCHAR2 (30) := '';
     LVI_START_INDEX      INT := 0;
     LVI_END_INDEX        INT := 0;     
BEGIN

  if p_info.Last >= 1
    then
    LVS_FILE_NAME := TRIM(p_info(1));
  end if;

  if p_info.Last >= 2
    then
    LVS_LINE_CODE := TRIM(p_info(2));
  end if;

  if p_info.Last >= 3
    then
    LVS_MACHINE_CODE := TRIM(p_info(3));
  end if;

  if p_info.Last >= 4
    then
    LVI_START_INDEX := INSTR(TRIM(p_info(4)), '\', -1, LI_START_POSITION);
    LVI_END_INDEX   := INSTR(TRIM(p_info(4)), '\', -1, LI_START_POSITION - 1);
    if LVI_START_INDEX > 0 and LVI_END_INDEX > 0 
      then     
        LVS_PATH_NAME := SUBSTR(TRIM(p_info(4)), LVI_START_INDEX + 1, LVI_END_INDEX - LVI_START_INDEX - 1);
    end if;
  end if; 
  
     INSERT INTO IQ_MACHINE_INSPECT_NPM2_RAW

      (   HEAD,
          NOZZLESTOCKER,
          NOZZLECHANGER,
          TCNT,
          STAGE,

          LANE,
          TOTAL,
          ACTUAL,
          MODEL_NAME,

          ENTER_DATE,
          ENTER_BY,
          LAST_MODIFY_DATE,
          LAST_MODIFY_BY,
          ORGANIZATION_ID,
          FILE_NAME,
          LINE_CODE,
          MACHINE_CODE,
          RUN_NO
      )
      VALUES
      (
        REPLACE(TRIM(p_data(1)),'"'),
        REPLACE(TRIM(p_data(2)),'"'),
        REPLACE(TRIM(p_data(3)),'"'),
        REPLACE(TRIM(p_data(4)),'"'),
        REPLACE(TRIM(p_data(5)),'"'),

        REPLACE(TRIM(p_data(6)),'"'),
        REPLACE(TRIM(p_data(7)),'"'),
        REPLACE(TRIM(p_data(8)),'"'),
        LVS_PATH_NAME, --REPLACE(TRIM(p_data(9)),'"'),

        SYSDATE ,
        'SYSTEM' ,
        SYSDATE ,
        'SYSTEM' ,
        1,
        REPLACE(TRIM(LVS_FILE_NAME),'"'),
        LVS_LINE_CODE,
        LVS_MACHINE_CODE,
        TO_CHAR(SYSDATE ,'YYMMDDHH24MI')
        );

      COMMIT ;
EXCEPTION
   WHEN OTHERS
   THEN
      LVS_ERRORMSG := '[P_INSERT_NPM2_RAW]' ||  SUBSTR(SQLERRM,1,200)  ;
    --   INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC ) 
    --   VALUES ( SYSDATE  , LVS_ERRORMSG  , lvs_file_name||' LINE='||lvs_line_code  ) ;
    --  COMMIT ;
      NULL;

END P_INSERT_NPM2_RAW;