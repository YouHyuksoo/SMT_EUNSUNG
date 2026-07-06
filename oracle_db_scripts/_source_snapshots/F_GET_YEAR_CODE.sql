FUNCTION F_GET_YEAR_CODE (
   p_model_name   IN VARCHAR2,
   p_yyyy         IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvs_return   VARCHAR2 (2);
   lvs_yyyy     VARCHAR2 (10);
   lvs_mm       VARCHAR2 (10);
BEGIN
   -------------------------------------------------------------------------
   --
   -------------------------------------------------------------------------
   BEGIN
     
      SELECT yyyy_code
        INTO lvs_yyyy
        FROM ip_product_year_base
       WHERE model_name = p_model_name AND yyyy = SUBSTR (p_yyyy, 1, 4);
       
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
      
         --lvs_yyyy := TO_CHAR (SYSDATE, 'Y');
         --lvs_yyyy := '*' ;
         
         select trim(substr(to_char(sysdate,'YYYY'),4,1))
          into lvs_yyyy
          from dual;
           
         -- RAISE_APPLICATION_ERROR(-20003, '생산월력 미등록 ( f_get_year_code ) => '||p_model_name||', '||SUBSTR (p_yyyy, 1, 4) ||' => '|| SQLERRM ) ;
     
   END;

   lvs_return := lvs_yyyy;

   RETURN lvs_return;

EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (
         -20003,
            'f_get_year_code MODEL NAME='
         || p_model_name
         || ' YYYY='
         || p_yyyy
         || '  '
         || SQLERRM);
END;
