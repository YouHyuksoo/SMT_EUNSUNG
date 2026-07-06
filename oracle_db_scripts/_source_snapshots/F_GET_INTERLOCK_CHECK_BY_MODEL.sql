FUNCTION "F_GET_INTERLOCK_CHECK_BY_MODEL" ( p_line_code      IN VARCHAR2,
                                                                p_model_name     IN VARCHAR2,
                                                                p_date            IN DATE)
    RETURN NUMBER
IS
    lvl_return   NUMBER;
    lvd_date     Date;
BEGIN

    IF TO_CHAR (p_date, 'HH24MI') < '0820'
    THEN
        lvd_date := p_date - 1;
    ELSE
        lvd_date := p_date;
    END IF;

    BEGIN
        SELECT  NVL( COUNT(SERIAL_NO) , 0)
          INTO  lvl_return
          FROM  IQ_INTERLOCK_CHECK_RESULT
         WHERE  LINE_CODE = p_line_code
           AND  MODEL_NAME = p_model_name
           AND  CHECK_RESULT   <> 'NG'
           AND  IS_LAST_YN     = 'Y'
           AND  F_GET_WORKSTAGE_TYPE( WORKSTAGE_CODE )  =  'MAGAZINE' 
           AND  MAGAZINE_NO    IS NOT NULL
           AND  RECEIPT_DATE   >= TO_DATE (TO_CHAR (lvd_date, 'YYYYMMDD') || '0820', 'YYYYMMDDHH24MI');
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            lvl_return := 0;
    END;

    RETURN nvl(lvl_return , 0) ;

EXCEPTION
    WHEN OTHERS
    THEN
        RETURN 0;
END;