FUNCTION "F_GET_MAT_RECEIPT_BY_LOC_MFS" (
   p_item_code   IN   VARCHAR2,
   p_material_mfs       IN   varchar2,
   p_location_code in varchar2 ,
   p_org         IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_receipt_qty   NUMBER;
BEGIN
   SELECT SUM (receipt_qty)
     INTO lvf_receipt_qty
     FROM im_item_receipt
    WHERE item_code = p_item_code
      AND material_mfs = p_material_mfs
      AND LOCATION_CODE = P_LOCATION_CODE
      AND organization_id = p_org;

   RETURN NVL (lvf_receipt_qty, 0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
END;