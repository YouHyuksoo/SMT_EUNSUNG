FUNCTION "F_GET_ASSY_ISSUE_BY_DATE" (
   p_item_code       IN   VARCHAR2,
   p_line_type       IN   VARCHAR2,
   p_location_code   IN   VARCHAR2,
   p_date            IN   DATE,
   p_org             IN   NUMBER
)
   RETURN NUMBER
IS
-----------------------------------------------------------
   lvdt_issue_qty   NUMBER;
BEGIN
   SELECT SUM (issue_qty)
     INTO lvdt_issue_qty
     FROM ip_assembly_issue
    WHERE item_code = p_item_code
      AND product_line_type = p_line_type
      AND issue_date = p_date
      AND issue_status = 'N'
      AND NVL(location_code,0) = p_location_code
      AND organization_id = p_org;

   RETURN NVL (lvdt_issue_qty, 0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN NULL;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;