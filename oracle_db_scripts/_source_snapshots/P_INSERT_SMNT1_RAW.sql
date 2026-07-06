PROCEDURE "P_INSERT_SMNT1_RAW" (
   p_data          IN ARRAY5_PARAMS_T,
   p_info          IN ARRAY5_PARAMS_T
)
IS
     LVS_ERRORMSG      VARCHAR2 (500);
     LVS_FILE_NAME     VARCHAR2 (100) := '';
     LVS_LINE_CODE     VARCHAR2 (100) := '';
     LVS_MACHINE_CODE  VARCHAR2 (100) := '';
     LVS_MODEL         VARCHAR2 (100) := '';

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

  if p_data.Last >= 8 --Model=
     then
    LVS_MODEL :=  TRIM(p_data(8));
  end if;

     INSERT INTO IQ_MACHINE_INSPECT_SMNT1

      (     gantryid,
            headid,
            pickup,
            place,
            pickerror,
            visionerror,
            dump,
            model_name,

            ENTER_DATE       ,
            ENTER_BY         ,
            LAST_MODIFY_DATE ,
            LAST_MODIFY_BY   ,
            ORGANIZATION_ID  ,
            FILE_NAME        ,
            LINE_CODE        ,
            MACHINE_CODE     ,
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

        LVS_MODEL,

        SYSDATE ,
        'SYSTEM' ,
        SYSDATE ,
        'SYSTEM' ,
        1,
        REPLACE(TRIM(LVS_FILE_NAME),'"'),
        LVS_LINE_CODE,
        LVS_MACHINE_CODE,
        TO_CHAR(SYSDATE ,'YYMMDDHH24MISS')
        );

      COMMIT ;
EXCEPTION
   WHEN OTHERS
   THEN
      LVS_ERRORMSG := '[P_INSERT_SMNT1_RAW]' ||  SUBSTR(SQLERRM,1,200)  ;
      INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC )
       VALUES ( SYSDATE  , LVS_ERRORMSG  , lvs_file_name||' LINE='||lvs_line_code  ) ;
      COMMIT ;
      NULL;

END P_INSERT_SMNT1_RAW;
