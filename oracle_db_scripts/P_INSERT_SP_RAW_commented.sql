CREATE OR REPLACE PROCEDURE P_INSERT_SP_RAW (
  /* ================================================================
   * 프로시저명  : P_INSERT_SP_RAW
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
   *   IQ_MACHINE_INSPECT_DATA_SP - 원본 로직 참조 테이블
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
   *   EXEC P_INSERT_SP_RAW(...)
   * ================================================================ */
   p_data   IN ARRAY4_PARAMS_T,
   p_info   IN ARRAY4_PARAMS_T)
IS
   lvs_file_name      VARCHAR2 (100) := ''; -- [AI] 내부 처리용 변수
   lvs_line_code      VARCHAR2 (20)  := ''; -- [AI] 내부 처리용 변수
   lvs_machine_code   VARCHAR2 (20)  := ''; -- [AI] 내부 처리용 변수

   LVS_ERRORMSG       VARCHAR2 (300); -- [AI] 내부 처리용 변수
   
   lvs_column_count   VARCHAR2 (20)  := ''; -- [AI] 내부 처리용 변수
   
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
   
   lvs_column_count :=  to_char( p_data.LAST ); 
   
   ----------------------------------------------------------------------------
   -- 데이타 처리 : SJ
   ----------------------------------------------------------------------------
                   
       INSERT INTO IQ_MACHINE_INSPECT_DATA_SP ( 
                                                PID,
                                                INSPECT_DATE,
                                                RESULT,
                                                
                                                ENTER_DATE       ,
                                                ENTER_BY         ,
                                                LAST_MODIFY_DATE ,
                                                LAST_MODIFY_BY   ,
                                                ORGANIZATION_ID  ,
                                                
                                                FILE_NAME        ,
                                                LINE_CODE        ,
                                                MACHINE_CODE     ,
                                                RUN_NO           ,
                                                
                                                sso_dist_table   ,
                                                sso_table_speed  ,
                                                
                                                pressure1        ,
                                                speed1           ,
                                                pressure2        ,
                                                speed2           ,
                                                
                                                frequency        ,
                                                temprature       ,
                                                front_sqg        ,
                                                rear_sqg         ,
                                                matal_mask       ,
                                                
                                                paste_id         ,
                                                Stencil_Id       ,
                                                Squeegee_Id      ,
                                                Product_Count    ,
                                                squeegee_count   ,
                                                Mask_Count       ,
                                                paste_count      ,
                                                WORK_SEPARATION_SPEED,
                                                WORK_SEPARATION_DISTANCE,
                                                
                                                JOB_FILE,
                                                DOUBLE_PRINTING_OPTION,
                                                PRINTING_DIRECTION
                                               )
                               VALUES (
                                       REPLACE (TRIM (p_data(1)), '"'),
                                       to_char( to_date( REPLACE (TRIM (p_data(2)), '"'), 'YYYYMMDDHH24MISS' ), 'YYYY/MM/DD HH24:MI:SS'),
                                       NULL,
                                       
                                       sysdate,
                                       'SP',
                                       sysdate,
                                       'FILE WACHTOR',
                                       1,
                                       lvs_file_name,
                                       lvs_line_code,
                                       lvs_machine_code,
                                       '*',
                                                                                                                   
                                       NULL, --REPLACE (TRIM (p_data(30)), '"'),
                                       NULL, --REPLACE (TRIM (p_data(29)), '"'),
                                       
                                       REPLACE (TRIM (p_data(36)), '"'),
                                       REPLACE (TRIM (p_data(37)), '"'),
                                       NULL,
                                       NULL,
                                       
                                       NULL, --REPLACE (TRIM (p_data(40)), '"'),
                                       NULL,
                                       NULL, --REPLACE (TRIM (p_data(9)), '"'),
                                       NULL,
                                       NULL, --REPLACE (TRIM (p_data(10)), '"'),
                                       
                                       REPLACE (TRIM (p_data(5)), '"'),
                                       REPLACE (TRIM (p_data(6)), '"'),
                                       REPLACE (TRIM (p_data(7)), '"'),
                                       REPLACE (TRIM (p_data(8)), '"'),
                                       REPLACE (TRIM (p_data(9)), '"'),
                                       REPLACE (TRIM (p_data(10)), '"'),
                                       REPLACE (TRIM (p_data(11)), '"'),
                                       REPLACE (TRIM (p_data(26)), '"'),
                                       REPLACE (TRIM (p_data(27)), '"'),
                                       
                                       REPLACE (TRIM (p_data(3)), '"'),
                                       REPLACE (TRIM (p_data(31)), '"'),
                                       REPLACE (TRIM (p_data(32)), '"')
                                      );
                                      
 
                                              
 -----------------------------------------------------------------------
 --
 -----------------------------------------------------------------------
   COMMIT;

EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS THEN

        LVS_ERRORMSG := '[P_INSERT_SP_RAW]' || ' ' || SUBSTR (SQLERRM, 1, 300);

        ROLLBACK ;
        INSERT INTO ICOM_MACHINE_INSERT_LOG(
                                             LOG_DATE ,
                                             ERROR_MESSAGE ,
                                             ERROR_DESC,
                                             
                                             TEMP1,
                                             TEMP2,
                                             TEMP3
                                           )
                                    VALUES (
                                             SYSDATE,
                                             LVS_ERRORMSG  ,
                                             'FILE = ' || lvs_file_name,
                                             
                                             lvs_line_code,
                                             lvs_machine_code,
                                             lvs_column_count
                                             
                                           ) ;

      COMMIT;
      
END P_INSERT_SP_RAW;
