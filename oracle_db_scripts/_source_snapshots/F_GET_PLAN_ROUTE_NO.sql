FUNCTION "F_GET_PLAN_ROUTE_NO" (p_item_code IN VARCHAR2, p_org IN NUMBER)
   RETURN VARCHAR2
IS
   lvs_route_no                  VARCHAR2(20);
BEGIN
   SELECT route_no
   INTO   lvs_route_no
   FROM   id_item
   WHERE  item_code = p_item_code AND organization_id = p_org;
   RETURN lvs_route_no;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;