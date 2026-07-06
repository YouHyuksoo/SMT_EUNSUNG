FUNCTION "F_GET_BRING_IN_QTY" (
   p_date       IN   DATE,
   p_sequence   IN   NUMBER,
   p_org        IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_return                    NUMBER;
BEGIN
   SELECT SUM(bring_in_qty)
   INTO   lvf_return
   FROM   iman_bring_in
   WHERE      carrying_out_date = p_date
          AND carrying_out_seq = p_sequence
          AND organization_id = p_org;
   RETURN NVL(lvf_return, 0 );
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;