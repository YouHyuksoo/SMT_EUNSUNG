FUNCTION F_GET_PCB_BARCODE_FIXVAL (p_run_no IN VARCHAR2)
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

