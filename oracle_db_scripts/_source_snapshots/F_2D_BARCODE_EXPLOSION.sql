FUNCTION "F_2D_BARCODE_EXPLOSION" (p_item_barcode IN VARCHAR2, p_org IN NUMBER)
/* Formatted on 2015-06-18 18:16:47 (QP5 v5.126) */
    RETURN VARCHAR2
IS

LVS_RETURN VARCHAR2(50) ;
BEGIN
        SELECT   REGEXP_SUBSTR (item_barcode,
                                '[^' || CHR (29) || ']+',
                                1,
                                LEVEL)
                     txt
                     into LVS_RETURN
          FROM   im_item_request
         WHERE   item_barcode = p_item_barcode
    CONNECT BY   LEVEL <= LENGTH (REGEXP_REPLACE (item_barcode, '[^' || CHR (29) || ']+', '')) + 1;

    RETURN LVS_RETURN;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN NULL;
END;