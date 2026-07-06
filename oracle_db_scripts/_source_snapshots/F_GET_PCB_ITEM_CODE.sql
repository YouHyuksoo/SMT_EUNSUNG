FUNCTION "F_GET_PCB_ITEM_CODE" (
                                                  P_TYPE        IN VARCHAR2, -- M:model, R:Run Card
                                                  P_ITEM       IN VARCHAR2
                                                  ) RETURN VARCHAR2
IS

    lvs_item                VARCHAR2(50);

BEGIN

--------------------------------------------------------------------------
-- 2016/08/29 SHS, PID？？ Master sample ？？？ ？？？
--------------------------------------------------------------------------

    lvs_item := '';

    -- Model master item ？？
    IF    P_TYPE = 'M' THEN

          BEGIN

            SELECT NVL(PCB_ITEM_CODE,'')
              INTO lvs_item
              FROM IP_PRODUCT_MODEL_MASTER
             WHERE ITEM_CODE       = P_ITEM
               AND ORGANIZATION_ID = 1
               AND ROWNUM          = 1;

          EXCEPTION

             WHEN OTHERS THEN
                  lvs_item := '';
                  RETURN lvs_item;

         END;

    -- Run card ？？
    ELSIF P_TYPE = 'R' THEN

          BEGIN

             SELECT NVL(M.PCB_ITEM_CODE,'')
               INTO lvs_item
               FROM IP_PRODUCT_RUN_CARD     R,
                    IP_PRODUCT_MODEL_MASTER M
              WHERE R.PARENT_ITEM_CODE = M.ITEM_CODE
                AND R.ORGANIZATION_ID  = M.ORGANIZATION_ID
                AND R.RUN_NO           = P_ITEM
                AND ROWNUM             = 1;

          EXCEPTION

             WHEN OTHERS THEN
                  lvs_item := '';
                  RETURN lvs_item;

         END;

    END IF;

    RETURN lvs_item;

EXCEPTION

    WHEN OTHERS THEN
        lvs_item := '';
        RETURN lvs_item;

END;