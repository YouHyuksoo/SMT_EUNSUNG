CREATE OR REPLACE PROCEDURE "P_INSERT_SMNT1_RAW" (
  /* ================================================================
   * 프로시저명  : P_INSERT_SMNT1_RAW
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   SMT 장비 SMNT1 원시 검사 데이터를 배열 파라미터에서 읽어 저장한다.
   *   파일명, 라인, 설비, 모델 정보를 p_info/p_data에서 추출한다.
   *   IQ_MACHINE_INSPECT_SMNT1에 장비별 측정/에러 데이터를 등록한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_DATA (IN, ARRAY5_PARAMS_T) - 장비 원시 데이터 배열
   *   P_INFO (IN, ARRAY5_PARAMS_T) - 파일/라인/설비 등 부가 정보 배열
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_MACHINE_INSPECT_SMNT1 - SMNT1 장비 원시 검사 데이터 테이블
   *   ICOM_MACHINE_INSERT_LOG - 장비 데이터 입력 오류 로그 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS/NO_DATA_FOUND 등 원본 예외 처리 흐름을 유지한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 로직 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_INSERT_SMNT1_RAW(:P_DATA, :P_INFO)
   * ================================================================ */
   p_data          IN ARRAY5_PARAMS_T, -- [AI] 내부 처리용 변수
   p_info          IN ARRAY5_PARAMS_T -- [AI] 내부 처리용 변수
)
IS
     LVS_ERRORMSG      VARCHAR2 (500); -- [AI] 내부 처리용 변수
     LVS_FILE_NAME     VARCHAR2 (100) := ''; -- [AI] 내부 처리용 변수
     LVS_LINE_CODE     VARCHAR2 (100) := ''; -- [AI] 내부 처리용 변수
     LVS_MACHINE_CODE  VARCHAR2 (100) := ''; -- [AI] 내부 처리용 변수
     LVS_MODEL         VARCHAR2 (100) := ''; -- [AI] 내부 처리용 변수

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

  if p_data.Last >= 8 --Model=
     then
    LVS_MODEL :=  TRIM(p_data(8));
  end if;

     INSERT INTO IQ_MACHINE_INSPECT_SMNT1

      (     gantryid,
            headid,
            pickup,
            place,
            pickerror,
            visionerror,
            dump,
            model_name,

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

        LVS_MODEL,

        SYSDATE ,
        'SYSTEM' ,
        SYSDATE ,
        'SYSTEM' ,
        1,
        REPLACE(TRIM(LVS_FILE_NAME),'"'),
        LVS_LINE_CODE,
        LVS_MACHINE_CODE,
        TO_CHAR(SYSDATE ,'YYMMDDHH24MISS')
        );

      COMMIT ;
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
      LVS_ERRORMSG := '[P_INSERT_SMNT1_RAW]' ||  SUBSTR(SQLERRM,1,200)  ;
      INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC )
       VALUES ( SYSDATE  , LVS_ERRORMSG  , lvs_file_name||' LINE='||lvs_line_code  ) ;
      COMMIT ;
      NULL;

END P_INSERT_SMNT1_RAW;
