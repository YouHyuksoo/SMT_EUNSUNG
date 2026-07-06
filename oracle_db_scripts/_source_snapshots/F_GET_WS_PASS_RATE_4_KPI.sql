FUNCTION "F_GET_WS_PASS_RATE_4_KPI" (
   p_line_code        IN VARCHAR2,
   p_workstage_code   IN VARCHAR2,
   p_dateset in date )
   RETURN NUMBER
IS
   lvf_rate     NUMBER;
   lvf_ng_qty   NUMBER;
   lvf_ok_qty   NUMBER;
BEGIN
---------------------------------------------------------------
--
---------------------------------------------------------------

   SELECT SUM (DECODE (check_result, 'NG', 1, 0)) ng_qty,
          SUM (DECODE (check_result, 'NG', 0, 1)) ok_qty
     INTO lvf_ng_qty, lvf_ok_qty
     FROM iq_interlock_check_result
    WHERE line_code = p_line_code AND F_GET_WORKSTAGE_TYPE ( workstage_code ) in ( 'SPI' , 'AOI' , 'REFLOW' , 'ICT') -- p_workstage_code
          AND receipt_date >=
                 CASE
                    WHEN TO_CHAR (p_dateset, 'HH24MI') >= '0000'
                         AND TO_CHAR (p_dateset, 'HH24MI') <= '0800'
                    THEN
                       TO_DATE (TO_CHAR (p_dateset - 1, 'YYYYMMDD') || '0800',
                                'YYYYMMDDHH24MI')
                    ELSE
                       TO_DATE (TO_CHAR (p_dateset, 'YYYYMMDD') || '0800',
                                'YYYYMMDDHH24MI')
                 END;

---------------------------------------------------------------
--
---------------------------------------------------------------

   IF NVL (lvf_ng_qty, 0) + NVL (lvf_ok_qty, 0) = 0
   THEN
      RETURN 0;
   ELSE
      lvf_rate := TRUNC (lvf_ok_qty / (lvf_ng_qty + lvf_ok_qty), 3) * 100;
   END IF;

   RETURN lvf_rate;

---------------------------------------------------------------
--
---------------------------------------------------------------

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN 0;
END;