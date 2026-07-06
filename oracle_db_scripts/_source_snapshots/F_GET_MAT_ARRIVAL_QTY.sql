FUNCTION "F_GET_MAT_ARRIVAL_QTY" (
   p_item_code   IN   VARCHAR2,
   p_line_type   IN   VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_arrival_qty               NUMBER;
BEGIN
   SELECT SUM(arrival_qty)
   INTO   lvf_arrival_qty
   FROM   im_item_arrival
   WHERE      item_code = p_item_code
          AND line_type = p_line_type
          AND arrival_type = 'A'
          AND arrival_status = 'N'
          AND organization_id = p_org;
   RETURN NVL(lvf_arrival_qty, 0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;