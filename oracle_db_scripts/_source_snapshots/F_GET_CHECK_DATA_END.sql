FUNCTION "F_GET_CHECK_DATA_END" (
   p_line_code       IN VARCHAR2,
   p_lot_name        IN VARCHAR2,
   p_partname        IN VARCHAR2,
   p_location_code   IN VARCHAR2,
   p_lot_no          IN VARCHAR2,
   p_check_date      IN DATE)
   RETURN DATE
IS
   lvdt_end_date   DATE;
BEGIN
   ---------------------------------------------------
   --     AND lot_name = p_lot_name
   --     AND partname = p_partname
   ---------------------------------------------------

   SELECT MIN (check_date)
     INTO lvdt_end_date
     FROM ib_smt_checkhist
    WHERE  check_date > p_check_date
          AND location_code = p_location_code
          AND line_code = p_line_code
          AND check_type IN (1, 2)
          AND check_status = 'P';

   ---------------------------------------------------
   --
   ---------------------------------------------------
   RETURN  NVL(lvdt_end_date ,SYSDATE ) ;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      lvdt_end_date := NULL;
END;