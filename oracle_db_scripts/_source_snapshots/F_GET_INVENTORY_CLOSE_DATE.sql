FUNCTION "F_GET_INVENTORY_CLOSE_DATE" (
   p_close_yyyymm    IN VARCHAR2,
   p_start_end_div   IN VARCHAR2,
   p_org             IN NUMBER)
   RETURN DATE
IS
   lvdt_close_start_date   DATE;
   lvdt_close_end_date     DATE;
   lvdt_close_last_date    DATE;
BEGIN
   -------------------------------------------------------
   --
   -----------------------------------------------------

   SELECT start_date, end_date, last_close_date
     INTO lvdt_close_start_date, lvdt_close_end_date, lvdt_close_last_date
     FROM isys_inventory_close_date
    WHERE close_yyyymm = p_close_yyyymm AND organization_id = p_org;

   IF p_start_end_div = 'START'
   THEN
      RETURN lvdt_close_start_date;
   ELSIF p_start_end_div = 'END'
   THEN
      RETURN lvdt_close_end_date;
   ELSE
      IF lvdt_close_last_date IS NULL
      THEN
         RETURN TO_DATE (
                   TO_CHAR (lvdt_close_end_date, 'yyyymmdd') || '235959',
                   'yyyymmdd hh24:mi:ss');
      ELSE
         RETURN lvdt_close_last_date;
      END IF;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      IF p_start_end_div = 'START'
      THEN
         RETURN TO_DATE (p_close_yyyymm || '01', 'YYYYMMDD');
      ELSIF p_start_end_div = 'END'
      THEN
         RETURN ADD_MONTHS (TO_DATE (p_close_yyyymm || '01235959', 'YYYYMMDDhh24miss'), 1)
                - 1;
      ELSIF p_start_end_div = 'LAST'
      THEN
         RETURN ADD_MONTHS (TO_DATE (p_close_yyyymm || '01235959', 'YYYYMMDDhh24miss'), 1)
                - 1;
      END IF;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;