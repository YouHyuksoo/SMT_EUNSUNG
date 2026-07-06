TRIGGER "INFINITY21_JSMES"."TR_IQ_MACHINE_PMNT4_INS" 
  AFTER INSERT ON IQ_MACHINE_INSPECT_PMNT4   for each row
declare
  /****************************************************************************************************
     NPM ？？？？？ ？？ 10？д？？？？？？ ？？？？？
     ？？？？？？ ？？？？？？？？？？？？？
  *****************************************************************************************************/
  -- local variables here
  LVD_ACT_DATE DATE ;   --？？？？？？？？？
  LVD_DATE DATE ;
  LVD_ACTUAL_DATE DATE; --？？？？？？？？？？？ ？？？
  LVS_TIME VARCHAR2(2);
  LVL_CNT  NUMBER ;
  LVL_SUM  NUMBER ;
  LVL_PIKUP NUMBER ;
  LVL_RMISS NUMBER ;
  LVL_TMISS NUMBER ;

  LVS_WORKTIME_ZONE VARCHAR2(2);
  lvs_errm varchar(4000);


begin
  IF LENGTH(TRIM(:NEW.FEEDERSERIAL)) > 1 THEN

    LVD_ACT_DATE := TO_DATE(:NEW.FILE_NAME ,'YYYYMMDDHH24MISS') ;            --？？？？？？？？？
    LVD_DATE     := TRUNC(TO_DATE(:NEW.FILE_NAME ,'YYYYMMDDHH24MISS'));
    LVS_TIME     := TO_CHAR(TO_DATE(:NEW.FILE_NAME ,'YYYYMMDDHH24MISS'),'HH24');

    LVS_WORKTIME_ZONE := F_GET_WORKTIME_ZONE(TO_CHAR(LVD_DATE,'YYYYMMDD'), TO_CHAR(LVD_ACT_DATE,'HH24MI')) ;
    LVD_ACTUAL_DATE   := TO_DATE(  F_GET_WORKTIME_ZONE(TO_CHAR(LVD_DATE,'YYYYMMDD'), TO_CHAR(LVD_ACT_DATE,'HH24MI'),'DATE')  ,'YYYYMMDD') ;

    lvs_errm := :NEW.LINE_CODE||:NEW.MACHINE_CODE||NVL('*','*')||:NEW.FADD||:NEW.FSADD||:NEW.PARTSNAME ;

    BEGIN
      SELECT COUNT(*)
        INTO LVL_CNT
        FROM IQ_MACHINE_INSPECT_PICKUP_RATE
       WHERE LINE_CODE    = :NEW.LINE_CODE
         AND MACHINE_CODE = :NEW.MACHINE_CODE||NVL(:NEW.MCNO,'*')
         AND ADDRESS      = :NEW.FADD
         AND SUB_ADDRESS  = :NEW.FSADD
         AND ITEM_CODE    = NVL(:NEW.PARTSNAME,'*')
         AND ACTUAL_DATE  = LVD_ACTUAL_DATE   --LVD_DATE
         AND ACTUAL_TIME  = LVS_WORKTIME_ZONE --LVS_TIME
         --AND DATA_TYPE    = 'R'    --TMISS, RMISSs
         AND PROGRAM_NAME = '*'  ;

    EXCEPTION
      WHEN OTHERS THEN

         LVL_CNT := 0 ;
    END ;

    LVL_PIKUP := NVL(:NEW.PICKUP,0);
    LVL_TMISS := NVL(:NEW.PMISS,0) ;
    LVL_RMISS := NVL(:NEW.RMISS,0) ;

    IF LVL_CNT = 0 THEN --？？？
      --takeup ？？？？



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
        PROGRAM_NAME,
        MACHINE_TYPE

      )
      VALUES (
        :NEW.LINE_CODE,
        :NEW.MACHINE_CODE||NVL(:NEW.MCNO,'*'),

        :NEW.FADD,
        :NEW.FSADD,
        '*',

        SUBSTR(:NEW.FADD,1,3),-- TABLE_NO
        SUBSTR(:NEW.FADD,4,2),-- FEEDER_ZAXIS
        :NEW.FSADD             ,-- FEEDER_LRAXIS

        '*',
        '*',
        '*',

        NVL(:NEW.PARTSNAME,'*'),       --AS ITEM_CODE,
        'T'       ,--AS DATA_TYPE,      -- T : TAKE_UP, M :MISS, R:RmISS

        TO_DATE(:NEW.FILE_NAME ,'YYYYMMDDHH24MISS') ,--AS SHIFT_DATE,
        LVD_ACTUAL_DATE,   --？？？？？？？？？？？ ？？？
        LVS_WORKTIME_ZONE, --？？？？？？？？？？？ TIME ZONE

        LVL_PIKUP,         --TAKUP ？？？？

        0,
        0,
        sysdate,
        'TAKEUP',
        LVD_ACT_DATE,
        'TAKEUP',
        LVS_WORKTIME_ZONE,
        '*',
        'NPM'

      ) ;
      --RECOG MISS
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
        PROGRAM_NAME,
        MACHINE_TYPE

      )
      VALUES (
        :NEW.LINE_CODE,
        :NEW.MACHINE_CODE||NVL(:NEW.MCNO,'*'),

        :NEW.FADD,
        :NEW.FSADD,
        '*',

        SUBSTR(:NEW.FADD,1,3),-- TABLE_NO
        SUBSTR(:NEW.FADD,4,2),-- FEEDER_ZAXIS
        :NEW.FSADD             ,-- FEEDER_LRAXIS

        '*',
        '*',
        '*',

        NVL(:NEW.PARTSNAME,'*'),       --AS ITEM_CODE,
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
        '*',
        'NPM'

      ) ;
      --PICK UP MISS
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
        PROGRAM_NAME,
        MACHINE_TYPE

      )
      VALUES (
        :NEW.LINE_CODE,
        :NEW.MACHINE_CODE||NVL(:NEW.MCNO,'*'),

        :NEW.FADD,
        :NEW.FSADD,
        '*',

        SUBSTR(:NEW.FADD,1,3),-- TABLE_NO
        SUBSTR(:NEW.FADD,4,2),-- FEEDER_ZAXIS
        :NEW.FSADD             ,-- FEEDER_LRAXIS

        '*',
        '*',
        '*',

        NVL(:NEW.PARTSNAME,'*'),       --AS ITEM_CODE,
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
        '*',
        'NPM'

      ) ;


    ELSE                 --？？？？？？PDATE
      /* UPDATE */
      UPDATE IQ_MACHINE_INSPECT_PICKUP_RATE
         SET  head_sum =  head_sum + LVL_PIKUP,

              LAST_UPDATED_DATE = LVD_ACT_DATE ,
              LAST_UPDATE_BY    = 'TAKEUP',
              TACT_TIME         = (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24,
              TACT_TIME_01      = ( TACT_TIME + ( (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24 ) ) / DECODE(NVL(TACT_TIME,0),0,1,2) ,
              ENTER_DATE        = SYSDATE
       WHERE LINE_CODE    = :NEW.LINE_CODE
         AND MACHINE_CODE = :NEW.MACHINE_CODE||NVL(:NEW.MCNO,'*')
         AND ADDRESS      = :NEW.FADD
         AND SUB_ADDRESS  = :NEW.FSADD
         AND ITEM_CODE    = NVL(:NEW.PARTSNAME,'*')
         AND ACTUAL_DATE  = LVD_ACTUAL_DATE   --LVD_DATE
         AND ACTUAL_TIME  = LVS_WORKTIME_ZONE --LVS_TIME
         AND DATA_TYPE    = 'T'
         AND PROGRAM_NAME = '*'  ;

      /* UPDATE */
      UPDATE IQ_MACHINE_INSPECT_PICKUP_RATE
         SET  head_sum =  head_sum + LVL_RMISS,

              LAST_UPDATED_DATE = LVD_ACT_DATE ,
              LAST_UPDATE_BY    = 'RMISS',
              TACT_TIME         = (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24,
              TACT_TIME_01      = ( TACT_TIME + ( (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24 ) ) / DECODE(NVL(TACT_TIME,0),0,1,2) ,
              ENTER_DATE        = SYSDATE
       WHERE LINE_CODE    = :NEW.LINE_CODE
         AND MACHINE_CODE = :NEW.MACHINE_CODE||NVL(:NEW.MCNO,'*')
         AND ADDRESS      = :NEW.FADD
         AND SUB_ADDRESS  = :NEW.FSADD
         AND ITEM_CODE    = NVL(:NEW.PARTSNAME,'*')
         AND ACTUAL_DATE  = LVD_ACTUAL_DATE   --LVD_DATE
         AND ACTUAL_TIME  = LVS_WORKTIME_ZONE --LVS_TIME
         AND DATA_TYPE    = 'R'
         AND PROGRAM_NAME = '*'  ;


      /* UPDATE */
      UPDATE IQ_MACHINE_INSPECT_PICKUP_RATE
         SET  head_sum =  head_sum +LVL_TMISS,

              LAST_UPDATED_DATE = LVD_ACT_DATE ,
              LAST_UPDATE_BY    = 'MISS',
              TACT_TIME         = (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24,
              TACT_TIME_01      = ( TACT_TIME + ( (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24 ) ) / DECODE(NVL(TACT_TIME,0),0,1,2) ,
              ENTER_DATE        = SYSDATE
       WHERE LINE_CODE    = :NEW.LINE_CODE
         AND MACHINE_CODE = :NEW.MACHINE_CODE||NVL(:NEW.MCNO,'*')
         AND ADDRESS      = :NEW.FADD
         AND SUB_ADDRESS  = :NEW.FSADD
         AND ITEM_CODE    = NVL(:NEW.PARTSNAME,'*')
         AND ACTUAL_DATE  = LVD_ACTUAL_DATE   --LVD_DATE
         AND ACTUAL_TIME  = LVS_WORKTIME_ZONE --LVS_TIME
         AND DATA_TYPE    = 'M'
         AND PROGRAM_NAME = '*'  ;

    END IF;
  END IF; --FEEDER SERIAL ？？°？？

EXCEPTION

  WHEN OTHERS THEN

    lvs_errm :=lvs_errm||substr(sqlerrm,1,300);
   -- insert into a ( a ) values (TO_CHAR(LVD_ACTUAL_DATE,'YYYYMMDD')|| LVS_WORKTIME_ZONE ||' PMNT4 TRP MISS'||lvs_errm ) ;
    NULL ;

end TR_IQ_MACHINE_PMNT4_INS;