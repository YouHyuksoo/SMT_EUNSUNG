FUNCTION "F_GET_MAT_WS_INV_TIME_QTY" (
   p_item_code   IN VARCHAR2,
   p_lot_no      IN VARCHAR2,
   p_org         IN NUMBER,
   p_date        IN DATE)
   RETURN NUMBER
IS
   lvf_inventory_qty      NUMBER;
   lvf_ws_inventory_qty   NUMBER;
   lvf_return_qty         NUMBER;
BEGIN
   SELECT NVL (inventory_qty, 0), NVL (ws_inv_qty, 0)
     INTO lvf_inventory_qty, lvf_ws_inventory_qty
     FROM IM_ITEM_INVENTORY_4_TIME
    WHERE     item_code = p_item_code
          AND material_mfs = p_lot_no
          AND inventory_time = p_date;


   --
   --  /*？？？*/
   --  SELECT NVL(SUM(inventory_qty),0)
   --    INTO lvf_inventory_qty
   --    FROM im_item_workstage_inventory
   --   WHERE item_code       = p_item_code
   --        AND material_mfs = p_lot_no
   --        AND organization_id = p_org;
   --
   --  /*？？？？？？？？？
   --  SELECT nvl(sum(x.issue_qty),0)
   --    INTO lvf_issue_qty
   --    FROM im_item_workstage_issue x
   --   WHERE organization_id = p_org
   --     AND item_code like p_item_code
   --     AND material_mfs = p_lot_no
   --     AND enter_date > p_date   ;
   --
   --  /*？？？？？？？？？
   --  SELECT nvl(sum(x.receipt_qty),0)
   --    INTO lvf_receipt_qty
   --    FROM im_item_workstage_receipt x
   --   WHERE organization_id = p_org
   --     AND item_code like p_item_code
   --     AND material_mfs = p_lot_no
   --     AND enter_date > p_date ;
   --

   lvf_return_qty := lvf_ws_inventory_qty;


   RETURN lvf_return_qty;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;