CREATE OR REPLACE PROCEDURE "P_INSERT_AOI_RAW" (
  /* ================================================================
   * 프로시저명  : P_INSERT_AOI_RAW
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   AOI 장비 원시 검사 데이터를 배열 파라미터에서 읽어 저장한다.
   *   파일명, 라인, 설비, 컬럼 수와 검사 데이터를 조합해 동적 SQL로 등록한다.
   *   IQ_MACHINE_INSPECT_DATA_AOI에 AOI 검사 결과 및 불량 정보를 적재한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_DATA (IN, ARRAY5_PARAMS_T) - AOI 원시 데이터 배열
   *   P_INFO (IN, ARRAY5_PARAMS_T) - 파일/라인/설비 등 부가 정보 배열
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_MACHINE_INSPECT_DATA_AOI - AOI 장비 검사 원시 데이터 테이블
   *   ICOM_MACHINE_INSERT_LOG - 장비 데이터 입력 오류 로그 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS/NO_DATA_FOUND 등 원본 예외 처리 흐름을 유지한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 로직 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_INSERT_AOI_RAW(:P_DATA, :P_INFO)
   * ================================================================ */
   p_data   IN ARRAY5_PARAMS_T, -- [AI] 내부 처리용 변수
   p_info   IN ARRAY5_PARAMS_T) -- [AI] 내부 처리용 변수
IS
   lvs_file_name      VARCHAR2 (200) := ''; -- [AI] 내부 처리용 변수
   lvs_line_code      VARCHAR2 (20) := ''; -- [AI] 내부 처리용 변수
   lvs_machine_code   VARCHAR2 (20) := ''; -- [AI] 내부 처리용 변수
   lvs_sql            VARCHAR2 (30000); -- [AI] 내부 처리용 변수
   LVS_ERRORMSG       VARCHAR2 (32000); -- [AI] 내부 처리용 변수
   
   lvs_column_count   VARCHAR2 (20) := ''; -- [AI] 내부 처리용 변수
   
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
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
   
   lvs_column_count :=  to_char( p_data.LAST ); 

   INSERT INTO IQ_MACHINE_INSPECT_DATA_AOI (                                     
                                                  pid, 
                                                  array_no, 
                                                  crd,
                                                  part_name, 
                                                  result, 
                                                  review_result,
                                                  defect_code,
                                                  
                                                  enter_date,
                                                  enter_by,
                                                  last_modify_date,
                                                  last_modify_by,
                                                  organization_id,
                                                  file_name,
                                                  line_code,
                                                  machine_code,
                                                  
                                                  cstid,
                                                  equipmentid,
                                                  inspect_date,   
                                                   run_no,                                          
                                                  c7,
                                                  review_date,
                                                  job_file
                                                 )
                                 VALUES (
                                         REPLACE (TRIM (p_data(1)), '"'),
                                         NULL,
                                         NULL,
                                         NULL,
                                         REPLACE (TRIM (p_data(5)), '"'),
                                         REPLACE (TRIM (p_data(6)), '"'),
                                         NULL,

                                         sysdate,
                                         'FILE WATCHER',
                                         sysdate,
                                         'FILE WATCHER',
                                         1,
                                         lvs_file_name,
                                         lvs_line_code,
                                         lvs_machine_code,
                                         
                                         '*', 
                                         lvs_machine_code,
                                         to_char( to_date( REPLACE (TRIM (p_data(2)), '"'), 'YYYYMMDDHH24MISS'), 'YYYY/MM/DD HH24:MI:SS' ),  -- 20201014155941  
                                        '*',
                                         NULL,
                                         to_char( to_date( REPLACE (TRIM (p_data(3)), '"'), 'YYYYMMDDHH24MISS'), 'YYYY/MM/DD HH24:MI:SS' ),  -- 20201014155941  
                                         
                                         REPLACE (TRIM (p_data(4)), '"')
                                         );
   
   COMMIT;
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN

      LVS_ERRORMSG :=
         '[P_INSERT_AOI_RAW]' || lvs_sql || SUBSTR (SQLERRM, 1, 200);
   ROLLBACK ;
         INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC )
       VALUES ( SYSDATE  , LVS_ERRORMSG  , 'FILE = '||lvs_file_name||', LINE = '||lvs_line_code||', COLUMN COUNT = ' || lvs_column_count ) ;

      COMMIT;
      
END P_INSERT_AOI_RAW;
