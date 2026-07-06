FUNCTION "F_CHECK_MASTER_SAMPLE" (P_PID  IN VARCHAR2) RETURN NUMBER
IS

    lvl_row_count  NUMBER;
    lvl_return     NUMBER;

BEGIN

--------------------------------------------------------------------------
-- 2016/08/29 SHS, PID？？ Master sample ？？？？ ？？？
--------------------------------------------------------------------------

    lvl_return := 0;

    BEGIN

       SELECT NVL(sum(1),0)
         INTO lvl_row_count
         FROM (
               SELECT MASTER_SAMPLE_PID1
                 FROM IP_PRODUCT_MODEL_MASTER
                WHERE MASTER_SAMPLE_PID1 = P_PID
                  AND ORGANIZATION_ID    = 1
                UNION ALL
               SELECT MASTER_SAMPLE_PID2
                 FROM IP_PRODUCT_MODEL_MASTER
                WHERE MASTER_SAMPLE_PID2 = P_PID
                  AND ORGANIZATION_ID    = 1
                UNION ALL
               SELECT MASTER_SAMPLE_PID3
                 FROM IP_PRODUCT_MODEL_MASTER
                WHERE MASTER_SAMPLE_PID3 = P_PID
                  AND ORGANIZATION_ID    = 1
               );

    EXCEPTION

       WHEN OTHERS THEN

            lvl_return := 0;
            RETURN lvl_return;

    END;

    IF lvl_row_count > 0 THEN
       lvl_return := 1;
    ELSE
       lvl_return := 0;
    END IF;

    RETURN lvl_return;


EXCEPTION

    WHEN OTHERS THEN
        lvl_return := 0;
        RETURN lvl_return;

END;