FUNCTION "F_CHECK_OQC_CRITERION" (
   p_item_code   IN   VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvl_count                     NUMBER;
BEGIN
   SELECT COUNT(*)
   INTO   lvl_count
   FROM   iq_item_oqc_criterion
   WHERE      item_code = p_item_code
          AND organization_id = p_org;

   IF lvl_count > 0
   THEN
      RETURN 'EXISTS';
   ELSE
      RETURN 'NOTFOUND';
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;