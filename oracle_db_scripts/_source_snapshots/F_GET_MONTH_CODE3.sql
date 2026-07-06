FUNCTION "F_GET_MONTH_CODE3" (    p_date       IN DATE)
   RETURN VARCHAR2
IS
    lvs_month   VARCHAR2 (3);
BEGIN
   SELECT DECODE ( TO_CHAR(p_date,'MM') ,
                  '01', '1',
                  '02', '2',
                  '03', '3',
                  '04', '4',
                  '05', '5',
                  '06', '6',
                  '07', '7',
                  '08', '8',
                  '09', '9',
                  '10', '0',
                  '11', 'A',
                  '12', 'B',
                   '*'
                 )
           ||TO_CHAR(p_date , 'DD')      
     INTO lvs_month
     FROM DUAL;

   RETURN lvs_month;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;