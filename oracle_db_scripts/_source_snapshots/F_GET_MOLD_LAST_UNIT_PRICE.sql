FUNCTION "F_GET_MOLD_LAST_UNIT_PRICE" (
   p_supplier_code   IN   VARCHAR2,
   p_item_code       IN   VARCHAR2,
   p_date                 DATE,
   p_org             IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_return                    NUMBER;
   lvd_date                      DATE;
BEGIN
   BEGIN
      SELECT MAX(dateset)
      INTO   lvd_date
      FROM   imcn_mold_unit_price
      WHERE  supplier_code = p_supplier_code AND
             mold_code = p_item_code         AND
             dateset < p_date                AND
             organization_id = p_org;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;

   SELECT unit_price
   INTO   lvf_return
   FROM   imcn_mold_unit_price
   WHERE  supplier_code = p_supplier_code AND
          mold_code = p_item_code         AND
          dateset = lvd_date              AND
          organization_id = p_org;
   RETURN lvf_return;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;