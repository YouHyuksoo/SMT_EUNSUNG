FUNCTION "F_GET_ASSEMBLY_TARGET_BY_CCS" (p_line_code      IN VARCHAR2,
                                        p_model_name     IN VARCHAR2,
                                        p_model_suffix   IN VARCHAR2,
                                        p_pcb_item       IN VARCHAR2,
                                        p_ccs_date       IN DATE)
    RETURN NUMBER
IS
    lvl_st_value   NUMBER;
    lvl_time       NUMBER;
    lvl_return     NUMBER;
BEGIN
  
    lvl_time := (SYSDATE - p_ccs_date) * 24 * 60 * 60;

        SELECT   MAX(assy_st)
          INTO   lvl_st_value
          FROM   ip_product_model_st_master
         WHERE   line_code = p_line_code
             AND model_name = p_model_name AND pcb_item = p_pcb_item;

    lvl_return := lvl_time / lvl_st_value;

    RETURN lvl_return;


EXCEPTION
    WHEN OTHERS
    THEN
        RETURN 0;
END;