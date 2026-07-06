FUNCTION "F_GET_PREPARE_SUPPLIER_BARCODE" (
   p_barcode IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvs_return   VARCHAR2 (100);
   lvi_pos1     NUMBER;
   lvi_pos2     NUMBER;
BEGIN

------------------------------------------------------------------
--    / 가 10 이상 되면 인팩 자재로 판단 
------------------------------------------------------------------
     if   instr(p_barcode , '/' , 1 , 5)  > 0 then 
    
       lvs_return := TRIM (SUBSTR (p_barcode, 1, instr(p_barcode , '/' , 1)-1 ));
       RETURN lvs_return; 
  
      else
          return p_barcode ;
      end if ;
   
   
   -------------------------------------------------------------------------------
---- 수원용 삼성 바코드  
---- PG62TA1/CL21B472KBANNNC/0583/4000
---- 1 / 34 / 67 / 9
-------------------------------------------------------------------------------
--lvi_pos1 := 0;
--lvi_pos1 := INSTR (lvs_barcode, '/', 1,1);
--lvi_pos2 := INSTR (lvs_barcode, '/', 1,2);
--lvi_pos3 := INSTR (lvs_barcode, '/', 1,3);
--
--   --두개짜리 바코드 이면 
--   IF lvi_pos3 >  0  THEN 
--        lvs_return := TRIM (SUBSTR (lvs_barcode, INSTR (lvs_barcode, '/', 1,1) + 1 ,  lvi_pos2 - lvi_pos1 - 1     ));        
--   END IF;
--   
--   RETURN NVL(lvs_return , '*') ;  
   
   
   
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN p_barcode;
END;