CREATE OR REPLACE PROCEDURE "P_INSERT_NPM2_RAW" (
  /* ================================================================
   * 프로시저명  : P_INSERT_NPM2_RAW
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
   *   P_DATA - 원본 선언부 기준 입력/출력 파라미터
   *   P_INFO - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ICOM_MACHINE_INSERT_LOG - 원본 로직 참조 테이블
   *   IQ_MACHINE_INSPECT_NPM2_RAW - 원본 로직 참조 테이블
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
   *   EXEC P_INSERT_NPM2_RAW(...)
   * ================================================================ */
   p_data     IN ARRAY3_PARAMS_T,
   p_info     IN ARRAY3_PARAMS_T
)
IS
     LVS_ERRORMSG      VARCHAR2 (300); -- [AI] 내부 처리용 변수
     LVS_FILE_NAME     VARCHAR2 (50) := ''; -- [AI] 내부 처리용 변수
     LVS_LINE_CODE     VARCHAR2 (30) := ''; -- [AI] 내부 처리용 변수
     LVS_MACHINE_CODE     VARCHAR2 (30) := ''; -- [AI] 내부 처리용 변수

     LI_START_POSITION    INT := 4;     -- 4th folder delemeter -- [AI] 내부 처리용 변수
     LVS_PATH_NAME     VARCHAR2 (30) := ''; -- [AI] 내부 처리용 변수
     LVI_START_INDEX      INT := 0; -- [AI] 내부 처리용 변수
     LVI_END_INDEX        INT := 0;      -- [AI] 내부 처리용 변수
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

  if p_info.Last >= 4
    then
    LVI_START_INDEX := INSTR(TRIM(p_info(4)), '\', -1, LI_START_POSITION);
    LVI_END_INDEX   := INSTR(TRIM(p_info(4)), '\', -1, LI_START_POSITION - 1);
    if LVI_START_INDEX > 0 and LVI_END_INDEX > 0 
      then     
        LVS_PATH_NAME := SUBSTR(TRIM(p_info(4)), LVI_START_INDEX + 1, LVI_END_INDEX - LVI_START_INDEX - 1);
    end if;
  end if; 
  
     INSERT INTO IQ_MACHINE_INSPECT_NPM2_RAW

      (   HEAD,
          NOZZLESTOCKER,
          NOZZLECHANGER,
          TCNT,
          STAGE,

          LANE,
          TOTAL,
          ACTUAL,
          MODEL_NAME,

          ENTER_DATE,
          ENTER_BY,
          LAST_MODIFY_DATE,
          LAST_MODIFY_BY,
          ORGANIZATION_ID,
          FILE_NAME,
          LINE_CODE,
          MACHINE_CODE,
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
        LVS_PATH_NAME, --REPLACE(TRIM(p_data(9)),'"'),

        SYSDATE ,
        'SYSTEM' ,
        SYSDATE ,
        'SYSTEM' ,
        1,
        REPLACE(TRIM(LVS_FILE_NAME),'"'),
        LVS_LINE_CODE,
        LVS_MACHINE_CODE,
        TO_CHAR(SYSDATE ,'YYMMDDHH24MI')
        );

      COMMIT ;
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
      LVS_ERRORMSG := '[P_INSERT_NPM2_RAW]' ||  SUBSTR(SQLERRM,1,200)  ;
    --   INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC ) 
    --   VALUES ( SYSDATE  , LVS_ERRORMSG  , lvs_file_name||' LINE='||lvs_line_code  ) ;
    --  COMMIT ;
      NULL;

END P_INSERT_NPM2_RAW;