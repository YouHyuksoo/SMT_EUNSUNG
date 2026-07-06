CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TR_IQ_MACHINE_INS_NPM1_RAW_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IQ_MACHINE_INSPECT_NPM1_RAW 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IQ_MACHINE_INSPECT_NPM1_RAW - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.FILE_NAME - 신규/변경 후 명칭 관련 값
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   *   :NEW.MACHINE_CODE - 신규/변경 후 설비 관련 값
   *   :NEW.MODEL_NAME - 신규/변경 후 모델 / 명칭 관련 값
   *   :NEW.UNIT - 신규/변경 후 값 값
   *   :NEW.SIDE - 신규/변경 후 값 값
   *   :NEW.TCNT - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_MACHINE_INSPECT_NPM1_RAW - 설비 / 검사 관련 트리거 대상 테이블
   *   IQ_MACHINE_INSPECT_PICKUP_RATE - 설비 / 검사 / 율 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_WORKTIME_ZONE - 트리거 내부 업무 처리 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 3회, UPDATE 3회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TR_IQ_MACHINE_INS_NPM1_RAW_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TR_IQ_MACHINE_INS_NPM1_RAW_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TR_IQ_MACHINE_INS_NPM1_RAW_INS" 
  AFTER INSERT ON IQ_MACHINE_INSPECT_NPM1_RAW   for each row
declare
  /****************************************************************************************************
   PICK-UP RATE TABLE KEY :: LINE_CODE, MACHINE_CODE, PROGRAM_NAME, ADDRESS, SUB_ADDRESS, ITEM_CODE, ACTUAL_DATE, ACTUAL_TIME, DATA_TYPE
                             01                                     UNIT     HEAD         *
  *****************************************************************************************************/
  -- local variables here
  LVD_ACT_DATE DATE ;   --
  LVD_DATE DATE ;
  LVD_ACTUAL_DATE DATE; --
  LVS_TIME VARCHAR2(2);
  LVL_CNT  NUMBER ;
  LVL_SUM  NUMBER ;

  LVS_WORKTIME_ZONE VARCHAR2(2);
  lvs_errm varchar(4000);


begin

  LVD_ACT_DATE := TO_DATE(:NEW.FILE_NAME,'YYYYMMDDHH24MISS') ;            --????????????
  LVD_DATE     := TRUNC(TO_DATE(:NEW.FILE_NAME,'YYYYMMDDHH24MISS'));
  LVS_TIME     := TO_CHAR(TO_DATE(:NEW.FILE_NAME,'YYYYMMDDHH24MISS'),'HH24');

  LVS_WORKTIME_ZONE := F_GET_WORKTIME_ZONE(TO_CHAR(LVD_DATE,'YYYYMMDD'), TO_CHAR(LVD_ACT_DATE,'HH24MI')) ;
  LVD_ACTUAL_DATE   := TO_DATE(  F_GET_WORKTIME_ZONE(TO_CHAR(LVD_DATE,'YYYYMMDD'), TO_CHAR(LVD_ACT_DATE,'HH24MI'),'DATE')  ,'YYYYMMDD') ;

  BEGIN
    SELECT COUNT(*)
      INTO LVL_CNT
      FROM IQ_MACHINE_INSPECT_PICKUP_RATE
     WHERE LINE_CODE    = :NEW.LINE_CODE
       AND MACHINE_CODE = :NEW.MACHINE_CODE||NVL(:NEW.MODEL_NAME,'*')
       AND ADDRESS      = :NEW.UNIT
       AND SUB_ADDRESS  = :NEW.SIDE
       AND ITEM_CODE    = '*'  --ITEM_CODE
       AND ACTUAL_DATE  = LVD_ACTUAL_DATE   --LVD_DATE
       AND ACTUAL_TIME  = LVS_WORKTIME_ZONE --LVS_TIME
       AND DATA_TYPE    = 'T'
       AND PROGRAM_NAME = NVL(:NEW.MODEL_NAME,'*')  ;

  EXCEPTION
    WHEN OTHERS THEN

       LVL_CNT := 0 ;
  END ;


  LVL_SUM :=  NVL(:NEW.TCNT,0) ; --Tacke Up ？？？？

  IF LVL_CNT = 0 THEN --????
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

      shift_date,     --???? ???????? ????
      actual_date,    --???????? ?????? ???? ????
      actual_time,    --???????? ?????? TIME ZONE

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

      :NEW.UNIT,
      :NEW.SIDE,
      '*',

      SUBSTR(:NEW.UNIT,1,3),-- TABLE_NO
      SUBSTR(:NEW.UNIT,4,2),-- FEEDER_ZAXIS
      :NEW.SIDE            ,-- FEEDER_LRAXIS

      '*',
      '*',
      '*',

      '*' ,--AS ITEM_CODE,
      'T'       ,--AS DATA_TYPE,      -- T : TAKE_UP, M :MISS, R:RmISS

      TO_DATE(:NEW.FILE_NAME,'YYYYMMDDHH24MISS') ,--AS SHIFT_DATE,
      LVD_ACTUAL_DATE,   --???????? ?????? ????
      LVS_WORKTIME_ZONE, --???????? ?????? TIME ZONE

      LVL_SUM,

      0,
      0,
      SYSDATE,
      'TAKE',
      LVD_ACT_DATE,
      'TAKE',
      LVS_WORKTIME_ZONE,
      NVL(:NEW.MODEL_NAME,'*')

    ) ;
  ELSE                 --???????? UPDATE


    /* UPDATE */
    UPDATE IQ_MACHINE_INSPECT_PICKUP_RATE
       SET  head_sum =  LVL_SUM,

            LAST_UPDATED_DATE = LVD_ACT_DATE ,
            LAST_UPDATE_BY    = 'TAKE',
            TACT_TIME         = (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24,
            TACT_TIME_01      = ( TACT_TIME + ( (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24 ) ) / DECODE(NVL(TACT_TIME,0),0,1,2) ,
            ENTER_DATE        = sysdate
     WHERE LINE_CODE    = :NEW.LINE_CODE
       AND MACHINE_CODE = :NEW.MACHINE_CODE||NVL(:NEW.MODEL_NAME,'*')
       AND ADDRESS      = :NEW.UNIT
       AND SUB_ADDRESS  = :NEW.SIDE
       AND ITEM_CODE    = '*'
       AND ACTUAL_DATE  = LVD_ACTUAL_DATE   --LVD_DATE
       AND ACTUAL_TIME  = LVS_WORKTIME_ZONE --LVS_TIME
       AND DATA_TYPE    = 'T'
       AND PROGRAM_NAME = NVL(:NEW.MODEL_NAME,'*') ;

  END IF;


EXCEPTION

  WHEN OTHERS THEN
    lvs_errm :=lvs_errm||substr(sqlerrm,1,300);
 --   insert into a ( a ) values (TO_CHAR(LVD_ACTUAL_DATE,'YYYYMMDD')|| LVS_WORKTIME_ZONE||' PMNT'||lvs_errm ) ;
    NULL ;

end TR_IQ_MACHINE_INS_NPM1_RAW_INS;
