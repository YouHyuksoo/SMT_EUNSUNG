FUNCTION "F_GET_INSPECT_SAMPLE_QTY" (
   p_arrival_qty   IN   NUMBER,
   p_org           IN   NUMBER
)
   RETURN NUMBER
IS
   lvl_sample_qty                NUMBER;
BEGIN
   SELECT NVL(inspect_sample_qty, 0)
   INTO   lvl_sample_qty
   FROM   iq_item_iqc_range
   WHERE  inspect_minimum <= p_arrival_qty AND
          inspect_maxmum >= p_arrival_qty  AND
          organization_id = p_org;

   IF lvl_sample_qty = 0
   THEN
      RETURN p_arrival_qty;
   ELSE
      RETURN lvl_sample_qty;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN p_arrival_qty;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;