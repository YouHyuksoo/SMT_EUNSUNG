FUNCTION "F_GET_MAT_WS_ISS_WGT_SUB_MFS" (
   p_workstage_code     IN   VARCHAR2,
   p_mfs                IN   VARCHAR2,
   p_receipt_date       IN   DATE,
   p_receipt_sequence   IN   NUMBER,
   p_item_code          IN   VARCHAR2,
   p_org                IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_issue_qty                 NUMBER;
BEGIN
   SELECT SUM(NVL(issue_weight, 0))
   INTO   lvf_issue_qty
   FROM   im_item_workstage_issue
   WHERE
   workstage_code = p_workstage_code     AND
          mfs = p_mfs                           AND
--          product_date = p_receipt_date         AND
--          product_sequence = p_receipt_sequence AND
          item_code = p_item_code               AND
          organization_id = p_org;
   RETURN lvf_issue_qty;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;