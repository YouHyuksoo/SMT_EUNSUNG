FUNCTION "F_GET_INVENOTRY_TIME_QTY" (p_org       number,
                                                    p_item_code varchar2,
                                                    p_lot_no    varchar2,
                                                    p_line_type varchar2,
                                                    p_date      date)
   RETURN NUMBER
IS
   lvf_receipt_qty   NUMBER ;
   lvf_issue_qty     NUMBER ;
   lvf_return_qty    NUMBER ;
   /**********************************************************************
    * ？？？ ？ð？？？？？？？ ？？？？？？？？？？, ？？？ ？？？？？？？？？？？？ ？？？？？ RETURN ？
    * ？？？？？？？？TRUNC ？？？？？？ ？？？？？？？？ENTER_DATE ？？？？？？？？？ ？？？
    **********************************************************************/
BEGIN

  BEGIN
   SELECT nvl(SUM (receipt_qty),0)
     INTO lvf_receipt_qty
     FROM im_item_receipt
    WHERE item_code  = p_item_code
      AND material_mfs = p_lot_no
      AND line_type  = p_line_type
      AND enter_date > p_date
      AND organization_id = p_org;

     RETURN NVL (lvf_receipt_qty, 0);
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
        lvf_receipt_qty := 0 ;
  END;

  BEGIN

    SELECT nvl(SUM (issue_qty),0)
      INTO lvf_issue_qty
      FROM im_item_issue
     WHERE item_code  = p_item_code
       AND material_mfs = p_lot_no
       AND line_type  = p_line_type
       AND enter_date > p_date
       AND organization_id = p_org  ;

     RETURN NVL (lvf_receipt_qty, 0);
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
        lvf_issue_qty := 0 ;
  END;

  lvf_return_qty := (-1 * lvf_issue_qty) - lvf_receipt_qty ;

  return lvf_return_qty ;
EXCEPTION
  WHEN OTHERS THEN
    return 0 ;

end F_GET_INVENOTRY_TIME_QTY;