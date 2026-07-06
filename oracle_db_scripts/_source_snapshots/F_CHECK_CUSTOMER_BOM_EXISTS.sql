FUNCTION "F_CHECK_CUSTOMER_BOM_EXISTS" (
   p_set_item_code   IN   VARCHAR2,
   p_dateset         IN   DATE,
   p_org             IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvi_count                     NUMBER;
BEGIN
   SELECT COUNT(*)
   INTO   lvi_count
   FROM   id_customer_set_bom
   WHERE      set_item_code = p_set_item_code
          AND item_code <> '*'
          AND dateset <= p_dateset
          AND dateend >= p_dateset
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