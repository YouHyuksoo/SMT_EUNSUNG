FUNCTION "F_GET_WORKSTAGE_CODE_4_LINE" (
                                                   P_LINE_CODE IN VARCHAR2,
                                                   P_IO_TYPE   IN VARCHAR2
                                                  )
   RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (10);
BEGIN
  
     select workstage_code
       into lvs_return
       from ip_product_routing
      where route_no = P_LINE_CODE
        and ( io_type = P_IO_TYPE OR io_type = 'B')
        and rownum = 1 ; 

    RETURN lvs_return;
    
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN '*';
END;
