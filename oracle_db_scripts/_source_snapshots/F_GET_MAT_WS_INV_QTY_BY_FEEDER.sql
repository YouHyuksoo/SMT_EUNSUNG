FUNCTION "F_GET_MAT_WS_INV_QTY_BY_FEEDER" (
   p_item_code      IN VARCHAR2,
   p_line_code      IN VARCHAR2,
   p_material_mfs   IN VARCHAR2,
   p_feeder_shaft   IN VARCHAR2,
   p_org            IN NUMBER)
   RETURN NUMBER
IS
   lvf_inventory_qty   NUMBER;
   LVL_FEEDING_QTY     NUMBER;
BEGIN
   --------------------------------------------------------------
   --
   --------------------------------------------------------------


   SELECT NVL (SUM (NVL (feeding_qty, 0) - NVL (product_actual_qty, 0)), 0)
     INTO LVL_FEEDING_QTY
     FROM iB_product_plandata
    WHERE     item_code = p_item_code
          AND LINE_CODE = P_LINE_CODE
          AND lot_no = p_material_mfs
          AND FEEDER_SHAFT = p_feeder_shaft
          AND active_yn = 'Y';


   --  SELECT SUM (a.inventory_qty)
   --     INTO lvf_inventory_qty
   --     FROM im_item_workstage_inventory a
   --    WHERE     a.item_code = p_item_code
   --          AND A.MATERIAL_MFS = p_material_mfs
   --          AND a.organization_id = p_org
   --          AND A.LINE_CODE = p_line_code;
   --



   SELECT SUM (DECODE (NVL (NEW_SCAN_QTY, 0), 0, SCAN_QTY, NEW_SCAN_QTY))
     INTO lvf_inventory_qty
     FROM im_item_receipt_barcode
    WHERE     item_code = p_item_code
          AND ISSUE_COMPARE_YN = 'Y'
          AND FEEDING_YN = 'N'
          AND LINE_CODE = P_LINE_CODE
          AND LOT_NO = p_material_mfs
          AND FEEDER_SHAFT = p_feeder_shaft
          AND organization_id = p_org;

   RETURN NVL (lvf_inventory_qty, 0) + NVL (LVL_FEEDING_QTY, 0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;