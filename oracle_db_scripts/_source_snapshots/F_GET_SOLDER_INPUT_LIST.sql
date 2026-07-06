FUNCTION "F_GET_SOLDER_INPUT_LIST" (
                                                          p_solder_lot       IN VARCHAR2
                                                    )
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2(100);
BEGIN
   
    select regexp_replace(listagg(f_get_line_name(line_code, 1), ',') within group ( order by line_code), '([^,]+)(,\1)*(,|$)', '\1\3')
      into lvs_return
      from IM_ITEM_SOLDER_INPUT_HIST
     where solder_lot_no = p_solder_lot;

    RETURN lvs_return;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
         RETURN '';
    WHEN OTHERS THEN
         RETURN '';
        -- raise_application_error (-20003, p_mfs || '  ' || SQLERRM);
END;
