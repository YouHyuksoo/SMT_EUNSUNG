FUNCTION "F_GET_TIME_STR" (p_time  IN NUMBER)
    RETURN VARCHAR2
IS
    lvs_time_set   VARCHAR2 (20);
BEGIN
  
    IF p_time = 0 THEN
       RETURN '';
    END IF;
    
    select TRIM(TO_CHAR(floor(p_time),'900'))||':'|| TRIM(TO_CHAR(floor(mod(p_time,1)*60),'00'))
       into lvs_time_set
       from dual ;
   
    RETURN lvs_time_set;
    
EXCEPTION
    WHEN otherS THEN
         RETURN '';
END;
