CREATE OR REPLACE PROCEDURE "P_INSERT_REFLOW_RAW" (
  /* ================================================================
   * 프로시저명  : P_INSERT_REFLOW_RAW
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-10-12
   * 수정이력:
   *   2020-10-12 - 지성솔루션컨설팅 - 최초 작성
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
   *   IQ_MACHINE_INSPECT_DATA_REFLOW - 원본 로직 참조 테이블
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
   *   EXEC P_INSERT_REFLOW_RAW(...)
   * ================================================================ */
   p_data   IN ARRAY4_PARAMS_T,
   p_info   IN ARRAY4_PARAMS_T)
IS
   lvs_file_name      VARCHAR2 (100) := ''; -- [AI] 내부 처리용 변수
   lvs_job_name       VARCHAR2 (100) := ''; -- [AI] 내부 처리용 변수
   
   lvs_line_code      VARCHAR2 (20) := ''; -- [AI] 내부 처리용 변수
   lvs_machine_code   VARCHAR2 (20) := ''; -- [AI] 내부 처리용 변수
   lvs_column_count   VARCHAR2 (20) := ''; -- [AI] 내부 처리용 변수
   
   LVS_ERRORMSG       VARCHAR2 (300); -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
   IF p_info.LAST >= 1  THEN
      lvs_file_name := REPLACE (TRIM (p_info (1)), '"');
   END IF;

   IF p_info.LAST >= 2 THEN
      lvs_line_code := REPLACE (TRIM (p_info (2)), '"');
   END IF;

   IF p_info.LAST >= 3 THEN
      lvs_machine_code := REPLACE (TRIM (p_info (3)), '"');
   END IF;

   IF p_info.LAST >= 5  THEN
      lvs_job_name := REPLACE (TRIM (p_info (5)), '"');
   END IF;
   
   lvs_column_count :=  to_char( p_data.LAST ); 

   INSERT INTO IQ_MACHINE_INSPECT_DATA_REFLOW (
                                                measure_date, 
                                                
                                                top1, 
                                                bottom1, 
                                                
                                                top2, 
                                                bottom2, 
                                                
                                                top3, 
                                                bottom3, 
                                                
                                                top4, 
                                                bottom4, 
                                                
                                                top5, 
                                                bottom5, 
                                                
                                                top6, 
                                                bottom6, 
                                                
                                                top7, 
                                                bottom7, 
                                                
                                                top8, 
                                                bottom8, 
                                                
                                                top9, 
                                                bottom9, 
                                                
                                                top10, 
                                                bottom10, 
                                                
                                                top11, 
                                                bottom11, 
                                                
                                                top12, 
                                                bottom12, 
                                                
                                                top13, 
                                                bottom13, 
                                                
                                                belt_speed, 
                                                oxygen_concentration,  
                                                                                             
                                                enter_date, 
                                                enter_by, 
                                                last_modify_date, 
                                                last_modify_by, 
                                                organization_id, 
                                                file_name, 
                                                line_code, 
                                                machine_code,
                                                job_file
                                                )
                                         VALUES (
                                                 --TO_CHAR( TO_DATE(REPLACE (TRIM (p_data (2)), '"'), 'MM/DD/YYYY HH:MI:SS PM'), 'YYYYY/MM/DD HH24:MI:SS'),  -- 9/9/2020 1:09:43 PM  이 포맷처리시 오류로 sysdate 기준으로 등록
                                                 -- REPLACE (TRIM (p_data (2)), '"'),
                                                 -- TO_CHAR( sysdate, 'YYYY/MM/DD HH24:MI:SS'),
                                                 
                                                 --to_char( TO_DATE( replace( replace( REPLACE ( TRIM ( p_data (2)), '"'),'AM', '오전'), 'PM', '오후'), 'DD/MM/YYYY HH:MI:SS AM'), 'YYYY/MM/DD HH24:MI:SS'),  -- 9/9/2020 1:09:43 PM
                                                 to_char( TO_DATE( REPLACE ( TRIM ( p_data (2)), '"'), 'YYYY-MM-DD AM HH:MI:SS'), 'YYYY/MM/DD HH24:MI:SS'), -- 2020-10-12 오전 12:02:25
                                                 REPLACE (TRIM (p_data (4)), '"'),  -- 1  : Top: PV 0,  bottom: PV 1
                                                 REPLACE (TRIM (p_data (7)), '"'),        
                                                 
                                                 REPLACE (TRIM (p_data (10)), '"'), -- 2   
                                                 REPLACE (TRIM (p_data (13)), '"'),
                                                 
                                                 REPLACE (TRIM (p_data (16)), '"'),  --3
                                                 REPLACE (TRIM (p_data (19)), '"'),
                                                 
                                                 REPLACE (TRIM (p_data (22)), '"'),  --4
                                                 REPLACE (TRIM (p_data (25)), '"'),
                                                 
                                                 REPLACE (TRIM (p_data (28)), '"'), --5
                                                 REPLACE (TRIM (p_data (31)), '"'),
                                                 
                                                 REPLACE (TRIM (p_data (34)), '"'), --6
                                                 REPLACE (TRIM (p_data (37)), '"'),
                                                 
                                                 
                                                 REPLACE (TRIM (p_data (46)), '"'), --7
                                                 REPLACE (TRIM (p_data (49)), '"'),
                                                 
                                                 REPLACE (TRIM (p_data (52)), '"'), --8
                                                 REPLACE (TRIM (p_data (55)), '"'),
                                                 
                                                 REPLACE (TRIM (p_data (58)), '"'), --9
                                                 REPLACE (TRIM (p_data (61)), '"'),
                                                 
                                                 REPLACE (TRIM (p_data (64)), '"'), --10
                                                 REPLACE (TRIM (p_data (67)), '"'),
                                                 
                                                 REPLACE (TRIM (p_data (40)), '"'), --11
                                                 NULL, 
                                                 
                                                 REPLACE (TRIM (p_data (106)), '"'),  --12
                                                 NULL,
                                                 
                                                 NULL, --13
                                                 NULL,
                                                 
                                                 REPLACE (TRIM (p_data (43)), '"'),  -- belt spped
                                                 REPLACE (TRIM (p_data (175)), '"'), -- oxygen_concentration
                                                 
                                                                 
                                                 SYSDATE,
                                                 'SYSTEM',
                                                 SYSDATE,
                                                 'SYSTEM',
                                                 1,
                                                 lvs_file_name,
                                                 lvs_line_code,
                                                 lvs_machine_code,
                                                 NVL(lvs_job_name,'*')                                                 
                                                 );

 
 -----------------------------------------------------------------------
 --
 -----------------------------------------------------------------------
   COMMIT;
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS  THEN
        LVS_ERRORMSG := '[P_INSERT_REFLOW_RAW]' || SUBSTR (SQLERRM, 1, 200);
      
      INSERT
        INTO ICOM_MACHINE_INSERT_LOG (LOG_DATE, ERROR_MESSAGE, ERROR_DESC)
      VALUES (
                SYSDATE,
                LVS_ERRORMSG,
                'LINE =>' || lvs_line_code || ', FILE =>' || lvs_file_name || ', COLUMN COUNT =>' || lvs_column_count||', DATA =>'||REPLACE (TRIM (p_data (2)), '"')
             );

      COMMIT;
      
END ;
