FUNCTION "F_GET_MAT_ARRIVAL_QTY_ITEM" (
   p_item_code       IN   VARCHAR2,
   p_location_code   IN   VARCHAR2,
   p_org             IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_arrival_qty               NUMBER;
BEGIN
   SELECT SUM(arrival_qty)
   INTO   lvf_arrival_qty
   FROM   im_item_arrival
   WHERE      item_code = p_item_code
          AND arrival_type = 'A'
          AND arrival_status = 'N'
          AND arrival_location_code = p_location_code
          AND organization_id = p_org;
   RETURN nvl(lvf_arrival_qty,0);
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;