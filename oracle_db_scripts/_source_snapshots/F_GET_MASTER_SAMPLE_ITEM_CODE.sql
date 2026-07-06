FUNCTION "F_GET_MASTER_SAMPLE_ITEM_CODE" (
                                                           P_PID      IN VARCHAR2
                                                         ) RETURN VARCHAR2
IS

    lvs_item                VARCHAR2(50);

BEGIN

--------------------------------------------------------------------------
-- 2016/08/29 SHS, PID？？ Master sample ？？？？ ？？？
--------------------------------------------------------------------------

    lvs_item := '';


    -- Master sample PID ？？？？
    BEGIN

       SELECT NVL(ITEM_CODE,'')
         INTO lvs_item
         FROM (
               SELECT ITEM_CODE
                 FROM IP_PRODUCT_MODEL_MASTER
                WHERE MASTER_SAMPLE_PID1 = P_PID
                  AND ORGANIZATION_ID    =  1
                  AND DATEEND            >= trunc(sysdate)
                UNION ALL
               SELECT ITEM_CODE
                 FROM IP_PRODUCT_MODEL_MASTER
                WHERE MASTER_SAMPLE_PID2 = P_PID
                  AND ORGANIZATION_ID    =  1
                  AND DATEEND            >= trunc(sysdate)
                UNION ALL
               SELECT ITEM_CODE
                 FROM IP_PRODUCT_MODEL_MASTER
                WHERE MASTER_SAMPLE_PID3 = P_PID
                  AND ORGANIZATION_ID    =  1
                  AND DATEEND            >= trunc(sysdate)
              )
        WHERE ROWNUM = 1;

    EXCEPTION

        WHEN OTHERS THEN
             lvs_item := '';
             RETURN lvs_item;

    END;


    RETURN lvs_item;

EXCEPTION

    WHEN OTHERS THEN
        lvs_item := '';
        RETURN lvs_item;

END;