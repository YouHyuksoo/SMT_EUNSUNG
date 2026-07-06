FUNCTION "F_GET_LOT_NO_FIFO" 
  ( p_item_code IN varchar2,
    p_org IN number)
  RETURN  varchar2 IS

   ls_return   VARCHAR2(100);

BEGIN
    SELECT LISTAGG(X.LOT_NO,CHR(13)) WITHIN GROUP(ORDER BY X.LOT_NO)
    INTO   ls_return
    FROM
     (
        --？？？？？
        SELECT  A.CNT,
               A.LOT_NO
          FROM ( SELECT '1' CNT,
                       LOT_NO,
                       ROW_NUMBER() OVER (ORDER BY RECEIPT_COMPARE_DATE ASC) RANK
                  FROM IM_ITEM_RECEIPT_BARCODE
                 WHERE ITEM_CODE          = p_item_code
                   AND RECEIPT_COMPARE_DATE <  TRUNC(SYSDATE) + 1
                   AND RECEIPT_COMPARE_YN = 'Y'
                   AND ISSUE_COMPARE_YN   = 'N'
                   AND ORGANIZATION_ID    = p_org
                   AND RECEIPT_TYPE       = 'B' ) A
         WHERE A.RANK  < 4
        UNION ALL
        --？？？？？
        SELECT  B.CNT,
               B.LOT_NO
          FROM ( SELECT '2' CNT,
                       LOT_NO,
                       ROW_NUMBER() OVER (ORDER BY RECEIPT_COMPARE_DATE ASC) RANK
                  FROM IM_ITEM_RECEIPT_BARCODE
                 WHERE ITEM_CODE          = p_item_code
                   AND RECEIPT_COMPARE_DATE <  TRUNC(SYSDATE) + 1
                   AND RECEIPT_COMPARE_YN = 'Y'
                   AND ISSUE_COMPARE_YN   = 'N'
                   AND ORGANIZATION_ID    = p_org
                   AND RECEIPT_TYPE       = 'N'
                   AND LOT_DIVIDE_YN      = 'Y' ) B
         WHERE B.RANK  < 4
        UNION ALL
        --？？？？？
        SELECT  C.CNT,
               C.LOT_NO
          FROM ( SELECT '3' CNT,
                       LOT_NO,
                       ROW_NUMBER() OVER (ORDER BY RECEIPT_COMPARE_DATE ASC) RANK
                  FROM IM_ITEM_RECEIPT_BARCODE
                 WHERE ITEM_CODE          = p_item_code
                   AND RECEIPT_COMPARE_DATE <  TRUNC(SYSDATE) + 1
                   AND RECEIPT_COMPARE_YN = 'Y'
                   AND ISSUE_COMPARE_YN   = 'N'
                   AND ORGANIZATION_ID    = p_org
                   AND RECEIPT_TYPE       = 'N'
                   AND LOT_DIVIDE_YN      = 'N' ) C
         WHERE C.RANK  < 4

        ) X
    WHERE ROWNUM < 4
    ORDER BY X.CNT
    ;

    return ls_return;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
        RETURN '';
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;