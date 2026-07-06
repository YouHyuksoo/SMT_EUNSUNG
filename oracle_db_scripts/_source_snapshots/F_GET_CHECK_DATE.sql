FUNCTION "F_GET_CHECK_DATE" (p_line_code       IN VARCHAR2,
/* Formatted on 31-12-2014 2:30:37 (QP5 v5.126) */
                                            p_machine         IN VARCHAR,
                                            p_lot_name        IN VARCHAR2,
                                            p_part_name       IN VARCHAR2,
                                            p_location_code   IN VARCHAR2)
    RETURN varchar2
IS
    lvdt_date   varchar2(20);
BEGIN
    SELECT   MIN (to_char(check_date,' yyyy-mm-dd hh24:mi:ss'))
      INTO   lvdt_date
      FROM   ib_smt_checkhist
     WHERE       line_code = p_line_code
             AND machine = p_machine
             AND lot_name = p_lot_name
             AND partname = p_part_name
             AND location_code = p_location_code
             and check_status = 'P';

    RETURN lvdt_date;
EXCEPTION
    WHEN OTHERS
    THEN
        NULL;
END;