FUNCTION F_GET_ITEM_CODE_FROM_BARCODE (
   p_barcode IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvi_pos1     NUMBER;
   lvi_pos2     NUMBER;
   lvi_pos3     NUMBER; 

   lvi_gap      NUMBER;
   lvs_return   VARCHAR2 (300);
   lvs_barcode  varchar2(300);
   
   lvs_item     VARCHAR2 (30);
   lvi_count    NUMBER;
   
BEGIN
   
   
   lvs_barcode :=  p_barcode ;
  
   --------------------------------------------------------
   --  
   --------------------------------------------------------

   select regexp_count( lvs_barcode, '-') 
     into lvi_count
     from dual;
    
    
   if ( lvi_count = 2 ) then
             
        select regexp_substr( lvs_barcode, '[^-]+', 1,1 ) 
          into lvs_item
          from dual;
          
        if ( length( lvs_item ) > 9 and length( lvs_item ) < 14 ) then
          
              return lvs_item;   
        
        end if;
             
    end if;         
             
   
   --------------------------------------------------------
   --  item code 찾는 로직
   --------------------------------------------------------
   
   BEGIN
     
         select item_code
           into lvs_item
           from id_item
          where ( item_code = p_barcode
             or part_no   like p_barcode
             or instr( part_no, p_barcode ) > 0
             or instr( p_barcode, part_no ) > 0)
             and length(item_code) > 5
             ;
             
        IF ( SQL%ROWCOUNT = 1 ) THEN
          
             RETURN lvs_item;
             
        END IF;
     
   EXCEPTION
            WHEN OTHERS THEN               
                 NULL; 
   END; 
          
   --------------------------------------------------------
   -- 자사바코드 포맷
   --------------------------------------------------------
   lvi_pos1 := INSTR (lvs_barcode, '-', 1,1);
   lvi_pos2 := INSTR (lvs_barcode, '-', 1,2);
   lvi_pos3 := INSTR (lvs_barcode, '-', 1,3);
   
   --두개짜리 바코드 이면 
   IF lvi_pos3 = 0  THEN 
        lvs_return := TRIM (SUBSTR (lvs_barcode, 1, INSTR (lvs_barcode, '-', 1,1) - 1));        
   ELSE
        lvs_return := TRIM (SUBSTR (lvs_barcode, 1,INSTR (lvs_barcode, '-', 1,2) - 1   ));  
   END IF;
   
   --------------------------------------------------------
   -- 원자재 바코드 확인
   --------------------------------------------------------
   
   SELECT COUNT(*)
     INTO lvi_count
     FROM ID_ITEM
    WHERE ITEM_CODE = lvs_return;
    
   IF ( lvi_count = 0 ) THEN
     
        lvs_item := lvs_return;
     
        BEGIN
          
           SELECT item_code
             INTO lvs_return
             FROM ID_ITEM
            WHERE ( INSTR(lvs_return, part_no) > 0 OR INSTR( part_no , lvs_return) > 0 ) 
              AND ROWNUM = 1;
        
        EXCEPTION
            WHEN OTHERS THEN               
                 lvs_return := lvs_item; 
        END; 
   
   END IF;
        
   RETURN lvs_return;
         
   
EXCEPTION
   WHEN OTHERS THEN
        RETURN lvs_barcode;
END;
