FUNCTION "F_GET_SPI_PASS_RATE_BY_RUNNO" (
   p_run_no       IN VARCHAR2 )
   RETURN NUMBER
IS
   lvf_rate     NUMBER;
   lvf_ng_qty   NUMBER;
   lvf_ok_qty   NUMBER;
BEGIN
---------------------------------------------------------------
-- SPI Result 기준 OK, NG count : serial 중복 허용
---------------------------------------------------------------
    
   SELECT SUM (DECODE (NVL(RESULT, '*'), 'OK', 0, 'GOOD', 0, 'Good', 0, 1)) ng_qty,
          SUM (DECODE (NVL(RESULT, '*'), 'OK', 1, 'GOOD', 1, 'Good', 1, 0)) ok_qty
     INTO lvf_ng_qty, lvf_ok_qty
     FROM IQ_MACHINE_INSPECT_DATA_SPI
    WHERE RUN_NO = P_RUN_NO;
          
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
