FUNCTION "F_GET_INTERLOCK_PASS_COUNT" (
   P_LINE_CODE        IN VARCHAR2,
   P_WORKSTAGE_CODE   IN VARCHAR2)
   RETURN NUMBER
IS
   LVL_RETURN   NUMBER;
BEGIN
   SELECT COUNT (DISTINCT SERIAL_NO)
     INTO LVL_RETURN
     FROM IQ_INTERLOCK_CHECK_RESULT
    WHERE LINE_CODE = P_LINE_CODE AND WORKSTAGE_CODE = P_WORKSTAGE_CODE
          AND RECEIPT_DATE >=
                 CASE
                    WHEN TO_CHAR (SYSDATE, 'HH24MI') >= '0000'
                         AND TO_CHAR (SYSDATE, 'HH24MI') <= '0800'
                    THEN
                       TO_DATE (TO_CHAR (SYSDATE - 1, 'YYYYMMDD') || '0800',
                                'YYYYMMDDHH24MI')
                    ELSE
                       TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || '0800',
                                'YYYYMMDDHH24MI')
                 END
          AND CHECK_RESULT <> 'NG';


   RETURN LVL_RETURN;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      RETURN 0;
END;