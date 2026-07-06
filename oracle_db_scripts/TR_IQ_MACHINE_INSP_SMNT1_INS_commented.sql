CREATE OR REPLACE TRIGGER "TR_IQ_MACHINE_INSP_SMNT1_INS"
  /* ================================================================
   * 트리거명  : TR_IQ_MACHINE_INSP_SMNT1_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IQ_MACHINE_INSPECT_SMNT1 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IQ_MACHINE_INSPECT_SMNT1 - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.FILE_NAME - 신규/변경 후 명칭 관련 값
   *   :NEW.PICKUP - 신규/변경 후 값 값
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   *   :NEW.MACHINE_CODE - 신규/변경 후 설비 관련 값
   *   :NEW.MEAS_TIME - 신규/변경 후 시간 관련 값
   *   :NEW.GANTRYID - 신규/변경 후 값 값
   *   :NEW.HEADID - 신규/변경 후 값 값
   *   :NEW.MODEL_NAME - 신규/변경 후 모델 / 명칭 관련 값
   *   :NEW.PLACE - 신규/변경 후 값 값
   *   :NEW.PICKERROR - 신규/변경 후 값 값
   *   :NEW.DUMP - 신규/변경 후 값 값
   *   :NEW.VISIONERROR - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_MACHINE_INSPECT_SMNT1 - 설비 / 검사 관련 트리거 대상 테이블
   *   IQ_MACHINE_INSPECT_PICKUP_RATE - 설비 / 검사 / 율 관련 트리거 내부 SQL에서 참조/변경
   *   ICOM_MACHINE_INSERT_LOG - 설비 / 로그 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_WORKTIME_ZONE - 트리거 내부 업무 처리 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 5회, UPDATE 6회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TR_IQ_MACHINE_INSP_SMNT1_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TR_IQ_MACHINE_INSP_SMNT1_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */

  AFTER INSERT ON iq_machine_inspect_smnt1 for each row
declare
  /****************************************************************************************************
     NPM ????? ?? 10?？？????? ?????
     ?????? ?????????????
  *****************************************************************************************************/

  -- local variables here
  LVD_ACT_DATE DATE ;   --?????????
  LVD_DATE DATE ;
  LVD_ACTUAL_DATE DATE; --??????????? ???
  LVS_TIME VARCHAR2(2);
  LVL_CNT  NUMBER ;
  LVL_SUM  NUMBER ;
  LVL_PIKUP NUMBER ;
  LVL_RMISS NUMBER ;
  LVL_TMISS NUMBER ;
  LVS_DATE VARCHAR2(20);
    
  LVS_STEP   VARCHAR2(100);

  LVL_PARTNAME VARCHAR2(30);

  LVS_WORKTIME_ZONE VARCHAR2(2);
  lvs_errm varchar(4000);


begin

    
    IF LENGTH(TRIM(:NEW.FILE_NAME)) > 1 AND :NEW.PICKUP > 0 THEN
    LVS_DATE          := REGEXP_SUBSTR(:NEW.FILE_NAME,'\d\d\d\d\d\d\d\d\d\d\d\d\d\d');
    LVD_ACT_DATE      := TO_DATE(LVS_DATE ,'YYYYMMDDHH24MISS') ;            --?????????
    LVD_DATE          := TO_DATE(substr(LVS_DATE,1,8) ,'YYYYMMDD');
    LVS_TIME          := substr(LVS_DATE,9,2);
    LVL_PARTNAME      := 'HEAD';
    LVS_WORKTIME_ZONE := F_GET_WORKTIME_ZONE(TO_CHAR(LVD_DATE,'YYYYMMDD'), TO_CHAR(LVD_ACT_DATE,'HH24MI')) ;
    LVD_ACTUAL_DATE   := TO_DATE(F_GET_WORKTIME_ZONE(TO_CHAR(LVD_DATE,'YYYYMMDD'), TO_CHAR(LVD_ACT_DATE,'HH24MI'),'DATE')  ,'YYYYMMDD') ;
    
    lvs_errm          := :NEW.LINE_CODE||:NEW.MACHINE_CODE||NVL('*','*')||NVL(:NEW.MEAS_TIME,'*')||:NEW.GANTRYID||LVL_PARTNAME;

    BEGIN

      SELECT COUNT(*)
        INTO LVL_CNT
        FROM IQ_MACHINE_INSPECT_PICKUP_RATE
       WHERE LINE_CODE    = :NEW.LINE_CODE
         AND MACHINE_CODE = :NEW.MACHINE_CODE
         AND ADDRESS      = :NEW.GANTRYID||:NEW.Headid
         AND SUB_ADDRESS  = 'H'
         AND ITEM_CODE    = LVL_PARTNAME
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

    IF LVL_CNT = 0 THEN --???      --takeup ????
      
LVS_STEP := '110';    

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
        head01,
        head02,
        head03,
        head04,
        head05,
        head06,
        head07,
        head08,
        head09,
        head10,
        head11,
        head12,

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

        :NEW.GANTRYID||:NEW.Headid,                  -- address
        'H',                                         -- sub_address
        '*',                                         -- feeder_type

        :NEW.GANTRYID,                               -- TABLE_NO
        :NEW.Headid,                                 -- FEEDER_ZAXIS
        '*',                                           -- FEEDER_LRAXIS

        substr(:new.model_name,1,instr(:new.model_name,'-')-1),                             -- model_name
        '*',                                         -- model_suffix
        substr(:NEW.FILE_NAME, instr(:NEW.FILE_NAME,'-',1,1)+1, instr(:NEW.FILE_NAME,'-',1,2)  - instr(:NEW.FILE_NAME,'-',1,1)-1),                                         -- parent_item_code
        decode(sign(instr(:NEW.FILE_NAME,'TOP')),1,'T',decode(sign(instr(:NEW.FILE_NAME,'BOT')),1,'B','*')), -- pcb_item

        LVL_PARTNAME,                                -- AS ITEM_CODE,
        'T'       ,                                  -- AS DATA_TYPE,       -- T : TAKE_UP, M :MISS, R:RmISS

        LVD_ACT_DATE,                                -- AS SHIFT_DATE,
        LVD_ACTUAL_DATE,                             -- ??????????? ???
        LVS_WORKTIME_ZONE,                           -- ??????????? TIME ZONE

        LVL_PIKUP,                                   -- TAKUP ????
        DECODE(:NEW.HEADID, 1,LVL_PIKUP,0),
        DECODE(:NEW.HEADID, 2,LVL_PIKUP,0),
        DECODE(:NEW.HEADID, 3,LVL_PIKUP,0),
        DECODE(:NEW.HEADID, 4,LVL_PIKUP,0),
        DECODE(:NEW.HEADID, 5,LVL_PIKUP,0),
        DECODE(:NEW.HEADID, 6,LVL_PIKUP,0),
        DECODE(:NEW.HEADID, 7,LVL_PIKUP,0),
        DECODE(:NEW.HEADID, 8,LVL_PIKUP,0),
        DECODE(:NEW.HEADID, 9,LVL_PIKUP,0),
        DECODE(:NEW.HEADID,10,LVL_PIKUP,0),
        DECODE(:NEW.HEADID,11,LVL_PIKUP,0),
        DECODE(:NEW.HEADID,12,LVL_PIKUP,0),

        0,                                           -- TACT_TIME
        0,                                           -- TACT_TIME_01
        sysdate,                                     -- created_date
        'SMNT1',                                     -- create_by
        LVD_ACTUAL_DATE,                             -- LAST_UPDATED_DATE
        'SMNT1',                                     -- LAST_UPDATE_BY
        LVS_WORKTIME_ZONE,                           -- WORK_TIME_ZONE
        :NEW.MODEL_NAME,                             -- PROGRAM_NAME
        NULL                                         -- MACHINE_TYPE

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
        head01,
        head02,
        head03,
        head04,
        head05,
        head06,
        head07,
        head08,
        head09,
        head10,
        head11,
        head12,

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

        :NEW.GANTRYID||:NEW.Headid,                  -- address
        'H',                                         -- sub_address
        '*',                                         -- feeder_type

        :NEW.GANTRYID,                               -- TABLE_NO
        :NEW.Headid,                                 -- FEEDER_ZAXIS
        '*',                                         -- FEEDER_LRAXIS

        substr(:new.model_name,1,instr(:new.model_name,'-')-1),                             -- model_name
        '*',                                         -- model_suffix
        substr(:NEW.FILE_NAME, instr(:NEW.FILE_NAME,'-',1,1)+1, instr(:NEW.FILE_NAME,'-',1,2)  - instr(:NEW.FILE_NAME,'-',1,1)-1),     -- parent_item_code
        decode(sign(instr(:NEW.FILE_NAME,'TOP')),1,'T',decode(sign(instr(:NEW.FILE_NAME,'BOT')),1,'B','*')), -- pcb_item

        LVL_PARTNAME,                                -- AS ITEM_CODE,
        'R'       ,                                  -- AS DATA_TYPE,       -- T : TAKE_UP, M :MISS, R:RmISS

        LVD_ACT_DATE,                                -- AS SHIFT_DATE,
        LVD_ACTUAL_DATE,                             -- ??????????? ???
        LVS_WORKTIME_ZONE,                           -- ??????????? TIME ZONE

        LVL_RMISS,                                   -- TAKUP ????
        DECODE(:NEW.HEADID, 1,LVL_RMISS,0),
        DECODE(:NEW.HEADID, 2,LVL_RMISS,0),
        DECODE(:NEW.HEADID, 3,LVL_RMISS,0),
        DECODE(:NEW.HEADID, 4,LVL_RMISS,0),
        DECODE(:NEW.HEADID, 5,LVL_RMISS,0),
        DECODE(:NEW.HEADID, 6,LVL_RMISS,0),
        DECODE(:NEW.HEADID, 7,LVL_RMISS,0),
        DECODE(:NEW.HEADID, 8,LVL_RMISS,0),
        DECODE(:NEW.HEADID, 9,LVL_RMISS,0),
        DECODE(:NEW.HEADID,10,LVL_RMISS,0),
        DECODE(:NEW.HEADID,11,LVL_RMISS,0),
        DECODE(:NEW.HEADID,12,LVL_RMISS,0),

        0,                                           -- TACT_TIME
        0,                                           -- TACT_TIME_01
        sysdate,                                     -- created_date
        'SMNT1',                                     -- create_by
        LVD_ACTUAL_DATE,                             -- LAST_UPDATED_DATE
        'SMNT1',                                     -- LAST_UPDATE_BY
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
        head01,
        head02,
        head03,
        head04,
        head05,
        head06,
        head07,
        head08,
        head09,
        head10,
        head11,
        head12,

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

        :NEW.GANTRYID||:NEW.Headid,                  -- address
        'H',                                         -- sub_address
        '*',                                         -- feeder_type
        
        :NEW.GANTRYID,                               -- TABLE_NO
        :NEW.Headid,                                 -- FEEDER_ZAXIS
        '*',                                         -- FEEDER_LRAXIS

        substr(:new.model_name,1,instr(:new.model_name,'-')-1),                             -- model_name
        '*',                                         -- model_suffix
        substr(:NEW.FILE_NAME, instr(:NEW.FILE_NAME,'-',1,1)+1, instr(:NEW.FILE_NAME,'-',1,2)  - instr(:NEW.FILE_NAME,'-',1,1)-1),    -- parent_item_code
        decode(sign(instr(:NEW.FILE_NAME,'TOP')),1,'T',decode(sign(instr(:NEW.FILE_NAME,'BOT')),1,'B','*')),  -- pcb_item

        LVL_PARTNAME,                                -- AS ITEM_CODE,
        'M'       ,                                  -- AS DATA_TYPE,       -- T : TAKE_UP, M :MISS, R:RmISS

        LVD_ACT_DATE,                                -- AS SHIFT_DATE,
        LVD_ACTUAL_DATE,                             -- ??????????? ???
        LVS_WORKTIME_ZONE,                           -- ??????????? TIME ZONE

        LVL_TMISS,                                   -- TAKUP ????
        DECODE(:NEW.HEADID, 1,LVL_TMISS,0),
        DECODE(:NEW.HEADID, 2,LVL_TMISS,0),
        DECODE(:NEW.HEADID, 3,LVL_TMISS,0),
        DECODE(:NEW.HEADID, 4,LVL_TMISS,0),
        DECODE(:NEW.HEADID, 5,LVL_TMISS,0),
        DECODE(:NEW.HEADID, 6,LVL_TMISS,0),
        DECODE(:NEW.HEADID, 7,LVL_TMISS,0),
        DECODE(:NEW.HEADID, 8,LVL_TMISS,0),
        DECODE(:NEW.HEADID, 9,LVL_TMISS,0),
        DECODE(:NEW.HEADID,10,LVL_TMISS,0),
        DECODE(:NEW.HEADID,11,LVL_TMISS,0),
        DECODE(:NEW.HEADID,12,LVL_TMISS,0),

        0,                                           -- TACT_TIME
        0,                                           -- TACT_TIME_01
        sysdate,                                     -- created_date
        'SMNT1',                                     -- create_by
        LVD_ACTUAL_DATE,                             -- LAST_UPDATED_DATE
        'SMNT1',                                     -- LAST_UPDATE_BY
        LVS_WORKTIME_ZONE,                           -- WORK_TIME_ZONE
        :NEW.MODEL_NAME,                             -- PROGRAM_NAME
        NULL                                         -- MACHINE_TYPE -- NPM: ？？？？, ？？？？？？ NULL o？？

      ) ;


    ELSE                 --??????PDATE

LVS_STEP := '210'; 

      /* UPDATE */
      UPDATE IQ_MACHINE_INSPECT_PICKUP_RATE
         SET  head_sum = DECODE(:NEW.HEADID, 1,LVL_PIKUP,head01) + DECODE(:NEW.HEADID, 2,LVL_PIKUP,head02) + DECODE(:NEW.HEADID, 3,LVL_PIKUP,head03) + DECODE(:NEW.HEADID, 4,LVL_PIKUP,head04) + DECODE(:NEW.HEADID, 5,LVL_PIKUP,head05) + DECODE(:NEW.HEADID, 6,LVL_PIKUP,head06) + DECODE(:NEW.HEADID, 7,LVL_PIKUP,head07)+ DECODE(:NEW.HEADID, 8,LVL_PIKUP,head08) + DECODE(:NEW.HEADID, 9,LVL_PIKUP,head09) + DECODE(:NEW.HEADID, 10,LVL_PIKUP,head10) + DECODE(:NEW.HEADID,11,LVL_PIKUP,head11) + DECODE(:NEW.HEADID,12,LVL_PIKUP,head12),
              head01   = DECODE(:NEW.HEADID, 1,LVL_PIKUP,head01) ,
              head02   = DECODE(:NEW.HEADID, 2,LVL_PIKUP,head02) ,
              head03   = DECODE(:NEW.HEADID, 3,LVL_PIKUP,head03) ,
              head04   = DECODE(:NEW.HEADID, 4,LVL_PIKUP,head04) ,
              head05   = DECODE(:NEW.HEADID, 5,LVL_PIKUP,head05) ,
              head06   = DECODE(:NEW.HEADID, 6,LVL_PIKUP,head06) ,
              head07   = DECODE(:NEW.HEADID, 7,LVL_PIKUP,head07) ,
              head08   = DECODE(:NEW.HEADID, 8,LVL_PIKUP,head08) ,
              head09   = DECODE(:NEW.HEADID, 9,LVL_PIKUP,head09) ,
              head10   = DECODE(:NEW.HEADID,10,LVL_PIKUP,head10) ,
              head11   = DECODE(:NEW.HEADID,11,LVL_PIKUP,head11) ,
              head12   = DECODE(:NEW.HEADID,12,LVL_PIKUP,head12) ,

              LAST_UPDATED_DATE = LVD_ACT_DATE ,
              LAST_UPDATE_BY    = 'TAKEUP',
              TACT_TIME         = (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24,
              TACT_TIME_01      = ( TACT_TIME + ( (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24 ) ) / DECODE(NVL(TACT_TIME,0),0,1,2) ,
              ENTER_DATE        = SYSDATE
       WHERE LINE_CODE    = :NEW.LINE_CODE
         AND MACHINE_CODE = :NEW.MACHINE_CODE
         AND ADDRESS      = :NEW.GANTRYID||:NEW.Headid
         AND SUB_ADDRESS  = 'H'
         AND ITEM_CODE    = LVL_PARTNAME
         AND ACTUAL_DATE  = LVD_ACTUAL_DATE   --LVD_DATE
         AND ACTUAL_TIME  = LVS_WORKTIME_ZONE --LVS_TIME
         AND DATA_TYPE    = 'T'
         AND PROGRAM_NAME = :NEW.MODEL_NAME;

LVS_STEP := '220'; 

      /* UPDATE */
      UPDATE IQ_MACHINE_INSPECT_PICKUP_RATE
         SET  head_sum = DECODE(:NEW.HEADID, 1,LVL_RMISS,head01) + DECODE(:NEW.HEADID, 2,LVL_RMISS,head02) + DECODE(:NEW.HEADID, 3,LVL_RMISS,head03) + DECODE(:NEW.HEADID, 4,LVL_RMISS,head04) + DECODE(:NEW.HEADID, 5,LVL_RMISS,head05) + DECODE(:NEW.HEADID, 6,LVL_RMISS,head06) + DECODE(:NEW.HEADID, 7,LVL_RMISS,head07)+ DECODE(:NEW.HEADID, 8,LVL_RMISS,head08) + DECODE(:NEW.HEADID, 9,LVL_RMISS,head09) + DECODE(:NEW.HEADID,10,LVL_RMISS,head10) + DECODE(:NEW.HEADID,11,LVL_RMISS,head11) + DECODE(:NEW.HEADID,12,LVL_RMISS,head12),
              head01   = DECODE(:NEW.HEADID, 1,LVL_RMISS,head01) ,
              head02   = DECODE(:NEW.HEADID, 2,LVL_RMISS,head02) ,
              head03   = DECODE(:NEW.HEADID, 3,LVL_RMISS,head03) ,
              head04   = DECODE(:NEW.HEADID, 4,LVL_RMISS,head04) ,
              head05   = DECODE(:NEW.HEADID, 5,LVL_RMISS,head05) ,
              head06   = DECODE(:NEW.HEADID, 6,LVL_RMISS,head06) ,
              head07   = DECODE(:NEW.HEADID, 7,LVL_RMISS,head07) ,
              head08   = DECODE(:NEW.HEADID, 8,LVL_RMISS,head08) ,
              head09   = DECODE(:NEW.HEADID, 9,LVL_RMISS,head09) ,
              head10   = DECODE(:NEW.HEADID,10,LVL_RMISS,head10) ,
              head11   = DECODE(:NEW.HEADID,11,LVL_RMISS,head11) ,
              head12   = DECODE(:NEW.HEADID,12,LVL_RMISS,head12) ,

              LAST_UPDATED_DATE = LVD_ACT_DATE ,
              LAST_UPDATE_BY    = 'RMISS',
              TACT_TIME         = (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24,
              TACT_TIME_01      = ( TACT_TIME + ( (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24 ) ) / DECODE(NVL(TACT_TIME,0),0,1,2) ,
              ENTER_DATE        = SYSDATE
       WHERE LINE_CODE    = :NEW.LINE_CODE
         AND MACHINE_CODE = :NEW.MACHINE_CODE
         AND ADDRESS      = :NEW.GANTRYID||:NEW.Headid
         AND SUB_ADDRESS  = 'H'
         AND ITEM_CODE    = LVL_PARTNAME
         AND ACTUAL_DATE  = LVD_ACTUAL_DATE   --LVD_DATE
         AND ACTUAL_TIME  = LVS_WORKTIME_ZONE --LVS_TIME
         AND DATA_TYPE    = 'R'
         AND PROGRAM_NAME = :NEW.MODEL_NAME;

LVS_STEP := '230'; 

      /* UPDATE */
      UPDATE IQ_MACHINE_INSPECT_PICKUP_RATE
         SET  head_sum = DECODE(:NEW.HEADID, 1,LVL_TMISS,head01) + DECODE(:NEW.HEADID, 2,LVL_TMISS,head02) + DECODE(:NEW.HEADID, 3,LVL_TMISS,head03) + DECODE(:NEW.HEADID, 4,LVL_TMISS,head04) + DECODE(:NEW.HEADID, 5,LVL_TMISS,head05) + DECODE(:NEW.HEADID, 6,LVL_TMISS,head06) + DECODE(:NEW.HEADID, 7,LVL_TMISS,head07)+ DECODE(:NEW.HEADID, 8,LVL_TMISS,head08) + DECODE(:NEW.HEADID, 9,LVL_TMISS,head09) + DECODE(:NEW.HEADID,10,LVL_TMISS,head10) + DECODE(:NEW.HEADID,11,LVL_TMISS,head11) + DECODE(:NEW.HEADID,12,LVL_TMISS,head12),
              head01   = DECODE(:NEW.HEADID, 1,LVL_TMISS,head01) ,
              head02   = DECODE(:NEW.HEADID, 2,LVL_TMISS,head02) ,
              head03   = DECODE(:NEW.HEADID, 3,LVL_TMISS,head03) ,
              head04   = DECODE(:NEW.HEADID, 4,LVL_TMISS,head04) ,
              head05   = DECODE(:NEW.HEADID, 5,LVL_TMISS,head05) ,
              head06   = DECODE(:NEW.HEADID, 6,LVL_TMISS,head06) ,
              head07   = DECODE(:NEW.HEADID, 7,LVL_TMISS,head07) ,
              head08   = DECODE(:NEW.HEADID, 8,LVL_TMISS,head08) ,
              head09   = DECODE(:NEW.HEADID, 9,LVL_TMISS,head09) ,
              head10   = DECODE(:NEW.HEADID,10,LVL_TMISS,head10) ,
              head11   = DECODE(:NEW.HEADID,11,LVL_TMISS,head11) ,
              head12   = DECODE(:NEW.HEADID,12,LVL_TMISS,head12) ,

              LAST_UPDATED_DATE = LVD_ACT_DATE ,
              LAST_UPDATE_BY    = 'MISS',
              TACT_TIME         = (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24,
              TACT_TIME_01      = ( TACT_TIME + ( (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24 ) ) / DECODE(NVL(TACT_TIME,0),0,1,2) ,
              ENTER_DATE        = SYSDATE
       WHERE LINE_CODE    = :NEW.LINE_CODE
         AND MACHINE_CODE = :NEW.MACHINE_CODE
         AND ADDRESS      = :NEW.GANTRYID||:NEW.Headid
         AND SUB_ADDRESS  = 'H'
         AND ITEM_CODE    = LVL_PARTNAME
         AND ACTUAL_DATE  = LVD_ACTUAL_DATE   --LVD_DATE
         AND ACTUAL_TIME  = LVS_WORKTIME_ZONE --LVS_TIME
         AND DATA_TYPE    = 'M'
         AND PROGRAM_NAME = :NEW.MODEL_NAME;


    END IF;
    
  END IF; --FEEDER SERIAL ??？？?

EXCEPTION

  WHEN DUP_VAL_ON_INDEX THEN
       NULL;

  WHEN OTHERS THEN

    lvs_errm :=lvs_errm||substr(sqlerrm,1,500);

    insert into ICOM_MACHINE_INSERT_LOG (LOG_DATE , ERROR_MESSAGE , ERROR_DESC  )
    values (sysdate ,'TR_IQ_MACHINE_INSP_SMNT1_INS' , TO_CHAR(LVD_ACTUAL_DATE,'YYYYMMDD')|| LVS_WORKTIME_ZONE ||' SMNT1 TRG MISS >> '||lvs_errm||' >> STEP '||LVS_STEP ) ;


end;
