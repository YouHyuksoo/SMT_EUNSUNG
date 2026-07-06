FUNCTION "F_GET_MSL_PASSED_TIME" (p_barcode IN VARCHAR2)
    RETURN NUMBER
IS
    lvs_return   number;
BEGIN

/*
    SELECT NVL(MSL_PASSED_TIME,0) + ((SYSDATE - NVL(FEEDING_DATE,SYSDATE)) * 24)
      INTO lvs_return
      FROM im_item_receipt_barcode
     WHERE item_barcode = p_barcode
        or lot_no       = p_barcode;
*/
       
    SELECT nvl(msl_passed_time,0) + nvl(((SYSDATE - NVL(MSL_OPEN_DATE,SYSDATE)) * 24),0) 
      INTO lvs_return
      FROM im_item_receipt_barcode
     WHERE item_barcode = p_barcode
        or lot_no       = p_barcode;        


    RETURN NVL(lvs_return,0);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
         RETURN NULL;
END;