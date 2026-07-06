FUNCTION "F_GET_MAIN_SUPPLIER_CODE" (
   p_item_code   IN   VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvl_return                    NUMBER;
   lvs_supplier_code             VARCHAR2(30);
BEGIN
   SELECT COUNT(*)
   INTO   lvl_return
   FROM   im_item_master
   WHERE      item_code = p_item_code
          AND main_vendor_yn = 'Y'
          AND organization_id = p_org;

   IF lvl_return > 1
   THEN
      RETURN 'DUP';
   ELSIF lvl_return = 0
   THEN
      RETURN 'NOTFOUND';
   END IF;

   SELECT supplier_code
   INTO   lvs_supplier_code
   FROM   im_item_master
   WHERE      item_code = p_item_code
          AND main_vendor_yn = 'Y'
          AND organization_id = p_org;
   RETURN lvs_supplier_code;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;