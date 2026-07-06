CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_PCB_BARCODE_FIXVAL
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
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_RUN_CARD - 제품 / 작업지시/런 관련 값 조회 또는 참조
   *   IP_PRODUCT_MODEL_MASTER - 제품 / 모델 관련 값 조회 또는 참조
   *   IP_PRODUCT_2D_BARCODE - 바코드 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 6회, ELSIF 8회 / 반복문: 0회
   *   DML: SELECT 3회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_PCB_BARCODE_FIXVAL(...) FROM DUAL;
   * ================================================================ */
 F_GET_PCB_BARCODE_FIXVAL (p_run_no IN VARCHAR2)
    RETURN VARCHAR2
IS
    lvs_return       VARCHAR2 (30);
    lvs_last_serial  VARCHAR2 (30);
    lvl_last_serial  number;
    
    lvdt_run_date        date;
    lvs_product_class    VARCHAR2 (30);
    lvs_customer_code    VARCHAR2 (30);
    lvs_model_name       VARCHAR2 (30);
    lvs_line_code        VARCHAR2 (10) ;
    lvs_pcb_item         VARCHAR2 (10) ;
    lvs_site_code        VARCHAR2 (10) ;
    lvs_part_no          varchar2 (30) ;
    
    lvl_carrier_size     number;
    
    lvs_min_serial_no    varchar2 (30);
    
BEGIN
     
    -------------------------
    -- 기준정보 확인
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
           
          select MIN(serial_no)
            into lvs_min_serial_no
            from ip_product_2d_barcode
           where run_no = p_run_no ;           
            
        EXCEPTION  
             
           WHEN NO_DATA_FOUND     THEN
              raise_application_error ( -20003, p_run_no || ' not found serial no ' || SQLERRM);
              
              WHEN OTHERS THEN
              raise_application_error ( -20003, SQLERRM);
        END;          
   
    -------------------------------------------------------------
    -- 고객사별 대표바코드 확인 ( 고정분 , 변동분 제거 )
    -------------------------------------------------------------
   
        if lvs_customer_code = 'DC' then   
     
           -------------------------
           -- 델콤 바코드  
           ------------------------
                  
           lvs_return := substr( lvs_min_serial_no, 1, length( lvs_min_serial_no ) - 5);             
                               
        elsif lvs_customer_code = 'IP' then 
              
              if lvs_site_code = 'DANA' then
                 
                 -------------------------
                 -- 인팩 바코드   ( DANA )
                 ------------------------
                    
                 lvs_return := substr( lvs_min_serial_no, 1, length( lvs_min_serial_no ) - 5);  
                     
              else
                 
                 -------------------------
                 -- 인팩 바코드  
                 ------------------------
                    
                 lvs_return := substr( lvs_min_serial_no, 1, length( lvs_min_serial_no ) - 4);   
                
              end if;
                 
        elsif lvs_customer_code = 'IPCKD' then      
              
              -------------------------
              -- 인팩 CKD 바코드 
              ------------------------
              lvs_return := substr( lvs_min_serial_no, 1, length( lvs_min_serial_no ) - 5); 
                 
        elsif lvs_customer_code = 'IE' then 
          
              -------------------------
              -- 인팩 이피엠 
              ------------------------
                
              lvs_return := substr( lvs_min_serial_no, 1, length( lvs_min_serial_no ) - 5); 
                 
        elsif lvs_customer_code = 'TS' then 
          
              -------------------------
              --  태성전장
              ------------------------
                
              if lvs_product_class = 'SO301-NX402' then
             
                 lvs_return := substr( lvs_min_serial_no, 1, length( lvs_min_serial_no ) - 4 );    
                      
              else
                     
                 lvs_return := substr( lvs_min_serial_no, 1, length( lvs_min_serial_no ) - 5 ); 
                                           
              end if;
                 
        elsif lvs_customer_code = 'KI' then  
              
              ---------------------------------------------
              --  경일산업(KI) , 덕일산업
              ---------------------------------------------              
              
              lvs_return := substr( lvs_min_serial_no, 1, length( lvs_min_serial_no ) - 7 ); 
                
        elsif lvs_customer_code = 'TI' then  
              
              ---------------------------------------------
              --  테일테크
              ---------------------------------------------              
                                
              lvs_return := substr( lvs_min_serial_no, 1, length( lvs_min_serial_no ) - 5 );      
                
        elsif lvs_customer_code = 'DY' then  
              
              ---------------------------------------------
              --  대양전기
              ---------------------------------------------      
                
              lvs_return := substr( lvs_min_serial_no, 1, length( lvs_min_serial_no ) - 5 );     
              
                
        elsif lvs_customer_code = 'AT' then  
              
              ---------------------------------------------
              --  에이테크오토모티브 (AT) 
              ---------------------------------------------      
                
              lvs_return := substr( lvs_min_serial_no, 1, length( lvs_min_serial_no ) - 6 );                                                
                           
        end if ;
            
-------------------------------------------------------------
--
-------------------------------------------------------------            
            
            
        RETURN lvs_return;      
            
END ;
