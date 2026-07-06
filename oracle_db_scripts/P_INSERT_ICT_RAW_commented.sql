CREATE OR REPLACE PROCEDURE "P_INSERT_ICT_RAW" (
  /* ================================================================
   * 프로시저명  : P_INSERT_ICT_RAW
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-04-18
   * 수정이력:
   *   2020-04-18 - 지성솔루션컨설팅 - 최초 작성
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
   *   IQ_MACHINE_INSPECT_DATA_ICT - 원본 로직 참조 테이블
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
   *   EXEC P_INSERT_ICT_RAW(...)
   * ================================================================ */
   p_data   IN ARRAY4_PARAMS_T,
   p_info   IN ARRAY4_PARAMS_T)
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
   
   IF p_data.LAST = 6 THEN  -- 6, DCP 화일
     
        lvs_mode := 'DCP';       
        
        --------------------------------------------------------------
        -- 화일명에서 판정결과 추출
        --------------------------------------------------------------
        
          IF ( INSTR( LVS_FILE_NAME, 'PASS' ) > 0)  THEN
               
                    LVS_RESULT := 'PASS';
               
          ELSIF  ( INSTR( LVS_FILE_NAME, 'FAIL' ) > 0)  THEN
                    LVS_RESULT := 'FAIL';
          ELSE
                    LVS_RESULT := '*';
          END IF;

        --------------------------------------------------------------
        -- 이력저장
        --------------------------------------------------------------
        
       INSERT INTO IQ_MACHINE_INSPECT_DATA_ICT (                                     
                                                      inspect_date,   
                                                      pid, 
                                                      result,
                                                      defect_code,
                                                      
                                                      step_no, 
                                                      parts_name, 
                                                      op_mode, 
                                                      c0r0, 
                                                      c0r0_unit, 
                                                      actual, 
                                                      actual_unit, 
                                                      standard, 
                                                      standard_unit, 
                                                      measure, 
                                                      measure_unit, 
                                                      hi_limit, 
                                                      hi_limit_unit, 
                                                      lo_limit, 
                                                      lo_limit_unit,

                                                      enter_date,
                                                      enter_by,
                                                      last_modify_date,
                                                      last_modify_by,
                                                      organization_id,
                                                      FILE_PATH,
                                                      file_name,
                                                      line_code,
                                                      machine_code,
                                                      
                                                      cstid,
                                                      array_no, 
                                                      equipmentid,
                                                      run_no
                                             )
                                     VALUES (
                                     
                                             to_char( sysdate, 'YYYY/MM/DD HH24:MI:SS' ),  
                                             lvs_file_name,                   -- #01-2020041856OS142007257291PASS09.dcl
                                             lvs_result,
                                             REPLACE (TRIM (p_data(6)), '"'),
                                                 
                                             REPLACE (TRIM (p_data(1)), '"'),
                                             REPLACE (TRIM (p_data(2)), '"'),
                                             NULL,
                                             NULL,
                                             NULL,
                                             REPLACE (TRIM (p_data(3)), '"'), 
                                             NULL, --'pF',
                                             REPLACE (TRIM (p_data(4)), '"'), 
                                             NULL, --'pF',
                                             REPLACE (TRIM (p_data(5)), '"'), 
                                             NULL, --'pF',
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                                                      
                                             sysdate,
                                             lvs_column_count, --'FILE WATCHER',
                                             sysdate,
                                             'FILE WATCHER',
                                             1,
                                             lvs_mode,
                                             lvs_file_name,
                                             lvs_line_code,
                                             lvs_machine_code,
                                             
                                             '*', 
                                             NULL, 
                                             lvs_machine_code,
                                            '*'
                                           );
                                           
   ELSIF p_data.LAST = 7 THEN  -- 9, DCP 화일     
     
        lvs_mode := 'DCP';       
        
        --------------------------------------------------------------
        -- 화일명에서 판정결과 추출
        --------------------------------------------------------------
        
          IF ( INSTR( LVS_FILE_NAME, 'PASS' ) > 0)  THEN
               
                    LVS_RESULT := 'PASS';
               
          ELSIF  ( INSTR( LVS_FILE_NAME, 'FAIL' ) > 0)  THEN
                    LVS_RESULT := 'FAIL';
          ELSE
                    LVS_RESULT := '*';
          END IF;       
          
 
        --------------------------------------------------------------
        -- 이력저장
        --------------------------------------------------------------
        
       INSERT INTO IQ_MACHINE_INSPECT_DATA_ICT (                                     
                                                      inspect_date,   
                                                      pid, 
                                                      result,
                                                      defect_code,
                                                      
                                                      step_no, 
                                                      parts_name, 
                                                      op_mode, 
                                                      c0r0, 
                                                      c0r0_unit, 
                                                      actual, 
                                                      actual_unit, 
                                                      standard, 
                                                      standard_unit, 
                                                      measure, 
                                                      measure_unit, 
                                                      hi_limit, 
                                                      hi_limit_unit, 
                                                      lo_limit, 
                                                      lo_limit_unit,

                                                      enter_date,
                                                      enter_by,
                                                      last_modify_date,
                                                      last_modify_by,
                                                      organization_id,
                                                      FILE_PATH,
                                                      file_name,
                                                      line_code,
                                                      machine_code,
                                                      
                                                      cstid,
                                                      array_no, 
                                                      equipmentid,
                                                      run_no
                                             )
                                     VALUES (
                                     
                                             to_char( sysdate, 'YYYY/MM/DD HH24:MI:SS' ),  
                                             lvs_file_name,                   -- #01-2020041856OS142007257291PASS09.dcl
                                             lvs_result,
                                             REPLACE (TRIM (p_data(7)), '"'),
                                                 
                                             REPLACE (TRIM (p_data(1)), '"'),
                                             REPLACE (TRIM (p_data(2)), '"'),
                                             NULL,
                                             NULL,
                                             NULL,
                                             REPLACE (TRIM (p_data(3)), '"'), 
                                             NULL, --'pF',
                                             REPLACE (TRIM (p_data(4)), '"'), 
                                             NULL, --'pF',
                                             REPLACE (TRIM (p_data(5)), '"'), 
                                             NULL, --'pF',
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                                                      
                                             sysdate,
                                             lvs_column_count, --'FILE WATCHER',
                                             sysdate,
                                             'FILE WATCHER',
                                             1,
                                             lvs_mode,
                                             lvs_file_name,
                                             lvs_line_code,
                                             lvs_machine_code,
                                             
                                             '*', 
                                             NULL, 
                                             lvs_machine_code,
                                            '*'
                                           );         
                                              
                                           
   ELSIF p_data.LAST = 9 THEN  -- 9, DCP 화일     
     
        lvs_mode := 'DCP';       
        
        --------------------------------------------------------------
        -- 화일명에서 판정결과 추출
        --------------------------------------------------------------
        
          IF ( INSTR( LVS_FILE_NAME, 'PASS' ) > 0)  THEN
               
                    LVS_RESULT := 'PASS';
               
          ELSIF  ( INSTR( LVS_FILE_NAME, 'FAIL' ) > 0)  THEN
                    LVS_RESULT := 'FAIL';
          ELSE
                    LVS_RESULT := '*';
          END IF;

        --------------------------------------------------------------
        -- 이력저장
        --------------------------------------------------------------
        
       INSERT INTO IQ_MACHINE_INSPECT_DATA_ICT (                                     
                                                      inspect_date,   
                                                      pid, 
                                                      result,
                                                      defect_code,
                                                      
                                                      step_no, 
                                                      parts_name, 
                                                      op_mode, 
                                                      c0r0, 
                                                      c0r0_unit, 
                                                      actual, 
                                                      actual_unit, 
                                                      standard, 
                                                      standard_unit, 
                                                      measure, 
                                                      measure_unit, 
                                                      hi_limit, 
                                                      hi_limit_unit, 
                                                      lo_limit, 
                                                      lo_limit_unit,

                                                      enter_date,
                                                      enter_by,
                                                      last_modify_date,
                                                      last_modify_by,
                                                      organization_id,
                                                      FILE_PATH,
                                                      file_name,
                                                      line_code,
                                                      machine_code,
                                                      
                                                      cstid,
                                                      array_no, 
                                                      equipmentid,
                                                      run_no
                                             )
                                     VALUES (
                                     
                                             to_char( sysdate, 'YYYY/MM/DD HH24:MI:SS' ),  
                                             lvs_file_name,                   -- #01-2020041856OS142007257291PASS09.dcl
                                             lvs_result,
                                             REPLACE (TRIM (p_data(9)), '"'),
                                                 
                                             REPLACE (TRIM (p_data(1)), '"'),
                                             REPLACE (TRIM (p_data(2)), '"'),
                                             NULL,
                                             NULL,
                                             NULL,
                                             REPLACE (TRIM (p_data(3)), '"'), 
                                             NULL, --'pF',
                                             REPLACE (TRIM (p_data(4)), '"'), 
                                             NULL, --'pF',
                                             REPLACE (TRIM (p_data(8)), '"'), 
                                             NULL, --'pF',
                                             REPLACE (TRIM (p_data(5)), '"'), 
                                             NULL,
                                             REPLACE (TRIM (p_data(6)), '"'), 
                                             NULL,
                                                                      
                                             sysdate,
                                             lvs_column_count, --'FILE WATCHER',
                                             sysdate,
                                             'FILE WATCHER',
                                             1,
                                             lvs_mode,
                                             lvs_file_name,
                                             lvs_line_code,
                                             lvs_machine_code,
                                             
                                             '*', 
                                             NULL, 
                                             lvs_machine_code,
                                            '*'
                                           );
                                           
   ELSIF p_data.LAST = 10 THEN  -- 10, DCP 화일     
     
        lvs_mode := 'DCP';       
        
        --------------------------------------------------------------
        -- 화일명에서 판정결과 추출
        --------------------------------------------------------------
        
          IF ( INSTR( LVS_FILE_NAME, 'PASS' ) > 0)  THEN
               
                    LVS_RESULT := 'PASS';
               
          ELSIF  ( INSTR( LVS_FILE_NAME, 'FAIL' ) > 0)  THEN
                    LVS_RESULT := 'FAIL';
          ELSE
                    LVS_RESULT := '*';
          END IF;

        --------------------------------------------------------------
        -- 이력저장
        --------------------------------------------------------------
        
       INSERT INTO IQ_MACHINE_INSPECT_DATA_ICT (                                     
                                                      inspect_date,   
                                                      pid, 
                                                      result,
                                                      defect_code,
                                                      
                                                      step_no, 
                                                      parts_name, 
                                                      op_mode, 
                                                      c0r0, 
                                                      c0r0_unit, 
                                                      actual, 
                                                      actual_unit, 
                                                      standard, 
                                                      standard_unit, 
                                                      measure, 
                                                      measure_unit, 
                                                      hi_limit, 
                                                      hi_limit_unit, 
                                                      lo_limit, 
                                                      lo_limit_unit,

                                                      enter_date,
                                                      enter_by,
                                                      last_modify_date,
                                                      last_modify_by,
                                                      organization_id,
                                                      FILE_PATH,
                                                      file_name,
                                                      line_code,
                                                      machine_code,
                                                      
                                                      cstid,
                                                      array_no, 
                                                      equipmentid,
                                                      run_no
                                             )
                                     VALUES (
                                     
                                             to_char( sysdate, 'YYYY/MM/DD HH24:MI:SS' ),  
                                             lvs_file_name,                   -- #01-2020041856OS142007257291PASS09.dcl
                                             lvs_result,
                                             REPLACE (TRIM (p_data(10)), '"'),
                                                 
                                             REPLACE (TRIM (p_data(1)), '"'),
                                             REPLACE (TRIM (p_data(2)), '"'),
                                             NULL,
                                             NULL,
                                             NULL,
                                             REPLACE (TRIM (p_data(3)), '"'), 
                                             NULL, --'pF',
                                             REPLACE (TRIM (p_data(4)), '"'), 
                                             NULL, --'pF',
                                             REPLACE (TRIM (p_data(9)), '"'), 
                                             NULL, --'pF',
                                             REPLACE (TRIM (p_data(5)), '"'), 
                                             NULL,
                                             REPLACE (TRIM (p_data(6)), '"'), 
                                             NULL,
                                                                      
                                             sysdate,
                                             lvs_column_count, --'FILE WATCHER',
                                             sysdate,
                                             'FILE WATCHER',
                                             1,
                                             lvs_mode,
                                             lvs_file_name,
                                             lvs_line_code,
                                             lvs_machine_code,
                                             
                                             '*', 
                                             NULL, 
                                             lvs_machine_code,
                                            '*'
                                           );                                           
                                           
   ELSIF p_data.LAST = 12 THEN  -- 9, DCP 화일     
     
        lvs_mode := 'DCP';       
        
        --------------------------------------------------------------
        -- 화일명에서 판정결과 추출
        --------------------------------------------------------------
        
          IF ( INSTR( LVS_FILE_NAME, 'PASS' ) > 0)  THEN
               
                    LVS_RESULT := 'PASS';
               
          ELSIF  ( INSTR( LVS_FILE_NAME, 'FAIL' ) > 0)  THEN
                    LVS_RESULT := 'FAIL';
          ELSE
                    LVS_RESULT := '*';
          END IF;

        --------------------------------------------------------------
        -- 이력저장
        --------------------------------------------------------------
        
       INSERT INTO IQ_MACHINE_INSPECT_DATA_ICT (                                     
                                                      inspect_date,   
                                                      pid, 
                                                      result,
                                                      defect_code,
                                                      
                                                      step_no, 
                                                      parts_name, 
                                                      op_mode, 
                                                      c0r0, 
                                                      c0r0_unit, 
                                                      actual, 
                                                      actual_unit, 
                                                      standard, 
                                                      standard_unit, 
                                                      measure, 
                                                      measure_unit, 
                                                      hi_limit, 
                                                      hi_limit_unit, 
                                                      lo_limit, 
                                                      lo_limit_unit,

                                                      enter_date,
                                                      enter_by,
                                                      last_modify_date,
                                                      last_modify_by,
                                                      organization_id,
                                                      FILE_PATH,
                                                      file_name,
                                                      line_code,
                                                      machine_code,
                                                      
                                                      cstid,
                                                      array_no, 
                                                      equipmentid,
                                                      run_no
                                             )
                                     VALUES (
                                     
                                             to_char( sysdate, 'YYYY/MM/DD HH24:MI:SS' ),  
                                             lvs_file_name,                   -- #01-2020041856OS142007257291PASS09.dcl
                                             lvs_result,
                                             REPLACE (TRIM (p_data(12)), '"'),  -- 테스트 결과
                                                 
                                             REPLACE (TRIM (p_data(1)), '"'),   -- 스탭
                                             REPLACE (TRIM (p_data(2)), '"'),   -- 부품이름
                                             NULL,
                                             NULL,
                                             NULL,
                                             REPLACE (TRIM (p_data(3)), '"'),   -- 실제값
                                             NULL, --'pF',
                                             REPLACE (TRIM (p_data(4)), '"'),    -- 표준값
                                             NULL, --'pF',
                                             REPLACE (TRIM (p_data(11)), '"'),   -- 측정값
                                             NULL, --'pF',
                                             REPLACE (TRIM (p_data(6)), '"'),    -- 상한
                                             NULL,
                                             REPLACE (TRIM (p_data(7)), '"'),    -- 하한
                                             NULL,
                                                                      
                                             sysdate,
                                             lvs_column_count, --'FILE WATCHER',
                                             sysdate,
                                             'FILE WATCHER',
                                             1,
                                             lvs_mode,
                                             lvs_file_name,
                                             lvs_line_code,
                                             lvs_machine_code,
                                             
                                             '*', 
                                             NULL, 
                                             lvs_machine_code,
                                            '*'
                                           );                                           
                                                                                    
                                         
   ELSE   -- 16, RCP 파일
     
          lvs_mode := 'RPC';
          
        --------------------------------------------------------------
        -- 화일명에서 판정결과 추출
        --------------------------------------------------------------
        
          IF ( INSTR( LVS_FILE_NAME, 'PASS' ) > 0)  THEN
               
                    LVS_RESULT := 'PASS';
               
          ELSIF  ( INSTR( LVS_FILE_NAME, 'FAIL' ) > 0)  THEN
                    LVS_RESULT := 'FAIL';
          ELSE
                    LVS_RESULT := '*';
          END IF;        


        --------------------------------------------------------------
        -- 이력저장
        --------------------------------------------------------------          
           
          INSERT INTO IQ_MACHINE_INSPECT_DATA_ICT (                                     
                                                      inspect_date,   
                                                      pid, 
                                                      result,
                                                      defect_code,
                                                      
                                                      step_no, 
                                                      parts_name, 
                                                      op_mode, 
                                                      c0r0, 
                                                      c0r0_unit, 
                                                      actual, 
                                                      actual_unit, 
                                                      standard, 
                                                      standard_unit, 
                                                      measure, 
                                                      measure_unit, 
                                                      hi_limit, 
                                                      hi_limit_unit, 
                                                      lo_limit, 
                                                      lo_limit_unit,

                                                      enter_date,
                                                      enter_by,
                                                      last_modify_date,
                                                      last_modify_by,
                                                      organization_id,
                                                      FILE_PATH,
                                                      file_name,
                                                      line_code,
                                                      machine_code,
                                                      
                                                      cstid,
                                                      array_no, 
                                                      equipmentid,
                                                      run_no
                                             )
                                     VALUES (
                                     
                                             to_char( sysdate, 'YYYY/MM/DD HH24:MI:SS' ),  
                                             lvs_file_name, 
                                             lvs_result,
                                             REPLACE (TRIM (p_data(16)), '"'),
                                                 
                                             REPLACE (TRIM (p_data(1)), '"'),
                                             REPLACE (TRIM (p_data(2)), '"'),
                                             REPLACE (TRIM (p_data(3)), '"'),
                                             REPLACE (TRIM (p_data(4)), '"'),
                                             REPLACE (TRIM (p_data(5)), '"'),
                                             REPLACE (TRIM (p_data(6)), '"'),
                                             REPLACE (TRIM (p_data(7)), '"'),
                                             REPLACE (TRIM (p_data(8)), '"'),
                                             REPLACE (TRIM (p_data(9)), '"'),
                                             REPLACE (TRIM (p_data(10)), '"'),
                                             REPLACE (TRIM (p_data(11)), '"'),
                                             REPLACE (TRIM (p_data(12)), '"'),
                                             REPLACE (TRIM (p_data(13)), '"'),
                                             REPLACE (TRIM (p_data(14)), '"'),
                                             REPLACE (TRIM (p_data(15)), '"'),
                                                                      
                                             sysdate,
                                             lvs_column_count, --'FILE WATCHER',
                                             sysdate,
                                             'FILE WATCHER',
                                             1,
                                             lvs_mode,
                                             lvs_file_name,
                                             lvs_line_code,
                                             lvs_machine_code,
                                             
                                             '*', 
                                             NULL, 
                                             lvs_machine_code,
                                            '*'
                                           );
   
   END IF;
   
   
   COMMIT;
   
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN

      LVS_ERRORMSG :=
         '[P_INSERT_ICT_RAW]' || lvs_sql || SUBSTR (SQLERRM, 1, 200);
   ROLLBACK ;
         INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC )
       VALUES ( SYSDATE  , LVS_ERRORMSG  , 'FILE = '||lvs_file_name||', LINE = '||lvs_line_code || ', File type = '||lvs_mode||', COLUMN COUNT = ' || lvs_column_count ) ;

      COMMIT;
      
      
END P_INSERT_ICT_RAW;
