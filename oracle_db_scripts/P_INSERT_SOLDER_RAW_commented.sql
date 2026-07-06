CREATE OR REPLACE PROCEDURE P_INSERT_SOLDER_RAW (
  /* ================================================================
   * 프로시저명  : P_INSERT_SOLDER_RAW
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2019-08-13
   * 수정이력:
   *   2019-08-13 - 지성솔루션컨설팅 - 최초 작성
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
   *   IM_ITEM_SOLDER_MASTER - 원본 로직 참조 테이블
   *   IQ_MACHINE_INSPECT_DATA_SOLDER - 원본 로직 참조 테이블
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
   *   EXEC P_INSERT_SOLDER_RAW(...)
   * ================================================================ */
   p_data   IN ARRAY4_PARAMS_T,
   p_info   IN ARRAY4_PARAMS_T)
IS
   lvs_file_name      VARCHAR2 (200) := ''; -- [AI] 내부 처리용 변수
   lvs_line_code      VARCHAR2 (20)  := ''; -- [AI] 내부 처리용 변수
   lvs_machine_code   VARCHAR2 (20)  := ''; -- [AI] 내부 처리용 변수
   
   lvs_sql            VARCHAR2 (30000); -- [AI] 내부 처리용 변수
   LVS_ERRORMSG       VARCHAR2 (32000); -- [AI] 내부 처리용 변수

   lvs_barcode        VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_lot_no         VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_operator       VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_date           VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_rpm            VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_time           VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_viscocity      VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_temp           VARCHAR2 (100); -- [AI] 내부 처리용 변수
   
   lvs_item_code      VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvl_row_count      NUMBER; -- [AI] 내부 처리용 변수
   
   lvs_pass_step      VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvdt_valid_date    DATE; -- [AI] 내부 처리용 변수
   
   lvs_column_count   VARCHAR2 (20); -- [AI] 내부 처리용 변수
   lvs_para_count     VARCHAR2 (20); -- [AI] 내부 처리용 변수
   
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
      
   --********************************************************************
   -- 라인,설비등 기준정보 파싱
   --********************************************************************
  lvs_pass_step := '100';
  
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
   lvs_para_count   :=  to_char( p_info.LAST ); 

   --********************************************************************
   -- 화일내 데이타 파싱 ( *.csv )
   --********************************************************************                                       

   lvs_pass_step := '200';
   
   IF p_info.LAST >= 8 THEN 
   
     -- #1, Comment,S190703060
     select UPPER( NVL(TRIM(regexp_substr(TRIM(REPLACE (TRIM (p_info(1+4)), '"')),'[^,]+',1,2)),'NULL') )
       into lvs_barcode
       from dual;
       
     -- #2, Sample,190619-2
     select UPPER( regexp_substr(TRIM(REPLACE (TRIM (p_info(2+4)), '"')),'[^,]+',1,2) )
       into lvs_lot_no
       from dual;
       
     -- #4, Operator,XXXXXXXX
     select UPPER( regexp_substr(TRIM(REPLACE (TRIM (p_info(3+4)), '"')),'[^,]+',1,2) )
       into lvs_operator
       from dual;     
        
     -- #5, Date,2019/08/13
     select UPPER( regexp_substr(TRIM(REPLACE (TRIM (p_info(4+4)), '"')),'[^,]+',1,2) )
       into lvs_date
       from dual;
   END IF;
     
   -- #16, 10,180,182.0,25.2
/*   select NVL(TRIM(regexp_substr(TRIM(REPLACE (TRIM (p_data(5)), '"')),'[^,]+',1,1)),'0'),
          NVL(TRIM(regexp_substr(TRIM(REPLACE (TRIM (p_data(5)), '"')),'[^,]+',1,2)),'0'),
          NVL(TRIM(regexp_substr(TRIM(REPLACE (TRIM (p_data(5)), '"')),'[^,]+',1,3)),'0'),
          NVL(TRIM(regexp_substr(TRIM(REPLACE (TRIM (p_data(5)), '"')),'[^,]+',1,4)),'0')
     into lvs_rpm,
          lvs_time,
          lvs_viscocity,
          lvs_temp  
     from dual;*/
     
lvs_pass_step := '300';     
     
     lvs_rpm       := NVL(REPLACE (TRIM (p_data(1)), '"'), '0'); 
     lvs_time      := NVL(REPLACE (TRIM (p_data(2)), '"'), '0');
     lvs_viscocity := NVL(REPLACE (TRIM (p_data(3)), '"'), '0');
     lvs_temp      := NVL(REPLACE (TRIM (p_data(4)), '"'), '0');
     
    --********************************************************************
   -- 이력저장
   --********************************************************************
   
lvs_pass_step := '600';


     IF ( INSTR( p_info(1+4), 'Comment') >= 1 AND lvs_barcode <> 'NULL') THEN
       
       IF (lvs_rpm = '10' AND lvs_time = '180') THEN
         
                INSERT INTO IQ_MACHINE_INSPECT_DATA_SOLDER (
                                                        solder_no,
                                                        solder_lot_no,
                                                        measure_date,
                                                        rpm,
                                                        time,
                                                        viscosity,
                                                        temp,
                                                        file_name,
                                                        line_code,
                                                        machine_code,
                                                        organization_id,
                                                        enter_date,       
                                                        enter_by ,        
                                                        last_modify_date, 
                                                        last_modify_by,
                                                        OPERATOR
                                                       ) 
                 SELECT lvs_barcode,
                        lvs_lot_no,
                        lvs_date,
                        lvs_rpm,
                        lvs_time,
                        lvs_viscocity,
                        lvs_temp,
                        lvs_file_name,
                        lvs_line_code,
                        lvs_machine_code,
                        1,
                        sysdate,
                        'WATCHER',
                        sysdate,
                        'WATCHER',
                        lvs_operator
                  FROM DUAL;   
                                    
       ELSE
         return;
       END IF;
       
     END IF;
  
lvs_pass_step := '700';
 
     BEGIN
       
         SELECT count(*), NVL(max(item_code),'*'), max(valid_date)
           INTO lvl_row_count, lvs_item_code, lvdt_valid_date
           FROM IM_ITEM_SOLDER_MASTER
          WHERE ITEM_BARCODE         = lvs_barcode
            AND ORGANIZATION_ID      = 1;
        
     EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
        WHEN OTHERS THEN
             lvl_row_count := 0;
             lvs_item_code := 'NULL';
     END;
     

lvs_pass_step := '800';
           
     IF ( lvl_row_count > 0 ) THEN
          
           UPDATE IM_ITEM_SOLDER_MASTER
              SET VISCOSITY_FILE_NAME  = lvs_file_name,
                  VISCOSITY_START_DATE = NVL( VISCOSITY_START_DATE, sysdate - (3/(24*60)) ),
                  VISCOSITY_END_DATE   = sysdate,
                  VISCOSITY            = to_number( lvs_viscocity ),
                  RPM                  = to_number( lvs_rpm ),
                  TIME                 = to_number( lvs_time ),
                  TEMP                 = to_number( lvs_temp ),
                  VISCOSITY_OPERATOR   = nvl(lvs_operator, VISCOSITY_OPERATOR)
            WHERE ITEM_BARCODE         = lvs_barcode
              AND DESTROY_DATE         is null   
              AND ORGANIZATION_ID      = 1;
              
lvs_pass_step := '800';              
              
           IF ( SQL%ROWCOUNT > 0 ) THEN
             
/*      
         UPDATE IM_ITEM_SOLDER_MASTER
                  SET VISCOSITY_END_DATE   = sysdate,
                      VISCOSITY_FILE_NAME  = lvs_file_name,
                      VISCOSITY            = to_number( lvs_viscocity ),
                      RPM                  = to_number( lvs_rpm ),
                      TIME                 = to_number( lvs_time ),
                      TEMP                 = to_number( lvs_temp ),
                      VISCOSITY_OPERATOR   = nvl(lvs_operator, VISCOSITY_OPERATOR)        
                WHERE item_barcode         <> p_barcode      
                  AND VALID_DATE           = lvdt_valid_date   -- 2020-04-16 김현동씨 요청 --  WHERE ITEM_BARCODE         like substr(lvs_barcode, 1,7)||'%' 
                  AND ITEM_CODE            = LVS_ITEM_CODE
                  AND DESTROY_DATE         IS NULL             -- 폐기 안되고 
                  AND RECEIPT_DATE         IS NOT NULL         -- 냉장고 입고 후
                  AND ISSUE_DATE           IS NULL             -- 냉장고 출고 안된 solder 에 대해 점도 측정값 반영
                  AND input_date           IS NULL
                  AND ORGANIZATION_ID      = 1;
*/
                  
               UPDATE IM_ITEM_SOLDER_MASTER
                  SET VISCOSITY_END_DATE   = sysdate,
                      VISCOSITY_FILE_NAME  = lvs_file_name,
                      VISCOSITY            = to_number( lvs_viscocity ),
                      RPM                  = to_number( lvs_rpm ),
                      TIME                 = to_number( lvs_time ),
                      TEMP                 = to_number( lvs_temp ),
                      VISCOSITY_OPERATOR   = nvl(lvs_operator, VISCOSITY_OPERATOR)        
                WHERE VALID_DATE           = lvdt_valid_date   -- 2020-04-16 김현동씨 요청 --  WHERE ITEM_BARCODE         like substr(lvs_barcode, 1,7)||'%' 
                  AND ITEM_CODE            = LVS_ITEM_CODE
                  AND ITEM_BARCODE         > lvs_barcode
                  AND DESTROY_DATE         IS NULL             -- 폐기 안되고 
                  AND RECEIPT_DATE         IS NOT NULL         -- 냉장고 입고 후
                  AND ORGANIZATION_ID      = 1;
              
           END IF;
                         
     END IF;
     
     COMMIT;
       
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS THEN

        LVS_ERRORMSG := '[P_INSERT_SOLDER_RAW]' || lvs_sql || SUBSTR (SQLERRM, 1, 200);
        
       -- ROLLBACK ;
        INSERT INTO ICOM_MACHINE_INSERT_LOG( 
                                             LOG_DATE , 
                                             ERROR_MESSAGE , 
                                             ERROR_DESC
                                           )
                                    VALUES (
                                             SYSDATE, 
                                             LVS_ERRORMSG  , 
                                             'FILE = '||lvs_file_name||', LINE = '||lvs_line_code ||', STEP='|| lvs_pass_step || ', COLUMN COUNT = ' || lvs_column_count || ', PARA COUNT = ' || lvs_para_count
                                           ) ;

      COMMIT;
END P_INSERT_SOLDER_RAW;
