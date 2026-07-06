FUNCTION F_GET_PID_REEL_MAT (
   p_pid         IN   VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvl_cnt                       NUMBER;
BEGIN
     
   select count(*)
     into lvl_cnt  
     from ib_smt_checkhist c,
          im_item_receipt_barcode b,
          id_item i 
    where c.scan_partname = b.item_barcode
      and c.item_code     = i.item_code
      and c.run_no        = (
                              select run_no   
                                from ip_product_2d_barcode  
                               where SERIAL_NO like p_pid
                                 AND ORGANIZATION_ID = p_org
                                 AND ROWNUM = 1
                            );
                         
                  
   RETURN lvl_cnt;
      
EXCEPTION
   WHEN OTHERS THEN
        return 0;
END;
