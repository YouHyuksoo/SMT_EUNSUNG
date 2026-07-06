FUNCTION "F_GET_ITEM_FROM_BOM_LOCATION" (
                                                          P_MODEL_NAME  IN VARCHAR2,
                                                          P_QC_LOCATION IN VARCHAR2
                                                         )
   RETURN VARCHAR2
IS
   LVS_RETURN   VARCHAR2 (100);
BEGIN

  SELECT WM_CONCAT(ITEM_CODE) -- ？？？ LOCATION？？ ？？ 1 LEVEL BOM？？ITEM LAIST ？？
    INTO LVS_RETURN
    FROM (
          SELECT DISTINCT  (
                            SELECT CHILD_ITEM_CODE
                              FROM ID_ENG_BOM_SMT
                             WHERE PARENT_ITEM_CODE = Q.MODEL_NAME
                               AND ( REGEXP_COUNT(LOCATION_INFO, Q.LOCATION_CODE||'[ ,]') > 0   OR
                                     REGEXP_COUNT(LOCATION_INFO, Q.LOCATION_CODE||'$')    > 0 )
                               AND ROWNUM = 1
                          ) ITEM_CODE
           FROM (
                 SELECT DISTINCT P_MODEL_NAME  MODEL_NAME , UPPER(TRIM(REGEXP_SUBSTR(D.TXT, '[^,^ ]+', 1, LEVEL))) LOCATION_CODE
                   FROM (
                         SELECT P_QC_LOCATION  TXT   -- 1 LEVEL BOM？？？？ ？？？ ？？？ LOCATION ？？？？ ？？？？？ ？？
                           FROM DUAL
                        ) D
                CONNECT BY LEVEL <= LENGTH(REGEXP_REPLACE(D.TXT, '[^,^ ]+',''))+1
                ) Q
          WHERE Q.LOCATION_CODE IS NOT NULL
      );

     RETURN  LVS_RETURN;

EXCEPTION
   WHEN OTHERS THEN
        RETURN '';

END;