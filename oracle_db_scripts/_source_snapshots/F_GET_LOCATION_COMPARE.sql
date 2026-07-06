FUNCTION "F_GET_LOCATION_COMPARE" (p_data1 IN VARCHAR2,
                                                p_data2 IN VARCHAR2)
   RETURN VARCHAR2
IS

   lvs_return VARCHAR2(10);

   lvl_cnt1   NUMBER;
   lvl_cnt2   NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO lvl_cnt1
      FROM
     (
        SELECT REGEXP_SUBSTR(STR, '[^,]+', 1, LEVEL) AS DATA
          FROM (
                  SELECT p_data1 STR
                    FROM DUAL
               )
        CONNECT BY LEVEL <= LENGTH(REGEXP_REPLACE(STR, '[^,]+')) + 1
        MINUS
        SELECT REGEXP_SUBSTR(STR, '[^,]+', 1, LEVEL) AS DATA
          FROM (
                  SELECT p_data2 STR
                    FROM DUAL
               )
        CONNECT BY LEVEL <= LENGTH(REGEXP_REPLACE(STR, '[^,]+')) + 1
    );

   SELECT COUNT(*)
     INTO lvl_cnt2
     FROM
     (
        SELECT REGEXP_SUBSTR(STR, '[^,]+', 1, LEVEL) AS DATA
          FROM (
                  SELECT p_data2 STR
                    FROM DUAL
               )
        CONNECT BY LEVEL <= LENGTH(REGEXP_REPLACE(STR, '[^,]+')) + 1
        MINUS
        SELECT REGEXP_SUBSTR(STR, '[^,]+', 1, LEVEL) AS DATA
          FROM (
                  SELECT p_data1 STR
                    FROM DUAL
               )
        CONNECT BY LEVEL <= LENGTH(REGEXP_REPLACE(STR, '[^,]+')) + 1
    );

   IF lvl_cnt1 = 0 AND  lvl_cnt2 = 0
   THEN
      lvs_return := 'OK';
   ELSE
      lvs_return := 'NG';
   END IF;

   RETURN lvs_return ;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN 'NOTFOUND';
   WHEN OTHERS THEN
      raise_application_error (-20003, SQLERRM);
END;