TRIGGER "INFINITY21_JSMES"."TR_IQ_MACHINE_INS_NPM3_RAW_INS" 
  AFTER INSERT ON IQ_MACHINE_INSPECT_NPM3_RAW   for each row
declare
  /****************************************************************************************************
     TIME ZONE ？？ ？？？？？？？？？ ？？？.
     Pick Up data ？？？？？？ ？？？？？？？？？？？？？？？？？？？？？？ ？？？？ ？？？ ？？？？？？ ？？？？？？ ？？ ？？？？ ？？？？ ？？ ？？？？？.
     HEAD SUM ？？ ？？？？？？？？ ？？？ ？？？？？？ ？o？？？？？ ？？？
     NOZZLESTOCKER UNIT, T.NOZZLECHANGER SIDE
  *****************************************************************************************************/
  -- local variables here
  LVD_ACT_DATE DATE ;   --？？？？？？？？？
  LVD_DATE DATE ;
  LVD_ACTUAL_DATE DATE; --？？？？？？？？？？？ ？？？
  LVS_TIME VARCHAR2(2);
  LVL_CNT  NUMBER ;
  LVL_SUM  NUMBER ;
  LVL_RMISS NUMBER ;
  LVL_TMISS NUMBER ;

  LVS_WORKTIME_ZONE VARCHAR2(2);
  lvs_errm varchar(4000);


begin

  LVD_ACT_DATE := TO_DATE(:NEW.FILE_NAME ,'YYYYMMDDHH24MISS') ;            --？？？？？？？？？
  LVD_DATE     := TRUNC(TO_DATE(:NEW.FILE_NAME ,'YYYYMMDDHH24MISS'));
  LVS_TIME     := TO_CHAR(TO_DATE(:NEW.FILE_NAME ,'YYYYMMDDHH24MISS'),'HH24');

  LVS_WORKTIME_ZONE := F_GET_WORKTIME_ZONE(TO_CHAR(LVD_DATE,'YYYYMMDD'), TO_CHAR(LVD_ACT_DATE,'HH24MI')) ;
  LVD_ACTUAL_DATE   := TO_DATE(  F_GET_WORKTIME_ZONE(TO_CHAR(LVD_DATE,'YYYYMMDD'), TO_CHAR(LVD_ACT_DATE,'HH24MI'),'DATE')  ,'YYYYMMDD') ;

  BEGIN
    SELECT COUNT(*)
      INTO LVL_CNT
      FROM IQ_MACHINE_INSPECT_PICKUP_RATE
     WHERE LINE_CODE    = :NEW.LINE_CODE
       AND MACHINE_CODE = :NEW.MACHINE_CODE||NVL(:NEW.MODEL_NAME,'*')
       AND ADDRESS      = :NEW.NOZZLESTOCKER
       AND SUB_ADDRESS  = :NEW.NOZZLECHANGER
       AND ITEM_CODE    = '*'  --ITEM_CODE
       AND ACTUAL_DATE  = LVD_ACTUAL_DATE   --LVD_DATE
       AND ACTUAL_TIME  = LVS_WORKTIME_ZONE --LVS_TIME
       AND DATA_TYPE    = 'R'    --TMISS, RMISS
       AND PROGRAM_NAME = NVL(:NEW.MODEL_NAME,'*')  ;

  EXCEPTION
    WHEN OTHERS THEN

       LVL_CNT := 0 ;
  END ;


  LVL_TMISS := :NEW.RMISS ;
  LVL_RMISS := :NEW.TMISS ;

  IF LVL_CNT = 0 THEN --？？？
    INSERT INTO IQ_MACHINE_INSPECT_PICKUP_RATE (
      line_code,
      machine_code,
      address,
      sub_address,
      feeder_type,

      table_no,
      feeder_zaxis,
      feeder_lraxis,

      model_name,
      model_suffix,
      pcb_item,

      item_code,
      data_type,

      shift_date,     --？？？ ？？？？？？？ð？
      actual_date,    --？？？？？？？？？？？ ？？？？ð？
      actual_time,    --？？？？？？？？？？？ TIME ZONE

      head_sum,

      TACT_TIME,
      TACT_TIME_01,

      created_date,
      create_by   ,
      LAST_UPDATED_DATE,
      LAST_UPDATE_BY,
      WORK_TIME_ZONE,
      PROGRAM_NAME

    )
    VALUES (
      :NEW.LINE_CODE,
      :NEW.MACHINE_CODE||NVL(:NEW.MODEL_NAME,'*'),

      :NEW.NOZZLESTOCKER,
      :NEW.NOZZLECHANGER,
      '*',

      SUBSTR(:NEW.NOZZLESTOCKER,1,3),-- TABLE_NO
      SUBSTR(:NEW.NOZZLESTOCKER,4,2),-- FEEDER_ZAXIS
      :NEW.NOZZLECHANGER             ,-- FEEDER_LRAXIS

      '*',
      '*',
      '*',

      '*',       --AS ITEM_CODE,
      'R'       ,--AS DATA_TYPE,      -- T : TAKE_UP, M :MISS, R:RmISS

      TO_DATE(:NEW.FILE_NAME ,'YYYYMMDDHH24MISS') ,--AS SHIFT_DATE,
      LVD_ACTUAL_DATE,   --？？？？？？？？？？？ ？？？
      LVS_WORKTIME_ZONE, --？？？？？？？？？？？ TIME ZONE

      LVL_RMISS,         --R MISS ？？？？

      0,
      0,
      sysdate,
      'RMISS',
      LVD_ACT_DATE,
      'RMISS',
      LVS_WORKTIME_ZONE,
      NVL(:NEW.MODEL_NAME,'*')

    ) ;

    INSERT INTO IQ_MACHINE_INSPECT_PICKUP_RATE (
      line_code,
      machine_code,
      address,
      sub_address,
      feeder_type,

      table_no,
      feeder_zaxis,
      feeder_lraxis,

      model_name,
      model_suffix,
      pcb_item,

      item_code,
      data_type,

      shift_date,     --？？？ ？？？？？？？ð？
      actual_date,    --？？？？？？？？？？？ ？？？？ð？
      actual_time,    --？？？？？？？？？？？ TIME ZONE

      head_sum,

      TACT_TIME,
      TACT_TIME_01,

      created_date,
      create_by   ,
      LAST_UPDATED_DATE,
      LAST_UPDATE_BY,
      WORK_TIME_ZONE,
      PROGRAM_NAME

    )
    VALUES (
      :NEW.LINE_CODE,
      :NEW.MACHINE_CODE||NVL(:NEW.MODEL_NAME,'*'),

      :NEW.NOZZLESTOCKER,
      :NEW.NOZZLECHANGER,
      '*',

      SUBSTR(:NEW.NOZZLESTOCKER,1,3),-- TABLE_NO
      SUBSTR(:NEW.NOZZLESTOCKER,4,2),-- FEEDER_ZAXIS
      :NEW.NOZZLECHANGER             ,-- FEEDER_LRAXIS

      '*',
      '*',
      '*',

      '*',       --AS ITEM_CODE,
      'M'       ,--AS DATA_TYPE,      -- T : TAKE_UP, M :MISS, R:RmISS

      TO_DATE(:NEW.FILE_NAME ,'YYYYMMDDHH24MISS') ,--AS SHIFT_DATE,
      LVD_ACTUAL_DATE,   --？？？？？？？？？？？ ？？？
      LVS_WORKTIME_ZONE, --？？？？？？？？？？？ TIME ZONE

      LVL_TMISS,         --R MISS ？？？？

      0,
      0,
      sysdate,
      'MISS',
      LVD_ACT_DATE,
      'MISS',
      LVS_WORKTIME_ZONE,
      NVL(:NEW.MODEL_NAME,'*')

    ) ;


  ELSE                 --？？？？？？PDATE


    /* UPDATE */
    UPDATE IQ_MACHINE_INSPECT_PICKUP_RATE
       SET  head_sum =  LVL_RMISS,

            LAST_UPDATED_DATE = LVD_ACT_DATE ,
            LAST_UPDATE_BY    = 'RMISS',
            TACT_TIME         = (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24,
            TACT_TIME_01      = ( TACT_TIME + ( (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24 ) ) / DECODE(NVL(TACT_TIME,0),0,1,2) ,
            ENTER_DATE        = SYSDATE
     WHERE LINE_CODE    = :NEW.LINE_CODE
       AND MACHINE_CODE = :NEW.MACHINE_CODE||NVL(:NEW.MODEL_NAME,'*')
       AND ADDRESS      = :NEW.NOZZLESTOCKER
       AND SUB_ADDRESS  = :NEW.NOZZLECHANGER
       AND ITEM_CODE    = '*'
       AND ACTUAL_DATE  = LVD_ACTUAL_DATE   --LVD_DATE
       AND ACTUAL_TIME  = LVS_WORKTIME_ZONE --LVS_TIME
       AND DATA_TYPE    = 'R'
       AND PROGRAM_NAME = NVL(:NEW.MODEL_NAME,'*') ;


    /* UPDATE */
    UPDATE IQ_MACHINE_INSPECT_PICKUP_RATE
       SET  head_sum =  LVL_TMISS,

            LAST_UPDATED_DATE = LVD_ACT_DATE ,
            LAST_UPDATE_BY    = 'MISS',
            TACT_TIME         = (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24,
            TACT_TIME_01      = ( TACT_TIME + ( (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24 ) ) / DECODE(NVL(TACT_TIME,0),0,1,2) ,
            ENTER_DATE        = SYSDATE
     WHERE LINE_CODE    = :NEW.LINE_CODE
       AND MACHINE_CODE = :NEW.MACHINE_CODE||NVL(:NEW.MODEL_NAME,'*')
       AND ADDRESS      = :NEW.NOZZLESTOCKER
       AND SUB_ADDRESS  = :NEW.NOZZLECHANGER
       AND ITEM_CODE    = '*'
       AND ACTUAL_DATE  = LVD_ACTUAL_DATE   --LVD_DATE
       AND ACTUAL_TIME  = LVS_WORKTIME_ZONE --LVS_TIME
       AND DATA_TYPE    = 'M'
       AND PROGRAM_NAME = NVL(:NEW.MODEL_NAME,'*') ;

  END IF;


EXCEPTION

  WHEN OTHERS THEN
    lvs_errm :=lvs_errm||substr(sqlerrm,1,300);
 --   insert into a ( a ) values (TO_CHAR(LVD_ACTUAL_DATE,'YYYYMMDD')|| LVS_WORKTIME_ZONE||' PMNT MISS'||lvs_errm ) ;
    NULL ;

end TR_IQ_MACHINE_INS_NPM3_RAW_INS;