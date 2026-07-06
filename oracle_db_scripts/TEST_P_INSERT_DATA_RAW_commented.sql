CREATE OR REPLACE PROCEDURE "TEST_P_INSERT_DATA_RAW" (
  /* ================================================================
   * 프로시저명  : TEST_P_INSERT_DATA_RAW
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
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
   *   TEST_DATA_RAW - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   PS_JOB_ERRORLOG
   *   P_DATA
   *   P_INFO
   *   TEST_DATA_RAW
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC TEST_P_INSERT_DATA_RAW(...)
   * ================================================================ */
   p_data   IN ARRAY5_PARAMS_T,
   p_info   IN ARRAY5_PARAMS_T)
IS
   lvs_file_name      VARCHAR2 (200) := ''; -- [AI] 내부 처리용 변수
   lvs_line_code      VARCHAR2 (20) := ''; -- [AI] 내부 처리용 변수
   lvs_machine_code   VARCHAR2 (20) := ''; -- [AI] 내부 처리용 변수
   lvs_file_path      VARCHAR2 (3000) := ''; -- [AI] 내부 처리용 변수
   lvs_sql            VARCHAR2 (30000); -- [AI] 내부 처리용 변수
   LVS_ERRORMSG       VARCHAR2 (32000); -- [AI] 내부 처리용 변수

   li_key_count       int := 0; -- [AI] 내부 처리용 변수
   
   --lvs_info5          VARCHAR2 (3000) := '';
   --lvs_info5_str1     VARCHAR2 (100) := '';
   --lvs_info5_str2     VARCHAR2 (3000) := '';

   --lvs_str1        VARCHAR2 (100) := '';
   --lvs_str2        VARCHAR2 (100) := '';
   --lvs_str3        VARCHAR2 (100) := '';
   --lvs_str4        VARCHAR2 (100) := '';
   --lvs_str5        VARCHAR2 (100) := '';
   --lvs_str6        VARCHAR2 (100) := '';
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
   --********************************************************************
   -- info ????????
   --********************************************************************

   IF p_info.LAST >= 1
   THEN
      lvs_file_name := REPLACE (TRIM (p_info (1)), '"');
   END IF;

   IF p_info.LAST >= 2
   THEN
      lvs_line_code := REPLACE (TRIM (p_info (2)), '"');
   END IF;

   IF p_info.LAST >= 3
   THEN
      lvs_machine_code := REPLACE (TRIM (p_info (3)), '"');
   END IF;

   IF p_info.LAST >= 4
   THEN
      lvs_file_path := REPLACE (TRIM (p_info (4)), '"');
   END IF;

   --********************************************************************
   -- data ??????????
   --********************************************************************

   lvs_sql := 'INSERT INTO TEST_DATA_RAW ( C1';


   FOR i IN p_data.FIRST + 1 .. p_data.LAST + li_key_count
   LOOP
      lvs_sql := lvs_sql || ', C' || i;
   END LOOP;

   lvs_sql := lvs_sql
        || ',
            ENTER_DATE       ,
            ENTER_BY         ,
            LAST_MODIFY_DATE ,
            LAST_MODIFY_BY   ,
            ORGANIZATION_ID  ,
            FILE_NAME        ,
            LINE_CODE        ,
            MACHINE_CODE     ,
            RUN_NO           ,
            FILE_PATH
            )
              VALUES
            (';

   lvs_sql := lvs_sql || '''' || REPLACE (REPLACE (TRIM (p_data (1)), '"'), '''') || '''';

   FOR i IN p_data.FIRST + 1 .. p_data.LAST
   LOOP
      lvs_sql := lvs_sql || ', ''' || REPLACE (REPLACE (TRIM (p_data (i)), '"'), '''') || '''';
   END LOOP;

   lvs_sql := lvs_sql
      || ','
      || 'SYSDATE'
      || ','
      || ''''
      || 'SYSTEM'
      || ''''
      || ','
      || 'SYSDATE'
      || ','
      || ''''
      || 'SYSTEM'
      || ''''
      || ','
      || '1'
      || ','
      || ''''
      || lvs_file_name
      || ''''
      || ','
      || ''''
      || lvs_line_code
      || ''''
      || ','
      || ''''
      || lvs_machine_code
      || ''''
      || ','
      || ''''
      || '*'
      || ''''
      || ','
      || ''''
      || lvs_file_path
      || ''''
      || ')';

   EXECUTE IMMEDIATE lvs_sql;

   COMMIT;
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
      LVS_ERRORMSG :=
         '[TEST_P_INSERT_DATA_RAW]'|| SUBSTR (SQLERRM, 1, 200)|| lvs_sql;

    --   INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC )
     --  VALUES ( SYSDATE  , LVS_ERRORMSG  , lvs_file_name||' LINE='||lvs_line_code  ) ;
      ps_job_errorlog(990,1,'TEST_P_INSERT_DATA_RAW','RAW',LVS_ERRORMSG,'FFF');
      COMMIT;
      NULL;
END "TEST_P_INSERT_DATA_RAW";
