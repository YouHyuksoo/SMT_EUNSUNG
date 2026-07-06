FUNCTION "F_GET_MONTH_CODE2" (    p_yyyymm       IN VARCHAR2)
   RETURN VARCHAR2
IS
    lvs_month   VARCHAR2 (1);
BEGIN
   SELECT DECODE (p_yyyymm,
                  '01', '1',
                  '02', '2',
                  '03', '3',
                  '04', '4',
                  '05', '5',
                  '06', '6',
                  '07', '7',
                  '08', '8',
                  '09', '9',
                  '10', 'A',
                  '11', 'B',
                  '12', 'C',
                   '*'
                 )
     INTO lvs_month
     FROM DUAL;

   RETURN lvs_month;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;