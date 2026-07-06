TRIGGER "TR_IQ_MACHINE_INSP_SMNT2_INS"
  AFTER INSERT ON iq_machine_inspect_smnt2 for each row
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
  LVS_DATE VARCHAR2(20);

  LVS_WORKTIME_ZONE VARCHAR2(2);
  lvs_errm varchar(4000);
  
  LVS_STEP   VARCHAR2(100);


begin


    IF LENGTH(TRIM(:NEW.FILE_NAME)) > 1 AND :NEW.PICKUP > 0  THEN
    LVS_DATE          := REGEXP_SUBSTR(:NEW.FILE_NAME,'\d\d\d\d\d\d\d\d\d\d\d\d\d\d');
    LVD_ACT_DATE      := TO_DATE(LVS_DATE ,'YYYYMMDDHH24MISS') ;
    LVD_DATE          := TO_DATE(substr(LVS_DATE,1,8) ,'YYYYMMDD');
    LVS_TIME          := substr(LVS_DATE,9,2);
    LVS_WORKTIME_ZONE := F_GET_WORKTIME_ZONE(TO_CHAR(LVD_DATE,'YYYYMMDD'), TO_CHAR(LVD_ACT_DATE,'HH24MI')) ;
    LVD_ACTUAL_DATE   := TO_DATE(F_GET_WORKTIME_ZONE(TO_CHAR(LVD_DATE,'YYYYMMDD'), TO_CHAR(LVD_ACT_DATE,'HH24MI'),'DATE')  ,'YYYYMMDD') ;
 
    lvs_errm           := :NEW.LINE_CODE||:NEW.MACHINE_CODE||NVL('*','*')||:NEW.SLOTNO||:NEW.FEEDERBASEID||:NEW.PARTNAME ;


    BEGIN

      SELECT COUNT(*)
        INTO LVL_CNT
        FROM IQ_MACHINE_INSPECT_PICKUP_RATE
       WHERE LINE_CODE    = :NEW.LINE_CODE
         AND MACHINE_CODE = :NEW.MACHINE_CODE
         AND ADDRESS      = :NEW.FEEDERBASEID||:NEW.SLOTNO
         AND SUB_ADDRESS  = 'B'
         AND ITEM_CODE    = :NEW.PARTNAME
         AND ACTUAL_DATE  = LVD_ACTUAL_DATE   --LVD_DATE
         AND ACTUAL_TIME  = LVS_WORKTIME_ZONE --LVS_TIME
         --AND DATA_TYPE    = 'R'             --TMISS, RMISSs
         AND PROGRAM_NAME = :NEW.MODEL_NAME;

    EXCEPTION
      WHEN OTHERS THEN

         LVL_CNT := 0 ;
    END ;

    LVL_PIKUP := NVL(:NEW.PLACE,0);    
    LVL_TMISS := NVL(:NEW.PICKERROR + :NEW.DUMP ,0);   
    LVL_RMISS := NVL(:NEW.VISIONERROR, 0);
       

    IF LVL_CNT = 0 THEN -- ？？？

LVS_STEP := '110';  

    INSERT INTO IQ_MACHINE_INSPECT_PICKUP_RATE (
        line_code,                -- 1.
        machine_code,             -- 2.
        address,                  -- 3.
        sub_address,              -- 4.
        feeder_type,              -- 5.
        table_no,                 -- 6.
        feeder_zaxis,             -- 7.
        feeder_lraxis,            -- 8.
        model_name,               -- 9.
        model_suffix,             -- 10.
        parent_item_code,         -- 11.
        pcb_item,                 -- 12.
        item_code,                -- 13.
        data_type,                -- 14.
        shift_date,               -- 15. ？？？ ？？？？？？？ð？
        actual_date,              -- 16. ？？？？？？？？？？？ ？？？？ð？
        actual_time,              -- 17. ？？？？？？？？？？？ TIME ZONE
        head_sum,                                       -- 18.
        TACT_TIME,                                      -- 19.
        TACT_TIME_01,                                   -- 20.
        created_date,                                   -- 21.
        create_by,                                      -- 22.
        LAST_UPDATED_DATE,                              -- 23.
        LAST_UPDATE_BY,                                 -- 24.
        WORK_TIME_ZONE,                                 -- 25.
        PROGRAM_NAME,                                   -- 26.
        MACHINE_TYPE                                    -- 27.
      )
      VALUES (
        :NEW.LINE_CODE,                              -- 1. line_code
        :NEW.MACHINE_CODE,                           -- 2. machine_code

      --  replace(:NEW.MACHINE_CODE,'Machine_','')||:NEW.FEEDERBASEID||:NEW.SLOTNO,              -- address
        :NEW.FEEDERBASEID||:NEW.SLOTNO,              -- address
        'B',                                         -- sub_address
        '*',                                         -- feeder_type

       -- replace(:NEW.MACHINE_CODE,'Machine_','')||:NEW.FEEDERBASEID,                           -- TABLE_NO
        :NEW.FEEDERBASEID,                           -- TABLE_NO
       
        :NEW.SLOTNO,                                -- FEEDER_ZAXIS
        '0',                                         -- FEEDER_LRAXIS

        substr(:new.model_name,1,instr(:new.model_name,'-')-1), -- 9.model_name
        :NEW.MODEL_SUFFIX,                           -- 10. model_suffix
        substr(:NEW.FILE_NAME, instr(:NEW.FILE_NAME,'-',1,1)+1, instr(:NEW.FILE_NAME,'-',1,2)  - instr(:NEW.FILE_NAME,'-',1,1)-1),  -- 11. parent_item_code
        decode(sign(instr(:NEW.FILE_NAME,'TOP')),1,'T',decode(sign(instr(:NEW.FILE_NAME,'BOT')),1,'B','*')),                        -- 12. pcb_item
        NVL(:NEW.PARTNAME,'*'),                      -- 13. AS ITEM_CODE,
        'T',                                         -- 14. AS DATA_TYPE,       -- T : TAKE_UP, M :MISS, R:RmISS
        LVD_ACT_DATE,                                -- 15. AS SHIFT_DATE,
        LVD_ACTUAL_DATE,                             -- 16. ？？？？？？？？？？？ ？？？
        LVS_WORKTIME_ZONE,                           -- 17. ？？？？？？？？？？？ TIME ZONE
        LVL_PIKUP,                                   -- 18. TAKUP ？？
        0,                                           -- 19. TACT_TIME
        0,                                           -- 20. TACT_TIME_01
        sysdate,                                     -- 21. created_date
        'SMNT2',                                     -- 22. create_by
        LVD_ACTUAL_DATE,                             -- 23. LAST_UPDATED_DATE
        'SMNT2',                                     -- 24. LAST_UPDATE_BY
        LVS_WORKTIME_ZONE,                           -- 25. WORK_TIME_ZONE
        :NEW.MODEL_NAME,                             -- 26. PROGRAM_NAME
        NULL                                         -- 27. MACHINE_TYPE
      ) ;

LVS_STEP := '120';  

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
        parent_item_code,
        pcb_item,

        item_code,
        data_type,

        shift_date,     --??? ???????？？?
        actual_date,    --??????????? ????？？?
        actual_time,    --??????????? TIME ZONE

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
        :NEW.LINE_CODE,                              -- line_code
        :NEW.MACHINE_CODE,                           -- machine_code

       -- replace(:NEW.MACHINE_CODE,'Machine_','')||:NEW.FEEDERBASEID||:NEW.SLOTNO,              -- address
        :NEW.FEEDERBASEID||:NEW.SLOTNO,              -- address
        'B',                                         -- sub_address
        '*',                                         -- feeder_type

        --replace(:NEW.MACHINE_CODE,'Machine_','')||:NEW.FEEDERBASEID,                           -- TABLE_NO
        :NEW.FEEDERBASEID,                           -- TABLE_NO
        :NEW.SLOTNO,                                -- FEEDER_ZAXIS
        '0',                                         -- FEEDER_LRAXIS

        substr(:new.model_name,1,instr(:new.model_name,'-')-1),  -- model_name
        :NEW.MODEL_SUFFIX,                           -- model_suffix
        substr(:NEW.FILE_NAME, instr(:NEW.FILE_NAME,'-',1,1)+1, instr(:NEW.FILE_NAME,'-',1,2)  - instr(:NEW.FILE_NAME,'-',1,1)-1),  -- parent_item_code
        decode(sign(instr(:NEW.FILE_NAME,'TOP')),1,'T',decode(sign(instr(:NEW.FILE_NAME,'BOT')),1,'B','*')),               -- pcb_item

        NVL(:NEW.PARTNAME,'*'),                      -- AS ITEM_CODE,
        'R'       ,                                  -- AS DATA_TYPE,       -- T : TAKE_UP, M :MISS, R:RmISS

        LVD_ACT_DATE,                                -- AS SHIFT_DATE,
        LVD_ACTUAL_DATE,                             -- ??????????? ???
        LVS_WORKTIME_ZONE,                           -- ??????????? TIME ZONE

        LVL_RMISS,                                   -- TAKUP ????

        0,                                           -- TACT_TIME
        0,                                           -- TACT_TIME_01
        sysdate,                                     -- created_date
        'SMNT2',                                     -- create_by
        LVD_ACTUAL_DATE,                             -- LAST_UPDATED_DATE
        'SMNT2',                                     -- LAST_UPDATE_BY
        LVS_WORKTIME_ZONE,                           -- WORK_TIME_ZONE
        :NEW.MODEL_NAME,                             -- PROGRAM_NAME
        NULL                                         -- MACHINE_TYPE

      ) ;

LVS_STEP := '130';  

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
        parent_item_code,
        pcb_item,

        item_code,
        data_type,

        shift_date,     --??? ???????？？?
        actual_date,    --??????????? ????？？?
        actual_time,    --??????????? TIME ZONE

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
        :NEW.LINE_CODE,                              -- line_code
        :NEW.MACHINE_CODE,                           -- machine_code

      --  replace(:NEW.MACHINE_CODE,'Machine_','')||:NEW.FEEDERBASEID||:NEW.SLOTNO,              -- address
        :NEW.FEEDERBASEID||:NEW.SLOTNO,              -- address
        'B',                                         -- sub_address
        '*',                                         -- feeder_type

     --   replace(:NEW.MACHINE_CODE,'Machine_','')||:NEW.FEEDERBASEID,                           -- TABLE_NO
        :NEW.FEEDERBASEID,                           -- TABLE_NO
        :NEW.SLOTNO,                                -- FEEDER_ZAXIS
        '0',                                         -- FEEDER_LRAXIS

        substr(:new.model_name,1,instr(:new.model_name,'-')-1), -- model_name
        :NEW.MODEL_SUFFIX,                           -- model_suffix
        substr(:NEW.FILE_NAME, instr(:NEW.FILE_NAME,'-',1,1)+1, instr(:NEW.FILE_NAME,'-',1,2)  - instr(:NEW.FILE_NAME,'-',1,1)-1),  -- parent_item_code
        decode(sign(instr(:NEW.FILE_NAME,'TOP')),1,'T',decode(sign(instr(:NEW.FILE_NAME,'BOT')),1,'B','*')),               -- pcb_item

        NVL(:NEW.PARTNAME,'*'),                      -- AS ITEM_CODE,
        'M'       ,                                  -- AS DATA_TYPE,       -- T : TAKE_UP, M :MISS, R:RmISS

        LVD_ACT_DATE,                                -- AS SHIFT_DATE,
        LVD_ACTUAL_DATE,                             -- ??????????? ???
        LVS_WORKTIME_ZONE,                           -- ??????????? TIME ZONE

        LVL_TMISS,                                   -- TAKUP ????

        0,                                           -- TACT_TIME
        0,                                           -- TACT_TIME_01
        sysdate,                                     -- created_date
        'SMNT2',                                     -- create_by
        LVD_ACTUAL_DATE,                             -- LAST_UPDATED_DATE
        'SMNT2',                                     -- LAST_UPDATE_BY
        LVS_WORKTIME_ZONE,                           -- WORK_TIME_ZONE
        :NEW.MODEL_NAME,                             -- PROGRAM_NAME
        NULL                                         -- MACHINE_TYPE

      ) ;


    ELSE                 --？？？？？？PDATE
      
LVS_STEP := '210';      

      /* UPDATE */
      UPDATE IQ_MACHINE_INSPECT_PICKUP_RATE
         SET  head_sum          =  LVL_PIKUP,
              LAST_UPDATED_DATE = LVD_ACTUAL_DATE ,
              LAST_UPDATE_BY    = 'TAKEUP',
              TACT_TIME         = (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24,
              TACT_TIME_01      = ( TACT_TIME + ( (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24 ) ) / DECODE(NVL(TACT_TIME,0),0,1,2) ,
              ENTER_DATE        = SYSDATE
       WHERE LINE_CODE    = :NEW.LINE_CODE
         AND MACHINE_CODE = :NEW.MACHINE_CODE
         AND FEEDER_ZAXIS     = :NEW.SLOTNO
        -- AND TABLE_NO   = replace(:NEW.MACHINE_CODE,'Machine_','')||:NEW.FEEDERBASEID
         AND TABLE_NO     = :NEW.FEEDERBASEID
         AND ITEM_CODE    = NVL(:NEW.PARTNAME,'*')
         AND ACTUAL_DATE  = LVD_ACTUAL_DATE   --LVD_DATE
         AND ACTUAL_TIME  = LVS_WORKTIME_ZONE --LVS_TIME
         AND DATA_TYPE    = 'T'
         AND PROGRAM_NAME = :NEW.MODEL_NAME;

LVS_STEP := '220';

      /* UPDATE */
      UPDATE IQ_MACHINE_INSPECT_PICKUP_RATE
         SET  head_sum          =  LVL_RMISS,
              LAST_UPDATED_DATE = LVD_ACT_DATE ,
              LAST_UPDATE_BY    = 'RMISS',
              TACT_TIME         = (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24,
              TACT_TIME_01      = ( TACT_TIME + ( (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24 ) ) / DECODE(NVL(TACT_TIME,0),0,1,2) ,
              ENTER_DATE        = SYSDATE
       WHERE LINE_CODE    = :NEW.LINE_CODE
         AND MACHINE_CODE = :NEW.MACHINE_CODE
        -- AND FEEDER_ZAXIS     = replace(:NEW.MACHINE_CODE,'Machine_','')||:NEW.SLOTNO
         AND FEEDER_ZAXIS     = :NEW.SLOTNO
         AND TABLE_NO     = :NEW.FEEDERBASEID
         AND ITEM_CODE    = NVL(:NEW.PARTNAME,'*')
         AND ACTUAL_DATE  = LVD_ACTUAL_DATE   --LVD_DATE
         AND ACTUAL_TIME  = LVS_WORKTIME_ZONE --LVS_TIME
         AND DATA_TYPE    = 'R'
         AND PROGRAM_NAME = :NEW.MODEL_NAME;

LVS_STEP := '230';

      /* UPDATE */
      UPDATE IQ_MACHINE_INSPECT_PICKUP_RATE
         SET  head_sum          =  LVL_TMISS,
              LAST_UPDATED_DATE =  LVD_ACT_DATE ,
              LAST_UPDATE_BY    = 'MISS',
              TACT_TIME         = (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24,
              TACT_TIME_01      = ( TACT_TIME + ( (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24 ) ) / DECODE(NVL(TACT_TIME,0),0,1,2) ,
              ENTER_DATE        = SYSDATE
       WHERE LINE_CODE    = :NEW.LINE_CODE
         AND MACHINE_CODE = :NEW.MACHINE_CODE
         AND FEEDER_ZAXIS     = :NEW.SLOTNO
        -- AND TABLE_NO   = replace(:NEW.MACHINE_CODE,'Machine_','')||:NEW.FEEDERBASEID
         AND TABLE_NO     = :NEW.FEEDERBASEID
         AND ITEM_CODE    = NVL(:NEW.PARTNAME,'*')
         AND ACTUAL_DATE  = LVD_ACTUAL_DATE   --LVD_DATE
         AND ACTUAL_TIME  = LVS_WORKTIME_ZONE --LVS_TIME
         AND DATA_TYPE    = 'M'
         AND PROGRAM_NAME = :NEW.MODEL_NAME;

    END IF;
  END IF;  --FEEDER SERIAL ？？°？？

EXCEPTION

  WHEN DUP_VAL_ON_INDEX THEN
       NULL;

  WHEN OTHERS THEN

    lvs_errm :=lvs_errm||substr(sqlerrm,1,500);

    insert into ICOM_MACHINE_INSERT_LOG (LOG_DATE , ERROR_MESSAGE , ERROR_DESC  )
    values (sysdate ,'TR_IQ_MACHINE_INSP_SMNT2_INS' , TO_CHAR(LVD_ACTUAL_DATE,'YYYYMMDD')|| LVS_WORKTIME_ZONE ||' SMNT2 TRG MISS >> '||lvs_errm||' >> STEP '||LVS_STEP ) ;

end;
