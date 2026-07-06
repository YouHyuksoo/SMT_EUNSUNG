CREATE OR REPLACE PROCEDURE "P_INSERT_RW_RAW" (
  /* ================================================================
   * 프로시저명  : P_INSERT_RW_RAW
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2019-07-10
   * 수정이력:
   *   2019-07-10 - 지성솔루션컨설팅 - 최초 작성
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
   *   IQ_MACHINE_INSPECT_DATA_RW - 원본 로직 참조 테이블
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
   *   EXEC P_INSERT_RW_RAW(...)
   * ================================================================ */
   p_data   IN ARRAY4_PARAMS_T,
   p_info   IN ARRAY4_PARAMS_T)
IS
   lvs_file_name      VARCHAR2 (100) := ''; -- [AI] 내부 처리용 변수
   lvs_line_code      VARCHAR2 (20) := ''; -- [AI] 내부 처리용 변수
   lvs_machine_code   VARCHAR2 (20) := ''; -- [AI] 내부 처리용 변수
   LVS_ERRORMSG       VARCHAR2 (300); -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
  
   ----------------------------------------------------------------------------
   -- 호출 watcher 정보
   ----------------------------------------------------------------------------
   
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

   ----------------------------------------------------------------------------
   -- 데이타 처리
   ----------------------------------------------------------------------------
   
   -- p_data (1)  ROM WRITE,
   -- p_data (2)  TMA WALK IN CUSH SW,
   -- p_data (3)  19709A0011-01 
   -- p_data (4)  2019/07/10 06:39:54
   -- p_data (5)  40020
   -- p_data (6)  10326

   INSERT INTO IQ_MACHINE_INSPECT_DATA_RW (
                                             cstid, 
                                             seq_no, 
                                             pid, 
                                             equipmentid, 
                                             inspect_date, 
                                             result, 
                                             defect_code, 
                                             
                                             enter_date, 
                                             enter_by, 
                                             last_modify_date, 
                                             last_modify_by, 
                                             organization_id, 
                                             
                                             file_name, 
                                             array_no, 
                                             run_no, 
                                             line_code, 
                                             machine_code, 
                                             
                                             route_program, 
                                             check_sum, 
                                             work_time

                                          )
   VALUES (
           nvl(regexp_substr(REPLACE (TRIM (p_data (3)), '"'), '[^-]+',1,1), 'NULL'),
           nvl(substr(regexp_substr(REPLACE (TRIM (p_data (3)), '"'),'[^-]+',1,2),1,2),'00'),
           NVL(REPLACE (TRIM (p_data (3)), '"'), 'NULL'),
           
           REPLACE (TRIM (p_data (1)), '"'),
           REPLACE (TRIM (p_data (4)), '"'), 
           'OK',
           '',
           
           sysdate,
           'SYSTEM',
           sysdate,
           'SYSTEM',
           1,
           
           lvs_file_name,
           '',
           'NULL',
           lvs_line_code,
           lvs_machine_code,
           
           REPLACE (TRIM (p_data (2)), '"'), 
           REPLACE (TRIM (p_data (5)), '"'), 
           REPLACE (TRIM (p_data (6)), '"')
          );

 -----------------------------------------------------------------------
 --
 -----------------------------------------------------------------------
   COMMIT;
   
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS THEN
     
        LVS_ERRORMSG := '[P_INSERT_RW_RAW]' || ' ' || SUBSTR (SQLERRM, 1, 200);
        
        ROLLBACK ;
        INSERT INTO ICOM_MACHINE_INSERT_LOG( 
                                             LOG_DATE , 
                                             ERROR_MESSAGE , 
                                             ERROR_DESC
                                           )
                                    VALUES (
                                             SYSDATE, 
                                             LVS_ERRORMSG  , 
                                             lvs_file_name||' LINE='||lvs_line_code 
                                           ) ;

      COMMIT;
      NULL;
      
END ;
