FUNCTION "F_GET_MAIN_VENDOR_COUNT" (
   p_item_code   IN   VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN NUMBER
IS
   lvl_return                    NUMBER;
BEGIN
   SELECT COUNT(*)
   INTO   lvl_return
   FROM   im_item_master
   WHERE  item_code = p_item_code AND
          main_vendor_yn = 'Y'    AND
          organization_id = p_org;
   RETURN lvl_return;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;