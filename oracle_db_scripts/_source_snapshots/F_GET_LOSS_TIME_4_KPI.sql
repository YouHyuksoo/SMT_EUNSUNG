FUNCTION "F_GET_LOSS_TIME_4_KPI" (
   P_LINE_CODE IN VARCHAR2)
   RETURN NUMBER
IS
   LVF_TIME   NUMBER;
BEGIN
   SELECT SUM(( DECODE( END_TIME , NULL , SYSDATE , END_TIME  ) - START_TIME ) * 24 * 60  )
     INTO LVF_TIME
     FROM IP_LINE_DAILY_OPERATION
    WHERE LINE_CODE = P_LINE_CODE
          AND START_TIME >=
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


                 RETURN NVL(LVF_TIME,0) ;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      RAISE_APPLICATION_ERROR (-20003, SQLERRM);
END;