FUNCTION "F_GET_SAL_PROD_INV_BY_ITEM" (
   p_item_code   IN   VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_inventory_qty             NUMBER;
BEGIN
   return 0 ;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;