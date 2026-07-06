FUNCTION "F_GET_DEPT_NAME" 
  ( p_dept_code IN varchar2,p_language IN varchar2 , p_org In number )
  RETURN  varchar2 IS
--
-- To modify this template, edit file FUNC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the function
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  -------------------------------------------

lvs_dept_name varchar2(30);

BEGIN

    SELECT DECODE(p_language , 'C' , department_name_local,'K' , department_name_kor , 'E' , department_name_eng )
      INTO lvs_dept_name
      FROM ISYS_DEPARTMENT
     WHERE DEPARTMENT_CODE = p_dept_code
       AND ORGANIZATION_ID = p_org ;

    RETURN lvs_dept_name ;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
       return p_dept_code ;
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;