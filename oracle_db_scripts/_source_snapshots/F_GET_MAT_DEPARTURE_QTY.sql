FUNCTION "F_GET_MAT_DEPARTURE_QTY" (p_item_code IN VARCHAR2,p_line_type IN varchar2 , p_org IN NUMBER)
   RETURN NUMBER
IS
   lvf_departure_qty             NUMBER;
BEGIN
   SELECT SUM(arrival_qty)
   INTO   lvf_departure_qty
   FROM   im_item_arrival
   WHERE  item_code = p_item_code
   and line_type = p_line_type
   AND arrival_type = 'D' AND arrival_status ='N'
          AND organization_id = p_org;
   RETURN NVL(lvf_departure_qty,0);
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;