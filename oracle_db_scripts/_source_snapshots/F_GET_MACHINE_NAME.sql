FUNCTION "F_GET_MACHINE_NAME" (p_machine_code IN VARCHAR2)
/* Formatted on 2015-07-07 10:59:40 (QP5 v5.126) */
    RETURN VARCHAR2
IS
    --
    -- To modify this template, edit file FUNC.TXT in TEMPLATE
    -- directory of SQL Navigator
    --
    -- Purpose: Briefly explain the functionality of the function
    --
    -- MODIFICATION HISTORY
    -- Person      Date    Comments
    -- ---------   ------  -------------------------------------------
    lvs_return   VARCHAR2 (100);
-- Declare program variables as shown above
BEGIN
    SELECT   machine_name
      INTO   lvs_return
      FROM   imcn_machine
     WHERE   machine_code = p_machine_code;

    RETURN lvs_return;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN '*';
END;