FUNCTION "F_GET_MACHINE_STOP_COUNT" (
   p_machine_code   IN   VARCHAR2,
   p_date           IN   DATE,
   p_org            IN   NUMBER
)
   RETURN NUMBER
IS
   lvl_count   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO lvl_count
     FROM imcn_machine_daily_operation
    WHERE machine_code = p_machine_code
      AND plan_date = p_date
      AND organization_id = p_org;

   RETURN lvl_count;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;