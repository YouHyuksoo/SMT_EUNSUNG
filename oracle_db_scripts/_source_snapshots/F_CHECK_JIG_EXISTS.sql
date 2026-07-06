FUNCTION "F_CHECK_JIG_EXISTS" (
   p_item_code   IN VARCHAR2,
   p_org         IN NUMBER)
   RETURN VARCHAR2
IS
   lvl_cnt   NUMBER;
BEGIN
   -------------------------------------------------------

   BEGIN
      SELECT
             COUNT (*)
      INTO
             lvl_cnt
      FROM
             IMCN_JIG_APPLY_MODEL
      WHERE
             ITEM_CODE = p_item_code AND organization_id = p_org;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_cnt := 0;
   END;


   IF lvl_cnt = 0
   THEN
      RETURN 'NOTFOUND';
   ELSE
      RETURN 'EXISTS';
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;