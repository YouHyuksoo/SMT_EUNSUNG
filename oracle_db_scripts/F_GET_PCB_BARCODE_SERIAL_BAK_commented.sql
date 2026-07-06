CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_PCB_BARCODE_SERIAL_BAK
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 파라미터와 기준 테이블을 이용해 업무 코드, 명칭, 수량, 상태 등의 조회 값을 반환한다.
   *   조회 실패 또는 예외 상황에서는 원본 로직에 정의된 기본값/NULL/오류 처리를 따른다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_RUN_NO  (IN, VARCHAR2) - 작업지시/런 번호
   *   P_SERIAL  (IN, NUMBER) - 시리얼 관련 값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_RUN_CARD - 제품 / 작업지시/런 관련 값 조회 또는 참조
   *   IP_PRODUCT_MODEL_MASTER - 제품 / 모델 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_SMTDATE_CODE - 관련 업무 함수 호출
   *   F_GET_SMT_LINE_CODE - 관련 업무 함수 호출
   *   F_GET_MONTH_CODE2 - 관련 업무 함수 호출
   *   F_GET_BASECODE - 관련 업무 함수 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 12회, ELSIF 8회 / 반복문: 0회
   *   DML: SELECT 13회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_PCB_BARCODE_SERIAL_BAK(...) FROM DUAL;
   * ================================================================ */
 F_GET_PCB_BARCODE_SERIAL_BAK (p_run_no IN VARCHAR2, p_serial IN NUMBER)
    RETURN VARCHAR2
IS
    lvs_return       VARCHAR2 (30);
    lvs_last_serial  VARCHAR2 (30);
    lvl_last_serial  number;
    
    lvdt_run_date        date;
    lvs_product_class    VARCHAR2 (30);
    lvs_customer_code    VARCHAR2 (30);
    lvs_model_name       VARCHAR2 (30);
    lvs_line_code        VARCHAR2(10) ;
    lvs_pcb_item         VARCHAR2(10) ;
    lvs_site_code        VARCHAR2(10) ;
    lvs_part_no          varchar2(30) ;
    
    lvl_carrier_size     number;
    
BEGIN
  
     
    -------------------------
    -- 
    ------------------------
        BEGIN
      
          select run_date , model_name , line_code , pcb_item , NVL(carrier_size, 0)
            INTO lvdt_run_date, lvs_model_name , lvs_line_code , lvs_pcb_item, lvl_carrier_size
            FROM ip_product_run_card
           WHERE run_no = p_run_no
             AND rownum = 1;     
            
          select product_class  , customer_code , site_code , part_no
            into lvs_product_class  , lvs_customer_code , lvs_site_code , lvs_part_no
            from ip_product_model_master
           where model_name = lvs_model_name ;
            
        EXCEPTION  
             
           WHEN NO_DATA_FOUND     THEN
              raise_application_error ( -20003, p_run_no || ' not found serial no ' || SQLERRM);
              
              WHEN OTHERS THEN
              raise_application_error (-20003, SQLERRM);
        END;          
   
   
         if lvs_customer_code = 'DC' then   
     
                -------------------------
                -- 델콤 바코드  
                ------------------------
                    select  lvs_product_class
                            ||' '
                            ||to_char(run_date,'YYMMDD')
                            ||TRIM(TO_CHAR(p_serial, '0000'))
                      INTO lvs_return
                      FROM ip_product_run_card 
                     WHERE run_no = p_run_no
                       AND rownum = 1;           
                
                 RETURN lvs_return;
             
            elsif lvs_customer_code = 'IP' then 
              
               if lvs_site_code = 'DANA' then
                 
                    -------------------------
                    -- 인팩 바코드   ( DANA )
                    ------------------------
                        select  lvs_product_class ||
                                F_GET_SMTDATE_CODE( lvs_model_name , lvdt_run_date ) ||
                                TRIM(TO_CHAR(p_serial, '00000'))
                          INTO lvs_return
                          FROM ip_product_run_card 
                         WHERE run_no = p_run_no
                           AND rownum = 1;   
                                   
                     RETURN lvs_return;                
                 
               
               else
                 
                    -------------------------
                    -- 인팩 바코드 라인지정 
                    ------------------------                    
                    
                     if ( lvs_line_code not in ( '05', '06','07', '08', '09') ) then
                          RAISE_APPLICATION_ERROR(-20000, '[인팩], 채번시 지정된 라인이 아닙니다 : E((05) ~ I(09)');
                          return null;                       
                     end if; 
                   
                    -------------------------
                    -- 인팩 바코드  
                    ------------------------
                        select  F_GET_SMTDATE_CODE( lvs_model_name , lvdt_run_date )||
                                -- SUBSTR(lvs_site_code,1,1)||    -- 2021/06/20 SHS : 주현씨 요청으로 라인코드로 변경 
                                F_GET_SMT_LINE_CODE(run_no)||     -- 단 F(06) 라인은 S로 대치
                                --SUBSTR(F_GET_LINE_NAME( lvs_line_code , 1 ),1,1)  ||
                                lvs_product_class||
                                LPAD( TO_CHAR(p_serial , 'fmXXX')  , 3 , 0 )||  --  TRIM(TO_CHAR(p_serial, '0000'))||
                                lvs_pcb_item
                          INTO lvs_return
                          FROM ip_product_run_card 
                         WHERE run_no = p_run_no
                           AND rownum = 1;    
                                  
                     RETURN lvs_return;                         
                 
                
                 end if;
                 
            elsif lvs_customer_code = 'IPCKD' then      
              
                    -------------------------
                    -- 인팩 CKD 바코드 
                    ------------------------
                        select  lvs_product_class ||
                                F_GET_SMTDATE_CODE( lvs_model_name , lvdt_run_date ) ||
                                TRIM(TO_CHAR(p_serial, '00000'))
                          INTO lvs_return
                          FROM ip_product_run_card 
                         WHERE run_no = p_run_no
                           AND rownum = 1;   
                                   
                     RETURN lvs_return;                             
                 
            elsif lvs_customer_code = 'IE' then 
                 -------------------------
                -- 인팩 이피엠 
                ------------------------
                
                    if lvs_site_code = '' then 
                        RAISE_APPLICATION_ERROR(-20000, 'Site Code Invalid Check, Model Master.');
                        return null;
                    end if ;
                    
                    select lvs_product_class||     --trim(substr(lvs_part_no,1,10))|| -- 10 자리 
                           lvs_site_code||         --4 자리 
                           F_GET_SMTDATE_CODE( lvs_model_name , lvdt_run_date )||
                           TRIM(TO_CHAR(p_serial, '00000'))
                      INTO lvs_return
                      FROM ip_product_run_card 
                     WHERE run_no = p_run_no
                       AND rownum = 1;   
                               
                 RETURN lvs_return;            
                 
             elsif lvs_customer_code = 'TS' then 
                -------------------------
                --  태성전장
                ------------------------
                
                if lvs_product_class = 'SO301-NX402' then      -- 2024/11/07 AAF 고객사 바코드 채번룰 수정 요청
                  
                        select 
                               lvs_product_class||
                               TO_CHAR(RUN_DATE , 'YYMMDD')||   
                               TRIM(TO_CHAR(p_serial, '0000')) -- serial 4자리    
                            --   LVS_PCB_ITEM                  -- 2022/04/22 이주현 사원 요청으로 변경
                                
                          INTO lvs_return
                          FROM ip_product_run_card 
                         WHERE run_no = p_run_no
                           AND rownum = 1;    
                       
                    else
                      
                        select 
                               lvs_product_class||
                               TO_CHAR(RUN_DATE , 'YYMMDD')||   
                               TRIM(TO_CHAR(p_serial, '00000')) --||   -- serial 5자리
                          --     LVS_PCB_ITEM
                                
                          INTO lvs_return
                          FROM ip_product_run_card 
                         WHERE run_no = p_run_no
                           AND rownum = 1; 
                                           
                    end if;
                           
                 RETURN lvs_return;   
                 
                 
            elsif lvs_customer_code = 'KI' then  
              
                ---------------------------------------------
                --  경일산업(KI) , 덕일산업
                ---------------------------------------------              
              
                                
                if lvl_carrier_size < 2 then 
                        RAISE_APPLICATION_ERROR(-20000, 'Carrier size Check, Model Master.');
                        return null;
                end if ;                 
                
                select to_char(run_date,'YY')                                                                                   -- YY
                       ||F_GET_MONTH_CODE2(to_char(run_date, 'MM'))                                                             -- M, 1~9, A,B,C
                       ||to_char(run_date,'DD')                                                                                 -- DD
                       ||f_get_basecode('LINE CODE', line_code,'K', 1)                                                          -- 01:A, 02:B, 03:C ~ 15:O ( isys_basecode 에 LINE CODE 의 mean value )
                       ||trim(to_char( floor( ( p_serial -1 ) / carrier_size ) +1, '0000'))                                           -- count 에 -1 하여 carrier size에 floor() 값에 +1 하여 다음 serial 값 게산
                       ||'-'                                                                                                    -- Fix code
                       ||trim(to_char( decode(mod( p_serial, carrier_size), 0, carrier_size, mod( p_serial, carrier_size) ), '00'))    -- MOD 값이 0 이면 carrier size 값 아니면 MOD 값
                  INTO lvs_return
                  FROM ip_product_run_card
                 WHERE run_no = p_run_no
                   AND rownum = 1;    
                   
                RETURN lvs_return;    
                
            elsif lvs_customer_code = 'TI' then  
              
                ---------------------------------------------
                --  테일테크
                ---------------------------------------------              
                                
                select -- to_char(run_date,'YYMMDD')                          -- 년월일  YYMMDD
                       F_GET_SMTDATE_CODE( lvs_model_name , lvdt_run_date )   -- YMD
                       ||lvs_product_class                                    -- 차종코드
                       ||TRIM(TO_CHAR(p_serial, '00000'))                     -- 시리얼
                  INTO lvs_return
                  FROM ip_product_run_card
                 WHERE run_no = p_run_no
                   AND rownum = 1;    
                RETURN lvs_return;      
                
            elsif lvs_customer_code = 'DY' then  
              
                ---------------------------------------------
                --  대양전기
                ---------------------------------------------      
                
                select lvs_product_class                                  -- 차종코드
                       || to_char(run_date,'YY')                          -- YY
                       ||F_GET_MONTH_CODE2(to_char(run_date, 'MM'))       -- M, 1~9, A,B,C
                       ||to_char(run_date,'DD')                           -- DD                       
                       ||TRIM(TO_CHAR(p_serial, '00000'))                 -- 시리얼
                  INTO lvs_return
                  FROM ip_product_run_card
                 WHERE run_no = p_run_no
                   AND rownum = 1;    
                   
                RETURN lvs_return ; 
                
                
            elsif lvs_customer_code = 'AT' then        
              
                ---------------------------------------------
                --  에이테크오토모티브 (AT) 
                ---------------------------------------------      
                
                select lvs_product_class                                       -- 차종코드
                       ||','                                                   -- FIX
                       ||lvs_site_code                                         -- SITE CODE
                       ||F_GET_SMTDATE_CODE( lvs_model_name , lvdt_run_date )  -- YMD code
                       ||TRIM(TO_CHAR(p_serial, '00000'))                      -- 시리얼
                       ||'1'                     -- 시리얼
                  INTO lvs_return
                  FROM ip_product_run_card
                 WHERE run_no = p_run_no
                   AND rownum = 1;    
                   
                RETURN lvs_return  ;                                                      
                                                
                           
            end if ;
            
            
END ; 
-------------------------------------------------------------
--
-------------------------------------------------------------;
