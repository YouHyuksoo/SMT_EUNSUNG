FUNCTION "F_GET_MAT_SALE_INV_QTY_ITEM" (p_item_code IN varchar2 ,
         p_org IN NUMBER)
   RETURN NUMBER
IS
   lvf_sale_qty               NUMBER;
BEGIN
   SELECT SUM(inventory_qty)
   INTO   lvf_sale_qty
   FROM   im_item_sale_inventory
   WHERE  item_code = p_item_code
     AND organization_id = p_org;
   RETURN nvl(lvf_sale_qty,0);
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;