FUNCTION "F_GET_MAX_SUPPLIER_BY_ITEM" (
   p_item_code   IN VARCHAR2,
   p_org         IN NUMBER)
   RETURN VARCHAR2
IS
   -- ---------   ------  -------------------------------------------
   lvs_supplier_code   VARCHAR2 (20);
   lvi_count           NUMBER;
BEGIN
   BEGIN
      SELECT MAX (supplier_code)
        INTO lvs_supplier_code
        FROM ID_ITEM
       WHERE item_code = p_item_code AND organization_id = p_org;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvs_supplier_code := '*';
      WHEN OTHERS
      THEN
         raise_application_error (-20003, SQLERRM);
   END;

   RETURN lvs_supplier_code;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN '*';
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;