FUNCTION                    "F_GET_LINE_MACHINE_NAME" (p_line_code IN VARCHAR2 , p_org IN number)
-- "F_GET_LINE_NAME" (p_line_code IN VARCHAR2, p_org IN number)
   RETURN VARCHAR2
IS
   lvs_return   VARCHAR2 (100);
BEGIN

    lvs_return := p_line_code;

    ----------------------------------------------------------
    -- ¿¿ ¿¿
    ----------------------------------------------------------
    BEGIN

       SELECT line_name
         INTO lvs_return
         FROM ip_product_line
        WHERE line_code = p_line_code
          AND ORGANIZATION_ID =  p_org ;

       IF ( NVL( lvs_return, '*') <> '*' ) THEN   
            RETURN lvs_return;
       END IF;

    EXCEPTION
       WHEN OTHERS THEN
          lvs_return := p_line_code;
    END;

    ----------------------------------------------------------
    -- ¿¿ ¿¿
    ----------------------------------------------------------    
    BEGIN

       SELECT machine_name
         INTO lvs_return
         FROM imcn_machine
        WHERE machine_code = p_line_code
          AND ORGANIZATION_ID =  p_org ;

       IF ( NVL( lvs_return, '*') <> '*' ) THEN   
            RETURN lvs_return;
       END IF;          

    EXCEPTION
       WHEN OTHERS THEN
          lvs_return := p_line_code;
    END;            

    RETURN lvs_return;

EXCEPTION
   WHEN OTHERS THEN
        RETURN lvs_return ;
END;


