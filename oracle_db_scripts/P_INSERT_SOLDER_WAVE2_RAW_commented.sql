CREATE OR REPLACE PROCEDURE P_INSERT_SOLDER_WAVE2_RAW (
  /* ================================================================
   * 프로시저명  : P_INSERT_SOLDER_WAVE2_RAW
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2021-02-17
   * 수정이력:
   *   2021-02-17 - 지성솔루션컨설팅 - 최초 작성
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
   *   IQ_MACHINE_INSPECT_DATA_WAVE2 - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_RUN_NO_BY_PID
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
   *   EXEC P_INSERT_SOLDER_WAVE2_RAW(...)
   * ================================================================ */
                                                       p_data   IN ARRAY5_PARAMS_T,
                                                       p_info   IN ARRAY5_PARAMS_T
                                                     )
IS

   lvs_file_name      VARCHAR2 (200) := ''; -- [AI] 내부 처리용 변수
   lvs_line_code      VARCHAR2 (20) := ''; -- [AI] 내부 처리용 변수
   lvs_machine_code   VARCHAR2 (20) := ''; -- [AI] 내부 처리용 변수
   lvs_mode           VARCHAR2 (20) := ''; -- [AI] 내부 처리용 변수
   lvs_result         VARCHAR2 (20) := ''; -- [AI] 내부 처리용 변수
   lvs_column_count   VARCHAR2 (20) := ''; -- [AI] 내부 처리용 변수
   
   lvs_sql            VARCHAR2 (30000); -- [AI] 내부 처리용 변수
   LVS_ERRORMSG       VARCHAR2 (32000); -- [AI] 내부 처리용 변수
   
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
  
   IF p_info.LAST >= 1 THEN
      lvs_file_name := REPLACE (TRIM (p_info (1)), '"');
   END IF;

   IF p_info.LAST >= 2 THEN
      lvs_line_code := REPLACE (TRIM (p_info (2)), '"');
   END IF;

   IF p_info.LAST >= 3 THEN
      lvs_machine_code := REPLACE (TRIM (p_info (3)), '"');
   END IF;
   
   lvs_column_count :=  to_char( p_data.LAST ); 
   
 
        --------------------------------------------------------------
        -- 이력저장
        --------------------------------------------------------------
        
       INSERT INTO IQ_MACHINE_INSPECT_DATA_WAVE2 (      
                                                      
                                                 inspect_date, 
                                                 pid, 
                                                 result, 
                                                 
                                                 enter_date, 
                                                 enter_by, 
                                                 last_modify_date, 
                                                 last_modify_by, 
                                                 organization_id, 
                                                 
                                                 run_no, 
                                                 line_code, 
                                                 machine_code, 
                                                 file_name, 
                                                 
                                                 C1
                                             )
                                     VALUES (
                                     
                                             TO_CHAR(sysdate, 'YYYY/MM/DD HH24:MI:SS'),     -- TO_CHAR( TO_DATE( REPLACE (TRIM (p_data(1)), '"'), 'YYYY-MM-DD HH24:MI:SS'), 'YYYY/MM/DD HH24:MI:SS'),    -- 2021-02-17 08:59:55
                                             '*', --REPLACE (TRIM (p_data(2)), '"'),
                                             '',  --REPLACE (TRIM (p_data(3)), '"'),
                                             
                                             sysdate,
                                             'FILE WATCHER',
                                             sysdate,
                                             'FILE WATCHER',
                                             1,
                                             
                                             '*', --F_GET_RUN_NO_BY_PID( REPLACE (TRIM (p_data(2)), '"') ),
                                             lvs_line_code,
                                             lvs_machine_code,
                                             lvs_file_name,
                                             
                                             REPLACE (TRIM (p_data(1)), '"')
                                           );
                                           
   
   COMMIT;
   
EXCEPTION
  
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS THEN

        LVS_ERRORMSG := '[P_INSERT_SOLDER_WAVE2_RAW]' || lvs_sql || SUBSTR (SQLERRM, 1, 200);
  
        ROLLBACK ;
       
       INSERT INTO ICOM_MACHINE_INSERT_LOG( 
                                            LOG_DATE , 
                                            ERROR_MESSAGE , 
                                            ERROR_DESC 
                                          )
                                   VALUES ( 
                                            SYSDATE  , 
                                            LVS_ERRORMSG  ,
                                            'FILE = '||lvs_file_name||', LINE = '||lvs_line_code || ', COLUMN COUNT = ' || lvs_column_count 
                                          ) ;

      COMMIT;
      
      
END;
