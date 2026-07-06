FUNCTION "F_GET_ASSEMBLY_TARGET_BY_LINE" (p_line_code      IN VARCHAR2,
/* Formatted on 2015-04-25 17:01:41 (QP5 v5.126) */
                                        p_model_name     IN VARCHAR2,
                                        p_model_suffix   IN VARCHAR2,
                                        p_pcb_item       IN VARCHAR2)
    RETURN NUMBER
IS
    lvl_st_value   NUMBER;
    lvl_time       NUMBER;
    lvl_return     NUMBER;
    LVS_START_TIME varchar2(10) ;
BEGIN


SELECT START_TIME INTO LVS_START_TIME 
   FROM ICOM_WORKTIME_RANGES 
  WHERE range_type = 'SMTWORKTIME'  AND work_type = 'A' ;
 

  IF LVS_START_TIME = '' OR LVS_START_TIME IS NULL THEN 
      LVS_START_TIME := '0830' ;
  END IF ;
  
  
  
    IF TO_CHAR (SYSDATE, 'HH24MI') < LVS_START_TIME
    THEN
        lvl_time :=
           ABS(( (SYSDATE - 1) - TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || LVS_START_TIME , 'YYYYMMDDHH24MI')) * 24 * 60 * 60);
    ELSE
        lvl_time := (SYSDATE - TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || LVS_START_TIME, 'YYYYMMDDHH24MI')) * 24 * 60 * 60;
    END IF;

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
