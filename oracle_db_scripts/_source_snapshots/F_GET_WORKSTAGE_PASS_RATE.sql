FUNCTION "F_GET_WORKSTAGE_PASS_RATE" (p_line_code        IN VARCHAR2,
                                                                       p_workstage_code   IN VARCHAR2,
                                                                       p_run_no           IN VARCHAR)
    RETURN NUMBER
IS
    lvf_rate     NUMBER;
    lvf_ng_qty   NUMBER;
    lvf_ok_qty   NUMBER;
BEGIN
    SELECT   SUM (DECODE (check_result, 'OK', 0, 1)) ng_qty, SUM (DECODE (check_result, 'OK', 1, 0)) ok_qty
      INTO   lvf_ng_qty, lvf_ok_qty
      FROM   iq_interlock_check_result
     WHERE   line_code = p_line_code AND workstage_code = p_workstage_code AND run_no = p_run_no;

    IF nvl(lvf_ng_qty,0) + nvl(lvf_ok_qty,0) = 0
    THEN
        RETURN 0;
    ELSE
        lvf_rate :=  TRUNC( lvf_ok_qty / (lvf_ng_qty + lvf_ok_qty) , 3) * 100 ;
    END IF;

    RETURN lvf_rate;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN 0;
END;