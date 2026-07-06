FUNCTION "F_GET_LQC_INSPECT_HANDLING" (
   p_lqc_inspect_no   IN   VARCHAR2,
   p_org              IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvs_lqc_inspect_handling   VARCHAR2 (1);
BEGIN
   SELECT NVL (lqc_inspect_handling, 'N')
     INTO lvs_lqc_inspect_handling
     FROM iq_product_lqc_bad
    WHERE lqc_inspect_no = p_lqc_inspect_no
      AND lqc_inspect_handling = 'D'
      AND organization_id = p_org
      AND ROWNUM = 1;
   RETURN lvs_lqc_inspect_handling;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 'N';
   WHEN OTHERS
   THEN
      raise_application_error (-20003,    p_lqc_inspect_no
                                       || ' '
                                       || SQLERRM);
END;