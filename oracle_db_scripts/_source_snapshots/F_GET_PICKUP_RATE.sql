FUNCTION "F_GET_PICKUP_RATE" (p_line_code IN VARCHAR2)
/* Formatted on 2015-05-19 ??? 4:49:13 (QP5 v5.126) */
    RETURN NUMBER
IS
    lvf_return   NUMBER;
BEGIN
    SELECT   sum(place) / sum(pickup)
      INTO   lvf_return
      FROM   iq_machine_inspect_pickup
     WHERE   line_code = p_line_code
       AND    pickup > 0 ;

    RETURN lvf_return;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN 0;
END;