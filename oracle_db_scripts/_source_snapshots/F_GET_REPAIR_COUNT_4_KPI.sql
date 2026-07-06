FUNCTION "F_GET_REPAIR_COUNT_4_KPI" (
   p_line_code IN VARCHAR2)
   RETURN NUMBER
IS
   lvf_qty   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO lvf_qty
     FROM Ip_PRODUCT_WORK_QC
    WHERE line_code = p_line_code
          AND qc_date >=
                 CASE
                    WHEN TO_CHAR (SYSDATE, 'HH24MI') >= '0000'
                         AND TO_CHAR (SYSDATE, 'HH24MI') <= '0800'
                    THEN
                       TO_DATE (TO_CHAR (SYSDATE - 1, 'YYYYMMDD') || '0800',
                                'YYYYMMDDHH24MI')
                    ELSE
                       TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || '0800',
                                'YYYYMMDDHH24MI')
                 END;



   RETURN lvf_qty;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN 0;
END;