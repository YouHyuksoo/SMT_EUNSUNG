FUNCTION "F_GET_CODE_MASTER" (
   p_code_type   IN   VARCHAR2,
   p_code_name   IN   VARCHAR2,
   p_lang        IN   VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN VARCHAR2
IS
   ls_return                     VARCHAR2(100);
BEGIN
   SELECT MAX( DECODE(
             p_lang, 'C', NVL(code_mean_local, ''), 'K', NVL(
                                                            code_mean_kor, ''
                                                         ), code_mean_eng
          ) )
   INTO   ls_return
   FROM   isys_code_master
   WHERE      code_type = UPPER(p_code_type)
          AND code_name = UPPER(p_code_name)
          AND organization_id = p_org;
   RETURN ls_return;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN '';
   WHEN OTHERS
   THEN
      raise_application_error(-20003, p_code_name||'  '||SQLERRM);
END;