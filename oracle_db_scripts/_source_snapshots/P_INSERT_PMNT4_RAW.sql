PROCEDURE "P_INSERT_PMNT4_RAW" (
   p_plotinfo     IN ARRAY3_PARAMS_T,
   p_info          IN ARRAY3_PARAMS_T
)
IS
  -- p_plotinfo[] : MCNo,Lane,FAdd,FSAdd,PartsName,FeederSerial,Pickup,PMiss,RMiss,DMiss,MMiss,HMiss,TRSMiss,ChangeCount
  -- p_info : filename,line_code,machine_code,filepath
     LVS_ERRORMSG      VARCHAR2 (300);
     LVS_FILE_NAME     VARCHAR2 (50) := '';
     LVS_LINE_CODE     VARCHAR2 (30) := '';
     LVS_MACHINE_CODE     VARCHAR2 (30) := '';
     LVS_PROGRAM_NAME     VARCHAR2 (30) := '';
     LVS_LOG_DATE         VARCHAR2 (30) := '';     
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
  
  if p_plotinfo.Last >= 15
     then
    LVS_PROGRAM_NAME :=   TRIM(SUBSTR(p_plotinfo(15),INSTR(p_plotinfo(15), ' ', 1,1)));
  end if;

  if p_plotinfo.Last >= 16
     then
    LVS_LOG_DATE :=  TRIM(p_plotinfo(16));
  end if;
  
     INSERT INTO IQ_MACHINE_INSPECT_PMNT4

      (     MCNO    ,
            LANE    ,
            FADD    ,
            FSADD    ,
            PARTSNAME,

            FEEDERSERIAL,
            PICKUP    ,
            PMISS    ,
            RMISS    ,
            DMISS    ,

            MMISS    ,
            HMISS    ,
            TRSMISS    ,
            CHANGECOUNT,

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
                REPLACE(TRIM(p_plotinfo(1)),'"'),
                REPLACE(TRIM(p_plotinfo(2)),'"'),
                REPLACE(TRIM(p_plotinfo(3)),'"'),
                REPLACE(TRIM(p_plotinfo(4)),'"'),
                REPLACE(TRIM(p_plotinfo(5)),'"'),

                REPLACE(TRIM(p_plotinfo(6)),'"'),
                REPLACE(TRIM(p_plotinfo(7)),'"'),
                REPLACE(TRIM(p_plotinfo(8)),'"'),
                REPLACE(TRIM(p_plotinfo(9)),'"'),
                REPLACE(TRIM(p_plotinfo(10)),'"'),

                REPLACE(TRIM(p_plotinfo(11)),'"'),
                REPLACE(TRIM(p_plotinfo(12)),'"'),
                REPLACE(TRIM(p_plotinfo(13)),'"'),
                REPLACE(TRIM(p_plotinfo(14)),'"'),

                SYSDATE ,
                'SYSTEM' ,
                SYSDATE ,
                'SYSTEM' ,
                1,
        REPLACE(TRIM(LVS_FILE_NAME),'"'),
        REPLACE(TRIM(LVS_LINE_CODE),'"'),
                LVS_MACHINE_CODE ,
                TO_CHAR(SYSDATE ,'YYMMDDHH24MI')
        );

      COMMIT ;
EXCEPTION
   WHEN OTHERS
   THEN
      LVS_ERRORMSG := '[P_INSERT_PMNT4_RAW]' ||  SUBSTR(SQLERRM,1,200)  ;
     --  INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC ) 
      -- VALUES ( SYSDATE  , LVS_ERRORMSG  , lvs_file_name||' LINE='||lvs_line_code  ) ;
     -- COMMIT ;
      NULL;

END P_INSERT_PMNT4_RAW;