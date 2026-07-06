FUNCTION "F_GET_MAT_WS_INV_QTY" (
   p_item_code   IN VARCHAR2,
   p_org         IN NUMBER)
   RETURN NUMBER
IS
   lvf_inventory_qty   NUMBER;
   LVL_FEEDING_QTY     NUMBER;
BEGIN

   --   SELECT SUM(inventory_qty)
   --   INTO   lvf_inventory_qty
   --   FROM   im_item_workstage_inventory
   --   WHERE  item_code = p_item_code AND
   --          organization_id = p_org;
   --------------------------------------------------------------
   --
   --------------------------------------------------------------


   SELECT NVL(SUM (NVL(feeding_qty,0) - NVL(product_actual_qty,0)),0)
     INTO LVL_FEEDING_QTY
     FROM iB_product_plandata
    WHERE item_code = p_item_code
          AND active_yn = 'Y';


-- SELECT SUM (a.inventory_qty)
--     INTO lvf_inventory_qty
--     FROM im_item_workstage_inventory a
--    WHERE     a.item_code = p_item_code
--          AND a.organization_id = p_org ;


   SELECT SUM(DECODE( NVL(NEW_SCAN_QTY, 0 ) , 0 , SCAN_QTY , NEW_SCAN_QTY  ) )
     INTO lvf_inventory_qty
     FROM im_item_receipt_barcode
    WHERE     item_code = p_item_code
          AND ISSUE_COMPARE_YN  = 'Y'
          AND FEEDING_YN = 'N'
          AND organization_id = p_org ;

--      select sum(nvl(B.scan_qty,0))
--      into LVL_FEEDING_QTY
--      from im_item_workstage_inventory A left outer join im_item_receipt_barcode B on A.item_code = B.item_code and A.material_mfs = B.lot_no and B.feeding_yn = 'N' and A.organization_id = B.organization_id
--      WHERE a.item_code = p_item_code and
--            a.organization_id = p_org;

   RETURN NVL (lvf_inventory_qty, 0) + NVL(LVL_FEEDING_QTY,0) ;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;