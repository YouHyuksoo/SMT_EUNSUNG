CREATE OR REPLACE PROCEDURE "P_INSERT_PMNT4_RAW" (
  /* ================================================================
   * 프로시저명  : P_INSERT_PMNT4_RAW
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   외부 또는 설비에서 전달된 원시/연계 데이터를 대상 테이블에 등록한다.
   *   입력 파라미터와 원본 로직의 테이블 조작 흐름은 그대로 유지했다.
   *   오류 발생 시 원본 예외 처리 방식에 따라 메시지 반환 또는 로그 처리를 수행한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_PLOTINFO - 원본 선언부 기준 입력/출력 파라미터
   *   P_INFO - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ICOM_MACHINE_INSERT_LOG - 원본 로직 참조 테이블
   *   IQ_MACHINE_INSPECT_PMNT4 - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   P_INFO
   *   P_PLOTINFO
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_INSERT_PMNT4_RAW(...)
   * ================================================================ */
   p_plotinfo     IN ARRAY3_PARAMS_T,
   p_info          IN ARRAY3_PARAMS_T
)
IS
  -- p_plotinfo[] : MCNo,Lane,FAdd,FSAdd,PartsName,FeederSerial,Pickup,PMiss,RMiss,DMiss,MMiss,HMiss,TRSMiss,ChangeCount
  -- p_info : filename,line_code,machine_code,filepath
     LVS_ERRORMSG      VARCHAR2 (300); -- [AI] 내부 처리용 변수
     LVS_FILE_NAME     VARCHAR2 (50) := ''; -- [AI] 내부 처리용 변수
     LVS_LINE_CODE     VARCHAR2 (30) := ''; -- [AI] 내부 처리용 변수
     LVS_MACHINE_CODE     VARCHAR2 (30) := ''; -- [AI] 내부 처리용 변수
     LVS_PROGRAM_NAME     VARCHAR2 (30) := ''; -- [AI] 내부 처리용 변수
     LVS_LOG_DATE         VARCHAR2 (30) := '';      -- [AI] 내부 처리용 변수
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
      LVS_ERRORMSG := '[P_INSERT_PMNT4_RAW]' ||  SUBSTR(SQLERRM,1,200)  ;
     --  INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC ) 
      -- VALUES ( SYSDATE  , LVS_ERRORMSG  , lvs_file_name||' LINE='||lvs_line_code  ) ;
     -- COMMIT ;
      NULL;

END P_INSERT_PMNT4_RAW;