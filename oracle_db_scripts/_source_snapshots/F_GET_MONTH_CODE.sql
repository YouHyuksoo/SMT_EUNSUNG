FUNCTION "F_GET_MONTH_CODE" (
   p_model_name   IN VARCHAR2,
   p_yyyymm       IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvs_return   VARCHAR2 (1);
BEGIN
   SELECT DECODE (SUBSTR (p_yyyymm, 5, 2),
                  '01', m1,
                  '02', m2,
                  '03', m3,
                  '04', m4,
                  '05', m5,
                  '06', m6,
                  '07', m7,
                  '08', m8,
                  '09', m9,
                  '10', m10,
                  '11', m11,
                  '12', m12,
                  '*')
     INTO lvs_return
     FROM ip_product_year_base
    WHERE model_name = p_model_name AND yyyy = SUBSTR (p_yyyymm, 1, 4);

   RETURN lvs_return;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      SELECT DECODE (TO_CHAR (SYSDATE, 'MM'),
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
                     'Z')
        INTO lvs_return
        FROM DUAL;

      RETURN lvs_return;
END;