PROCEDURE "P_CHECK_PCB_INFO_BARCODE" (
                                                      p_pcb_barcode       IN     VARCHAR2,   -- scan된 barcode 정보
                                                      p_input_field       IN     VARCHAR2,   -- P:part no, V:supplier, Q:Qty, H:Lot No, 입력 filed 위치     
                                                          
                                                      p_out_result        OUT    VARCHAR2,   -- PCB barcode 검토 결과 OK/NG
                                                      p_out_type          OUT    VARCHAR2,   -- U:통합, S:개별
                                                      p_out_part_no       OUT    VARCHAR2,   -- PCB barcode 내 part no
                                                      p_out_supplier      OUT    VARCHAR2,   -- PCB barcode 내 supplier
                                                      p_out_qty           OUT    VARCHAR2,   -- PCB barcode 내 qty
                                                      p_out_lot_no        OUT    VARCHAR2    -- PCB barcode 내 lot no                  
                                                     )
IS

   lvs_type   VARCHAR2(10);
                            
BEGIN
  
   --------------------------------------------------------------------------------------------------------------------------------------------------
   -- 2016/08/29 SHS, Laser marking 시 PCB 정보 등록을 위한 PCB barcode 정보 parsing
   --------------------------------------------------------------------------------------------------------------------------------------------------
   
   -- return 변수 초기화
  
   p_out_result   := 'NG';
   p_out_type     := '';
   
   p_out_part_no  := '';   
   p_out_supplier := '';     
   p_out_qty      := '';     
   p_out_lot_no   := '';


   -- 통합 Barcode check
         
   IF  (SUBSTR(p_pcb_barcode, 1,6) = '[)>@06') or (SUBSTR(p_pcb_barcode, 1,6) = '[)>'||CHR(30)||'06')  or (REGEXP_COUNT(p_pcb_barcode, ',') = 3 or (SUBSTR(p_pcb_barcode, 1,5) = '[)>06')) THEN
      
        p_out_type := 'U';
        
        BEGIN
          
           SELECT F_GET_PCB_INFO_FROM_BARCODE(p_pcb_barcode, 'P'),
                  F_GET_PCB_INFO_FROM_BARCODE(p_pcb_barcode, 'V'),
                  F_GET_PCB_INFO_FROM_BARCODE(p_pcb_barcode, 'Q'),
                  F_GET_PCB_INFO_FROM_BARCODE(p_pcb_barcode, 'S')
             INTO p_out_part_no,       
                  p_out_supplier,      
                  p_out_qty,           
                  p_out_lot_no
             FROM dual;
             
        END; 
        
        p_out_result := 'OK';
        
   ELSE
     
   -- 개별 Barcode 확인
   
       p_out_type := 'S';
   
       lvs_type := substr(p_pcb_barcode, 1,1);
              
       -- Part no
       IF    lvs_type = 'P' then
         
             BEGIN
                
                SELECT F_GET_PCB_INFO_FROM_BARCODE(p_pcb_barcode, 'P')                  
                  INTO p_out_part_no      
                  FROM dual;
             
             END;
             
             p_out_result := 'OK';
      
       -- supplier       
       ELSIF lvs_type = 'V' THEN
       
             BEGIN
               
                SELECT F_GET_PCB_INFO_FROM_BARCODE(p_pcb_barcode, 'V')                   
                  INTO p_out_supplier      
                  FROM dual;
             
             END;
             
             p_out_result := 'OK';

       -- qty    
       ELSIF lvs_type = 'Q' then
       
             begin
               
                SELECT F_GET_PCB_INFO_FROM_BARCODE(p_pcb_barcode, 'Q')                  
                  INTO p_out_qty       
                  FROM dual;
             
             END;
             
             p_out_result := 'OK';

       -- Lot no
       ELSIF lvs_type = 'H' or lvs_type = 'S'then      
       
             BEGIN
               
                SELECT F_GET_PCB_INFO_FROM_BARCODE(p_pcb_barcode, 'S')                  
                  INTO p_out_lot_no      
                  FROM dual;
             
             END;
             
             p_out_result := 'OK';

       ELSE
         
              p_out_result   := 'NG';
              
              p_out_part_no  := '';   
              p_out_supplier := '';     
              p_out_qty      := '';     
              p_out_lot_no   := '';
         
       END IF;  
     
   END IF;   
                  
   
EXCEPTION
  
   WHEN OTHERS THEN
     
       p_out_result   := 'NG';
       p_out_type     := '';
   
       p_out_part_no  := '';   
       p_out_supplier := '';     
       p_out_qty      := '';     
       p_out_lot_no   := '';
          
END;