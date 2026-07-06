FUNCTION "F_CHECK_ITEM_EXISTS" (
   p_set_item   IN   VARCHAR2,
   p_org        IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvi_count                     NUMBER;
BEGIN
   SELECT COUNT(*)
   INTO   lvi_count
   FROM   id_customer_set_bom
   WHERE      item_code = p_set_item
          AND item_code <> '*'
          AND organization_id = p_org;

   IF lvi_count > 0
   THEN
      RETURN 'EXISTS';
   ELSE
      RETURN 'NOTFOUND';
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 'NOTFOUND';
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;