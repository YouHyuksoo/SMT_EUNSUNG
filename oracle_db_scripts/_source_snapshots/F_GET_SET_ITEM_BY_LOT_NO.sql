FUNCTION "F_GET_SET_ITEM_BY_LOT_NO" (p_lot_no IN VARCHAR2)
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (20);
-- Declare program variables as shown above
BEGIN
    SELECT   item_code
      INTO   lvs_return
      FROM   id_item
     WHERE       model_name = (SELECT   model_name
                                 FROM   isal_shipping_lot_master
                                WHERE   lot_no = p_lot_no)
             AND set_item_yn = 'Y'
             AND item_division = 'F';

    RETURN lvs_return;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN '*';
END;