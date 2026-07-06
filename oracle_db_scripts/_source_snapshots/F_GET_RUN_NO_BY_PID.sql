FUNCTION "F_GET_RUN_NO_BY_PID" (
    p_pid IN VARCHAR2)
  RETURN VARCHAR2
IS
  lvs_return VARCHAR2 (20);
BEGIN
  begin 
  SELECT   run_no
    INTO   lvs_return
    FROM   ip_product_2d_barcode
   WHERE   serial_no   = p_pid;
  exception 
    when no_data_found then 
      begin 
        SELECT run_no
          INTO lvs_return
          FROM ip_product_run_card_io
         WHERE MAGAZINE_LABEL_NO = p_pid;
      exception 
        when no_data_found then 
          lvs_return := '*' ; 
      end ;   
  end ;   
  
  RETURN lvs_return;
EXCEPTION
WHEN OTHERS
  THEN RETURN '?'||SQLERRM;
END;
