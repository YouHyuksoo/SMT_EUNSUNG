FUNCTION "F_GET_MAT_CURRENCY" (
   p_supplier_code   IN   VARCHAR2,
   p_item_code       IN   VARCHAR2,
   p_date            IN   DATE,
   p_org             IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvs_currency                  VARCHAR2(3);
BEGIN
   SELECT currency
   INTO   lvs_currency
   FROM   im_item_unit_price
   WHERE      supplier_code = p_supplier_code
          AND item_code = p_item_code
          AND dateset <= p_date
          AND dateend >= p_date
          AND price_change_confirm_yn = 'Y'
          AND organization_id = p_org;
   RETURN lvs_currency;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;