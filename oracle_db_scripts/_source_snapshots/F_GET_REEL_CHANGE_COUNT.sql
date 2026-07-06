FUNCTION F_GET_REEL_CHANGE_COUNT (
                                                    p_line        IN VARCHAR2,
                                                    p_yyyymmdd    IN VARCHAR2
                                                   )
    RETURN NUMBER
IS
    lvl_return          NUMBER;
BEGIN
  
    select count(*)
      into lvl_return
      from ib_smt_checkhist
     where check_date >= to_date( substr(p_yyyymmdd, 1, 10) || ' 08:30:00', 'YYYY/MM/DD HH24:MI:SS')
       and check_date <  to_date( substr(p_yyyymmdd, 1, 10) || ' 08:30:00', 'YYYY/MM/DD HH24:MI:SS') +1
       and line_code    = substr(p_line, 1, 2)
       and check_status = 'P'
       and check_type   = '2';

    RETURN lvl_return;
    
EXCEPTION
    WHEN OTHERS THEN
         RETURN NULL;
END;
