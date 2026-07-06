FUNCTION "F_GET_PLAN_ACTUAL_QTY_BY_MFS" (
   p_mfs         IN   VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_return                    NUMBER;
BEGIN

      SELECT   SUM(a.product_actual_qty)
      INTO     lvf_return
      FROM     ip_product_result a
      WHERE    a.mfs = p_mfs                                                   AND
               a.product_actual_status = 'N'                                   AND
               a.organization_id = p_org
      GROUP BY a.mfs,
               a.organization_id;

   RETURN lvf_return;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error(
         -20003, p_mfs || ' ' || SQLERRM
      );
END;