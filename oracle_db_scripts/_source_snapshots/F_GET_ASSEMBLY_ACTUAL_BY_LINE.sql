FUNCTION "F_GET_ASSEMBLY_ACTUAL_BY_LINE" (p_line_code IN VARCHAR2, p_date IN DATE)
    RETURN NUMBER
IS
    lvl_return   NUMBER;
    LVS_START_TIME varchar2(10) ;
BEGIN



SELECT START_TIME INTO LVS_START_TIME 
   FROM ICOM_WORKTIME_RANGES 
  WHERE range_type = 'SMTWORKTIME'  AND work_type = 'A' ;
 

  IF LVS_START_TIME = '' OR LVS_START_TIME IS NULL THEN 
      LVS_START_TIME := '0830' ;
  END IF ;

    BEGIN
        SELECT  nvl( SUM (day_actual) , 0)
          INTO   lvl_return
          FROM   IP_ASSEMBLY_ACTUAL_DAY_V
         WHERE   line_code = p_line_code
         AND   receipt_date  = trunc(sysdate) ;
       --    AND   receipt_date  >= TO_DATE (TO_CHAR (p_date, 'YYYYMMDD') || LVS_START_TIME, 'YYYYMMDDHH24MI');
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            lvl_return := 0;
    END;

    RETURN nvl(lvl_return , 0) ;

EXCEPTION
    WHEN OTHERS
    THEN
        RETURN 0;
END;
