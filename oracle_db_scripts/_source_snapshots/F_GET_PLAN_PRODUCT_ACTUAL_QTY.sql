FUNCTION "F_GET_PLAN_PRODUCT_ACTUAL_QTY" (
   p_yyyymm      IN   VARCHAR2,
   p_item_code   IN   VARCHAR2,
   p_mfs         IN   VARCHAR2,
   p_type        IN   VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_return                    NUMBER;
BEGIN
   IF p_type = 'ITEM'
   THEN
      SELECT   SUM(a.product_actual_qty)
      INTO     lvf_return
      FROM     ip_product_result a
      WHERE    a.item_code = p_item_code                                       AND
               a.product_date >= TO_DATE(p_yyyymm || '01', 'yyyymmdd')         AND
               a.product_date <
                            ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'yyyymmdd'),
                                                                            1) AND
               a.product_actual_status = 'N'                                   AND
               a.organization_id = p_org
      GROUP BY a.item_code,
               a.organization_id;
   ELSE
      SELECT   SUM(a.product_actual_qty)
      INTO     lvf_return
      FROM     ip_product_result a
      WHERE    a.item_code = p_item_code                                       AND
               a.mfs = p_mfs                                                   AND
               a.product_date >= TO_DATE(p_yyyymm || '01', 'yyyymmdd')         AND
               a.product_date <
                            ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'yyyymmdd'),
                                                                            1) AND
               a.product_actual_status = 'N'                                   AND
               a.organization_id = p_org
      GROUP BY a.item_code,
               a.mfs,
               a.organization_id;
   END IF;

   RETURN lvf_return;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error(
         -20003, p_yyyymm || ' ' || p_item_code || ' ' || SQLERRM
      );
END;