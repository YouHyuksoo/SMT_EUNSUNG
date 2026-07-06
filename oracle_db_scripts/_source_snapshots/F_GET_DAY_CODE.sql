FUNCTION "F_GET_DAY_CODE" (p_day IN varchar2)
   RETURN VARCHAR2
IS
   lvs_day   VARCHAR2 (1);
BEGIN
   SELECT DECODE (p_day,
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
                  '13', 'D',
                  '14', 'E',
                  '15', 'F',
                  '16', 'G',
                  '17', 'H',
                  '18', 'I',
                  '19', 'J',
                  '20', 'K',
                  '21', 'L',
                  '22', 'M',
                  '23', 'N',
                  '24', 'O',
                  '25', 'P',
                  '26', 'Q',
                  '27', 'R',
                  '28', 'S',
                  '29', 'T',
                  '30', 'U',
                  '31', 'V',
                   '*'
                 )
     INTO lvs_day
     FROM DUAL;

   RETURN lvs_day;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;