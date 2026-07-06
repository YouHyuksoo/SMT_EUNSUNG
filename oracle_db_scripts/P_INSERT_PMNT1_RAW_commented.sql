CREATE OR REPLACE PROCEDURE "P_INSERT_PMNT1_RAW" (
  /* ================================================================
   * 프로시저명  : P_INSERT_PMNT1_RAW
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   외부 또는 설비에서 전달된 원시/연계 데이터를 대상 테이블에 등록한다.
   *   입력 파라미터와 원본 로직의 데이터 적재 흐름은 그대로 유지했다.
   *   오류 발생 시 원본 예외 처리 방식에 따라 메시지 반환 또는 로그 처리를 수행한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_DATA - 원본 선언부 기준 입력/출력 파라미터
   *   P_INFO - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ICOM_MACHINE_INSERT_LOG - 원본 로직 참조 테이블
   *   IQ_MACHINE_INSPECT_PMNT1 - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   P_DATA
   *   P_INFO
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_INSERT_PMNT1_RAW(...)
   * ================================================================ */
   p_data          IN ARRAY3_PARAMS_T,
   p_info          IN ARRAY3_PARAMS_T
)
IS
     LVS_ERRORMSG      VARCHAR2 (300); -- [AI] 내부 처리용 변수
     LVS_FILE_NAME     VARCHAR2 (50) := ''; -- [AI] 내부 처리용 변수
     LVS_LINE_CODE     VARCHAR2 (30) := ''; -- [AI] 내부 처리용 변수
     LVS_MACHINE_CODE     VARCHAR2 (30) := ''; -- [AI] 내부 처리용 변수
     LVS_PROGRAM_NAME     VARCHAR2 (50) := ''; -- [AI] 내부 처리용 변수
     LVS_LOG_DATE         VARCHAR2 (30) := ''; -- [AI] 내부 처리용 변수
     
     LS_FIND_PATTERN      VARCHAR2(30) := 'PRODUCT'; -- [AI] 내부 처리용 변수
     LI_FIND_POSITION     INT := 35; --PRODUCT...(35th)H790-BOT(16G) -- [AI] 내부 처리용 변수
     LVI_START_PRODUCT     INT := 0; -- [AI] 내부 처리용 변수
     
     LVS_MACHINE_TYPE  VARCHAR2(20) ; --CM601-1 -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.

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

  if p_data.Last >= 69 -- #1=(1st line)
     then
    if LVI_START_PRODUCT = 0 then
      LVI_START_PRODUCT := INSTR(p_data(69), LS_FIND_PATTERN, 1,1);
      if LVI_START_PRODUCT > 0 
        then
        LVS_PROGRAM_NAME :=  TRIM(SUBSTR(p_data(69),LVI_START_PRODUCT + LI_FIND_POSITION, INSTR(p_data(69), ' ', LVI_START_PRODUCT,1) - LVI_START_PRODUCT - LI_FIND_POSITION));
        --LVS_PROGRAM_NAME :=   p_data(69); 
        LVS_MACHINE_TYPE := TRIM(SUBSTR(p_data(69), INSTR(p_data(69),'CM',1,1), 7 )); 
        
        --DEBUG
        IF SUBSTR(LVS_MACHINE_TYPE,1,2) <> 'CM' THEN
          begin 
                LVS_ERRORMSG := '[P_INSERT_PMNT1_RAW] ' || 'SUBSTR(LVS_MACHINE_TYPE,1,2) <> CM' ;
           --     INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC ) 
           --          VALUES ( SYSDATE  , LVS_ERRORMSG  , substr(p_data(69),1,2000)  ) ;
          exception 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
            when others then 
              null ;
          end ;
        END IF ;
        --DEBUG 
      end if;
    end if;
  end if;
  
  if p_data.Last >= 70 -- #2=(2nd line)
     then
    if LVI_START_PRODUCT = 0 then
      LVI_START_PRODUCT := INSTR(p_data(70), LS_FIND_PATTERN, 1,1);
      if LVI_START_PRODUCT > 0 
        then
        LVS_PROGRAM_NAME :=  TRIM(SUBSTR(p_data(70),LVI_START_PRODUCT + LI_FIND_POSITION, INSTR(p_data(70), ' ', LVI_START_PRODUCT,1) - LVI_START_PRODUCT - LI_FIND_POSITION));
        --LVS_PROGRAM_NAME :=   p_data(69); 
        LVS_MACHINE_TYPE := TRIM(SUBSTR(p_data(70), INSTR(p_data(70),'CM',1,1), 7 )); 
        
        --DEBUG
        IF SUBSTR(LVS_MACHINE_TYPE,1,2) <> 'CM' THEN
          begin 
                           LVS_ERRORMSG := '[P_INSERT_PMNT1_RAW] ' || 'SUBSTR(LVS_MACHINE_TYPE,1,2) <> CM' ;
           --     INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC ) 
           --          VALUES ( SYSDATE  , LVS_ERRORMSG  , substr(p_data(70),1,2000)  ) ;
          exception 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
            when others then 
              null ;
          end ;
        END IF ;
        --DEBUG 
      end if;
    end if;
  end if;
  
  if p_data.Last >= 71 --Date= 
     then
    LVS_LOG_DATE :=  TRIM(p_data(71));
  end if;

     INSERT INTO IQ_MACHINE_INSPECT_PMNT1

      (     ADDRESS,
            SUBADD,
            FDRTYPE,
            NAME,
            NPA,
            NPB,
            NPC,
            NPD,
            NPE,
            NPF,
            NPG,
            NPH,
            NPI,
            NPJ,
            NPK,
            NPL,
            NS11,
            NS12,
            NS13,
            NS14,
            NS15,
            NS16,
            NS17,
            NS18,
            NS19,
            NS21,
            NS22,
            NS23,
            NS24,
            NS25,
            NS26,
            NS27,
            NS28,
            NS29,
            NS31,
            NS32,
            NS33,
            NS34,
            NS35,
            NS36,
            NS37,
            NS38,
            NS39,
            NS41,
            NS42,
            NS43,
            NS44,
            NS45,
            NS46,
            NS47,
            NS48,
            NS49,
            NS51,
            NS52,
            NS53,
            NS54,
            NS55,
            NS56,
            NS61,
            NS62,
            NS63,
            NS64,
            NS65,
            NS66,
            SNA,
            SNB,
            STA,
            STB,

            PROGRAM_NAME,
            LOG_DATE,

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
        REPLACE(TRIM(p_data(8)),'"'),
        REPLACE(TRIM(p_data(9)),'"'),
        REPLACE(TRIM(p_data(10)),'"'),

        REPLACE(TRIM(p_data(11)),'"'),
        REPLACE(TRIM(p_data(12)),'"'),
        REPLACE(TRIM(p_data(13)),'"'),
        REPLACE(TRIM(p_data(14)),'"'),
        REPLACE(TRIM(p_data(15)),'"'),

        REPLACE(TRIM(p_data(16)),'"'),
        REPLACE(TRIM(p_data(17)),'"'),
        REPLACE(TRIM(p_data(18)),'"'),
        REPLACE(TRIM(p_data(19)),'"'),
        REPLACE(TRIM(p_data(20)),'"'),

        REPLACE(TRIM(p_data(21)),'"'),
        REPLACE(TRIM(p_data(22)),'"'),
        REPLACE(TRIM(p_data(23)),'"'),
        REPLACE(TRIM(p_data(24)),'"'),
        REPLACE(TRIM(p_data(25)),'"'),
        
        REPLACE(TRIM(p_data(26)),'"'),
        REPLACE(TRIM(p_data(27)),'"'),
        REPLACE(TRIM(p_data(28)),'"'),
        REPLACE(TRIM(p_data(29)),'"'),
        REPLACE(TRIM(p_data(30)),'"'), 

        REPLACE(TRIM(p_data(31)),'"'),
        REPLACE(TRIM(p_data(32)),'"'),
        REPLACE(TRIM(p_data(33)),'"'),
        REPLACE(TRIM(p_data(34)),'"'),
        REPLACE(TRIM(p_data(35)),'"'),

        REPLACE(TRIM(p_data(36)),'"'),
        REPLACE(TRIM(p_data(37)),'"'),
        REPLACE(TRIM(p_data(38)),'"'),
        REPLACE(TRIM(p_data(39)),'"'),
        REPLACE(TRIM(p_data(40)),'"'),

        REPLACE(TRIM(p_data(41)),'"'),
        REPLACE(TRIM(p_data(42)),'"'),
        REPLACE(TRIM(p_data(43)),'"'),
        REPLACE(TRIM(p_data(44)),'"'),
        REPLACE(TRIM(p_data(45)),'"'),

        REPLACE(TRIM(p_data(46)),'"'),
        REPLACE(TRIM(p_data(47)),'"'),
        REPLACE(TRIM(p_data(48)),'"'),
        REPLACE(TRIM(p_data(49)),'"'),
        REPLACE(TRIM(p_data(50)),'"'),

        REPLACE(TRIM(p_data(51)),'"'),
        REPLACE(TRIM(p_data(52)),'"'),
        REPLACE(TRIM(p_data(53)),'"'),
        REPLACE(TRIM(p_data(54)),'"'),
        REPLACE(TRIM(p_data(55)),'"'),

        REPLACE(TRIM(p_data(56)),'"'),
        REPLACE(TRIM(p_data(57)),'"'),
        REPLACE(TRIM(p_data(58)),'"'),
        REPLACE(TRIM(p_data(59)),'"'),
        REPLACE(TRIM(p_data(60)),'"'),

        REPLACE(TRIM(p_data(61)),'"'),
        REPLACE(TRIM(p_data(62)),'"'),
        REPLACE(TRIM(p_data(63)),'"'),
        REPLACE(TRIM(p_data(64)),'"'),
        REPLACE(TRIM(p_data(65)),'"'),

        REPLACE(TRIM(p_data(66)),'"'),
        REPLACE(TRIM(p_data(67)),'"'),
        REPLACE(TRIM(p_data(68)),'"'),
        LVS_PROGRAM_NAME,
        LVS_LOG_DATE,

        SYSDATE ,
        'SYSTEM' ,
        SYSDATE ,
        'SYSTEM' ,
        1,
        REPLACE(TRIM(LVS_FILE_NAME),'"'),
        LVS_LINE_CODE,
        LVS_MACHINE_TYPE,  --LVS_MACHINE_CODE 
        TO_CHAR(SYSDATE ,'YYMMDDHH24MI')
        );

      COMMIT ;
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
      LVS_ERRORMSG := '[P_INSERT_PMNT1_RAW]' ||  SUBSTR(SQLERRM,1,200)  ;
      INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC ) 
       VALUES ( SYSDATE  , LVS_ERRORMSG  , lvs_file_name||' LINE='||lvs_line_code  ) ;
      COMMIT ;
      NULL;

END P_INSERT_PMNT1_RAW;