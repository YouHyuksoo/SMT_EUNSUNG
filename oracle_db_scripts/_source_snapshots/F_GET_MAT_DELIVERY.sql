FUNCTION "F_GET_MAT_DELIVERY" (
   p_supplier_code            IN       VARCHAR2,
   p_item_code                IN       VARCHAR2,
   p_line_type                IN       VARCHAR2,
   p_date                     IN       DATE,
   p_org                      IN       NUMBER
)
   RETURN NUMBER
IS
   lvs_delivery                  VARCHAR2( 10 );
BEGIN
   SELECT delivery
     INTO lvs_delivery
     FROM im_item_unit_price
    WHERE supplier_code = p_supplier_code
      AND item_code = p_item_code
      AND line_type = p_line_type
      AND dateset <= p_date
      AND dateend >= p_date
      AND organization_id = p_org;

   RETURN lvs_delivery;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN '2'; -- DEFAULT DELIVERY RETURN DEOMESTIC
   WHEN OTHERS THEN
      raise_application_error( -20003, SQLERRM );
END;