FUNCTION "F_GET_ITEM_CODE_FROM_BARCODE_S" (
   p_barcode IN VARCHAR2,
   p_supplier_code IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvi_pos1     NUMBER;
   lvi_pos2     NUMBER;
   lvi_pos3   number ;
   lvi_gap      NUMBER;
   lvs_return   VARCHAR2 (300);
   lvs_barcode  varchar2(300);
   lvs_item     VARCHAR2 (30);
   lvi_count    NUMBER;

BEGIN
   ---------------------------------------------------------
   --
   ---------------------------------------------------------
   lvs_barcode := F_GET_PREPARE_SUPPLIER_BARCODE(p_barcode) ;
   
   --------------------------------------------------------
   --  item code 찾는 로직
   --------------------------------------------------------

   BEGIN
   
         BEGIN 
          -- 1차적으로 정확하게 맞는것 체크 
           select item_code
           into lvs_item
           from id_item
          where supplier_code = p_supplier_code AND 
             ( item_code = lvs_barcode  or TRIM(part_no) like TRIM(lvs_barcode)   )
             and length(item_code) > 5
             ;
            
            IF ( SQL%ROWCOUNT  = 1 ) THEN
              RETURN lvs_item;
            END IF;
            
           EXCEPTION WHEN NO_DATA_FOUND THEN 
                NULL ;
           END ;
  
        BEGIN         -- 시작문자로 시작하면서 포함 여부 체크 
         select item_code
           into lvs_item
           from id_item
          where supplier_code = p_supplier_code AND 
             ( item_code = lvs_barcode
             or TRIM(part_no)   like TRIM(lvs_barcode)
             or instr( part_no, lvs_barcode ) > 0
             or instr( lvs_barcode, part_no ) = 1)
             and length(item_code) > 5
             ;

        IF ( SQL%ROWCOUNT  = 1 ) THEN
             RETURN lvs_item;
        END IF;


         EXCEPTION WHEN NO_DATA_FOUND THEN 
                NULL ;
          END ;
  
  
  
       BEGIN         -- 시작 포함 중간어딘가에 포함 여부 체크 
         select item_code
           into lvs_item
           from id_item
          where supplier_code = p_supplier_code AND 
             ( item_code = lvs_barcode
             or TRIM(part_no)   like TRIM(lvs_barcode)
             or instr( part_no, lvs_barcode ) > 0
             or instr( lvs_barcode, part_no ) > 0)
             and length(item_code) > 5
             ;

        IF ( SQL%ROWCOUNT  = 1 ) THEN
             RETURN lvs_item;
        END IF;


         EXCEPTION WHEN NO_DATA_FOUND THEN 
                NULL ;
          END ;
           
           
   EXCEPTION
            WHEN OTHERS THEN               
                 NULL; 
   END; 
   
   
 --  RETURN p_barcode ;   -- 더이상 찾지 않는다
   
   

   --------------------------------------------------------
   -- 자사바코드 포맷
   --------------------------------------------------------
   lvi_pos1 := INSTR (lvs_barcode, '-', 1,1);
   lvi_pos2 := INSTR (lvs_barcode, '-', 1,2);
   lvi_pos3 := INSTR (lvs_barcode, '-', 1,3);
   
  
   IF lvi_pos1 = 0  THEN 
      lvs_return :=   lvs_barcode ;
   ELSIF  lvi_pos1 > 0 AND  lvi_pos2 > 0 AND lvi_pos3 = 0 THEN 
         lvs_return := TRIM (SUBSTR (lvs_barcode, 1, INSTR (lvs_barcode, '-', 1,1) - 1));       
   --품목코드에 "-" 가 포함되어 있다는 의미로 두번쨰꺼 까지 포함해서 품목으로 잘나냄      
   ELSIF  lvi_pos1 > 0 AND  lvi_pos2 > 0 AND lvi_pos3 > 0 THEN 
         lvs_return := TRIM (SUBSTR (lvs_barcode, 1,INSTR (lvs_barcode, '-', 1,2) - 1   ));  
   END IF;

   --------------------------------------------------------
   -- 원자재 바코드 확인
   --------------------------------------------------------
 begin 
   SELECT COUNT(*)
     INTO lvi_count
     FROM ID_ITEM
    WHERE ITEM_CODE = lvs_return
      AND supplier_code = p_supplier_code;
  EXCEPTION
            WHEN no_data_found THEN               
                 lvi_count := 0 ;       
end ;

   IF ( lvi_count = 0 ) THEN

        lvs_item := lvs_return;

        BEGIN

           SELECT item_code
             INTO lvs_return
             FROM ID_ITEM
            WHERE supplier_code = p_supplier_code
              AND ( INSTR(lvs_return, part_no) > 0 OR   INSTR(part_no , lvs_return) > 0 ) 
              AND ROWNUM = 1;

        EXCEPTION
            WHEN OTHERS THEN               
                 lvs_return := lvs_item; 
        END; 
        
        RETURN NVL(lvs_return , '*') ;
   ELSE
        RETURN NVL(lvs_return , '*') ;
   END IF;
   

-----------------------------------------------------------------------------
EXCEPTION
   WHEN OTHERS THEN
        RETURN lvs_barcode;
END;
