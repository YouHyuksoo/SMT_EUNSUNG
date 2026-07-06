CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TR_IQ_MACHINE_INSPEC_PMNT2_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IQ_MACHINE_INSPECT_PMNT2 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IQ_MACHINE_INSPECT_PMNT2 - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.LOG_DATE - 신규/변경 후 로그 / 일자 관련 값
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   *   :NEW.MACHINE_CODE - 신규/변경 후 설비 관련 값
   *   :NEW.ADDRESS - 신규/변경 후 값 값
   *   :NEW.SUBADD - 신규/변경 후 값 값
   *   :NEW.NAME - 신규/변경 후 명칭 관련 값
   *   :NEW.PROGRAM_NAME - 신규/변경 후 명칭 관련 값
   *   :NEW.NPA - 신규/변경 후 값 값
   *   :NEW.NPB - 신규/변경 후 값 값
   *   :NEW.NPC - 신규/변경 후 값 값
   *   :NEW.NPD - 신규/변경 후 값 값
   *   :NEW.NPE - 신규/변경 후 값 값
   *   :NEW.NPF - 신규/변경 후 값 값
   *   :NEW.NPG - 신규/변경 후 값 값
   *   :NEW.NPH - 신규/변경 후 값 값
   *   :NEW.NPI - 신규/변경 후 값 값
   *   :NEW.NPJ - 신규/변경 후 값 값
   *   :NEW.NPK - 신규/변경 후 값 값
   *   :NEW.NPL - 신규/변경 후 값 값
   *   :NEW.FDRTYPE - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_MACHINE_INSPECT_PMNT2 - 설비 / 검사 관련 트리거 대상 테이블
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
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TR_IQ_MACHINE_INSPEC_PMNT2_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TR_IQ_MACHINE_INSPEC_PMNT2_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TR_IQ_MACHINE_INSPEC_PMNT2_INS" 
  AFTER INSERT ON IQ_MACHINE_INSPECT_PMNT2
  for each row
declare
  /****************************************************************************************************
     TIME ZONE ?? ?????? ?????? ????.
     Pick Up data ???? ?????? ???? ?????? ?????????? ???????? ???? ???? ?????? ???????? ???? ???? ???? ???? ???????? ??.
     HEAD SUM ?? ????????  ???? ?????? ?????? ?????? ???? ??????

  *****************************************************************************************************/
  -- local variables here
  LVD_ACT_DATE DATE ;   --????????????
  LVD_DATE DATE ;
  LVD_ACTUAL_DATE DATE; --???????? ?????? ????
  LVS_TIME VARCHAR2(2);
  LVL_CNT  NUMBER ;
  LVL_SUM  NUMBER ;

  LVS_WORKTIME_ZONE VARCHAR2(2);
  lvs_errm varchar(4000);


begin

  LVD_ACT_DATE := TO_DATE(:NEW.LOG_DATE,'YYYY/MM/DD,HH24:MI:SS') ;            --????????????
  LVD_DATE     := TRUNC(TO_DATE(:NEW.LOG_DATE,'YYYY/MM/DD,HH24:MI:SS'));
  LVS_TIME     := TO_CHAR(TO_DATE(:NEW.LOG_DATE,'YYYY/MM/DD,HH24:MI:SS'),'HH24');

  LVS_WORKTIME_ZONE := F_GET_WORKTIME_ZONE(TO_CHAR(LVD_DATE,'YYYYMMDD'), TO_CHAR(LVD_ACT_DATE,'HH24MI')) ;
  LVD_ACTUAL_DATE   := TO_DATE(  F_GET_WORKTIME_ZONE(TO_CHAR(LVD_DATE,'YYYYMMDD'), TO_CHAR(LVD_ACT_DATE,'HH24MI'),'DATE')  ,'YYYYMMDD') ;

  BEGIN
    SELECT COUNT(*)
      INTO LVL_CNT
      FROM IQ_MACHINE_INSPECT_PICKUP_RATE
     WHERE LINE_CODE    = :NEW.LINE_CODE
       AND MACHINE_CODE = :NEW.MACHINE_CODE
       AND ADDRESS      = :NEW.ADDRESS
       AND SUB_ADDRESS  = :NEW.SUBADD
       AND ITEM_CODE    = :NEW.NAME
       AND ACTUAL_DATE  = LVD_ACTUAL_DATE   --LVD_DATE
       AND ACTUAL_TIME  = LVS_WORKTIME_ZONE --LVS_TIME
       AND DATA_TYPE    = 'M'
       AND PROGRAM_NAME = NVL(:NEW.PROGRAM_NAME,'*')  ;

  EXCEPTION
    WHEN OTHERS THEN

       LVL_CNT := 0 ;
  END ;


  LVL_SUM :=  NVL(:NEW.NPA,0) +
              NVL(:NEW.NPB,0) +
              NVL(:NEW.NPC,0) +
              NVL(:NEW.NPD,0) +
              NVL(:NEW.NPE,0) +
              NVL(:NEW.NPF,0) +
              NVL(:NEW.NPG,0) +
              NVL(:NEW.NPH,0) +
              NVL(:NEW.NPI,0) +
              NVL(:NEW.NPJ,0) +
              NVL(:NEW.NPK,0) +
              NVL(:NEW.NPL,0) ;

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
      PROGRAM_NAME

    )
    VALUES (
      :NEW.LINE_CODE,
      :NEW.MACHINE_CODE,

      :NEW.ADDRESS,
      :NEW.SUBADD,
      :NEW.FDRTYPE,

      SUBSTR(:NEW.ADDRESS,1,3),-- TABLE_NO
      SUBSTR(:NEW.ADDRESS,4,2),-- FEEDER_ZAXIS
      :NEW.SUBADD             ,-- FEEDER_LRAXIS

      '*',
      '*',
      '*',

      :NEW.NAME ,--AS ITEM_CODE,
      'M'       ,--AS DATA_TYPE,      -- T : TAKE_UP, M :MISS, R:RmISS

      TO_DATE(:NEW.LOG_DATE,'YYYY/MM/DD,HH24:MI:SS') ,--AS SHIFT_DATE,
      LVD_ACTUAL_DATE,   --???????? ?????? ????
      LVS_WORKTIME_ZONE, --???????? ?????? TIME ZONE

      LVL_SUM,

      :NEW.NPA,
      :NEW.NPB,
      :NEW.NPC,
      :NEW.NPD,
      :NEW.NPE,
      :NEW.NPF,
      :NEW.NPG,
      :NEW.NPH,
      :NEW.NPI,
      :NEW.NPJ,
      :NEW.NPK,
      :NEW.NPL,
      0,
      0,
      SYSDATE,
      'MISS',
      LVD_ACT_DATE,
      'MISS',
      LVS_WORKTIME_ZONE,
      NVL(:NEW.PROGRAM_NAME,'*')

    ) ;
  ELSE                 --???????? UPDATE


    /* UPDATE */
    UPDATE IQ_MACHINE_INSPECT_PICKUP_RATE
       SET  head_sum =  LVL_SUM  ,
            head01   = :NEW.NPA  ,
            head02   = :NEW.NPB  ,
            head03   = :NEW.NPC  ,
            head04   = :NEW.NPD  ,
            head05   = :NEW.NPE  ,
            head06   = :NEW.NPF  ,
            head07   = :NEW.NPG  ,
            head08   = :NEW.NPH  ,
            head09   = :NEW.NPI  ,
            head10   = :NEW.NPJ  ,
            head11   = :NEW.NPK  ,
            head12   = :NEW.NPL  ,

            LAST_UPDATED_DATE = LVD_ACT_DATE ,
            LAST_UPDATE_BY    = 'MISS',
            TACT_TIME         = (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24,
            TACT_TIME_01      = ( TACT_TIME + ( (LVD_ACT_DATE - LAST_UPDATED_DATE) * 60 * 60 * 24 ) ) / DECODE(NVL(TACT_TIME,0),0,1,2) ,
            ENTER_DATE        = SYSDATE
     WHERE LINE_CODE    = :NEW.LINE_CODE
       AND MACHINE_CODE = :NEW.MACHINE_CODE
       AND ADDRESS      = :NEW.ADDRESS
       AND SUB_ADDRESS  = :NEW.SUBADD
       AND ITEM_CODE    = :NEW.NAME
       AND ACTUAL_DATE  = LVD_ACTUAL_DATE   --LVD_DATE
       AND ACTUAL_TIME  = LVS_WORKTIME_ZONE --LVS_TIME
       AND DATA_TYPE    = 'M'
       AND PROGRAM_NAME = NVL(:NEW.PROGRAM_NAME,'*') ;

  END IF;


EXCEPTION

  WHEN OTHERS THEN
    lvs_errm :=lvs_errm||substr(sqlerrm,1,300);
  --  insert into a ( a ) values (TO_CHAR(LVD_ACTUAL_DATE,'YYYYMMDD')|| LVS_WORKTIME_ZONE||' '||lvs_errm ) ;
    NULL ;

end TR_IQ_MACHINE_INSPEC_PMNT2_INS;
