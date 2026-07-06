FUNCTION F_GET_SMTDATE_CODE (p_model_name IN VARCHAR2, p_yyyymmdd IN DATE)
RETURN VARCHAR2
IS

   lvs_yyyymmdd_code   VARCHAR2 (10);
   lvs_yyyy            VARCHAR2 (10);
   
BEGIN
  
-- ===================================================
--  년 코드 미등록시 NG 처리
-- ===================================================

   BEGIN
     
      SELECT yyyy_code
        INTO lvs_yyyy
        FROM ip_product_year_base
       WHERE model_name = p_model_name AND yyyy = to_char(p_yyyymmdd, 'YYYY');
       
   EXCEPTION
      WHEN NO_DATA_FOUND THEN

           RAISE_APPLICATION_ERROR(-20003, '생산월력 미등록 ( F_GET_SMTDATE_CODE ) => '||p_model_name||', '|| to_char(p_yyyymmdd, 'YYYY') ||' => '|| SQLERRM ) ;
           
   END;     
       
-- ===================================================
--  YMD CODE 처리
-- ===================================================

   lvs_yyyymmdd_code := f_get_year_code (p_model_name, SUBSTR (TO_CHAR (p_yyyymmdd, 'yyyymmdd'), 1, 6))
                        ||f_get_month_code(p_model_name,  SUBSTR (TO_CHAR (p_yyyymmdd, 'yyyymmdd'), 1, 6))
                        ||f_get_day_code (SUBSTR (TO_CHAR (p_yyyymmdd, 'yyyymmdd'), 7, 2));
                        
      
   RETURN lvs_yyyymmdd_code;
   
   
EXCEPTION
    WHEN NO_DATA_FOUND THEN
         RETURN '**' ;

   WHEN OTHERS THEN
        raise_application_error (-20003, 'f_get_smtdate_code MODEL NAME='||p_model_name||'  '||SQLERRM);
        
END;
