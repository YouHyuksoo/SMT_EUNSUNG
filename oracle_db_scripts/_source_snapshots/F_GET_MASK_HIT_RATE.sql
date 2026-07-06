FUNCTION "F_GET_MASK_HIT_RATE" (p_lot_no IN VARCHAR2)
/* Formatted on 2015-04-24 15:10:56 (QP5 v5.126) */
    RETURN NUMBER
IS
    lvl_return   NUMBER;
BEGIN
    SELECT   hit_value / break_value
      INTO   lvl_return
      FROM   imcn_jig
     WHERE   jig_lot_no = p_lot_no;

    RETURN lvl_return;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN 0;
END;