FUNCTION "F_GET_MAT_ISS_RTN_BY_M_MFS" (
   p_invoice_no   IN   VARCHAR2,
   p_item_code    IN   VARCHAR2,
   P_line_type    IN   VARCHAR2,
   p_org          IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_return_qty   NUMBER;
BEGIN
   SELECT SUM (issue_qty)
     INTO lvf_return_qty
     FROM im_item_issue
    WHERE invoice_no = p_invoice_no
      AND item_code = p_item_code
      AND line_type = P_line_type
      AND issue_deficit = 4
      AND issue_status <> 'C'
      AND organization_id = p_org;

   RETURN NVL (lvf_return_qty, 0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;