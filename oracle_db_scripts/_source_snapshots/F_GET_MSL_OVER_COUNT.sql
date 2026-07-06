FUNCTION "F_GET_MSL_OVER_COUNT" (p_line_code IN VARCHAR2)
/* Formatted on 2015-04-24 ??? 11:18:26 (QP5 v5.126) */
    RETURN NUMBER
IS
    lvl_return   NUMBER;
BEGIN
    SELECT   COUNT ( * )
      INTO   lvl_return
      FROM   ib_product_plandata a, id_item b, im_item_receipt_barcode c
     WHERE   a.item_code = b.item_code
         AND a.item_code = c.item_code(+)
         AND a.lot_no = c.lot_no(+)
         AND TRUNC ( ( (SYSDATE - a.change_date) * 24 + NVL (c.msl_passed_time, 0)) / b.msl_max_time * 100, 2) >= 99.99
         AND a.active_yn = 'Y'
         AND b.msl_level IS NOT NULL
         AND NVL (b.msl_max_time, 0) <> 0
         AND a.line_code = p_line_code;

    RETURN lvl_return;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN -1;
END;