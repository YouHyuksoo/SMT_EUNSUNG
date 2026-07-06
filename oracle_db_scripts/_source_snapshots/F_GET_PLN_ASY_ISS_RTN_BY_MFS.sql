FUNCTION "F_GET_PLN_ASY_ISS_RTN_BY_MFS" (
   p_mfs            IN   VARCHAR2,
   p_item_code      IN   VARCHAR2,
   p_org            IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_return_qty                NUMBER;
BEGIN
   SELECT SUM(issue_qty)
   INTO   lvf_return_qty
   FROM   ip_assembly_issue
   WHERE      mfs = p_mfs
          AND item_code = p_item_code
          AND issue_deficit = 4
          AND issue_status <> 'C'
          AND organization_id = p_org;
   RETURN NVL(lvf_return_qty, 0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;