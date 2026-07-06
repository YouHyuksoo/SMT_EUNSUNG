FUNCTION "F_GET_REPAIR_RUN_NO" (p_smt_date     IN DATE,
/* Formatted on 2012-12-08 12:59:28 (QP5 v5.126) */
                           p_model_name   IN VARCHAR2,
                           p_line_code    IN VARCHAR2,
                           p_org          IN NUMBER)
    RETURN VARCHAR2
IS
    lvs_return     VARCHAR2 (20);
    lvl_sequence   NUMBER;
    pahse          VARCHAR2 (10);
    lvs_yyyy       VARCHAR2 (4);
BEGIN
pahse := '10' ;
    lvs_return := f_get_company_code (p_model_name, p_org);
pahse := '20' ;
   lvs_return :=
        lvs_return
        || f_get_year_code (p_model_name, TO_CHAR (p_smt_date, 'YYYY')); --temp
pahse := '30' ;
    lvs_return :=
        lvs_return
        || f_get_month_code (p_model_name, TO_CHAR (p_smt_date, 'YYYYMM'));
pahse := '40' ;
    lvs_return := lvs_return || f_get_day_code (TO_CHAR (p_smt_date, 'DD'));

    pahse := '60';


    SELECT   SEQ_REPAIR_RUN_NO_SEQUENCE.NEXTVAL INTO lvl_sequence FROM DUAL;
pahse := '50' ;
    IF lvl_sequence <= 15
    THEN
        lvs_return :=
            lvs_return || 'R0' || TRIM (TO_CHAR (lvl_sequence, 'XX'));
    ELSE
        lvs_return := lvs_return || 'R' || TRIM (TO_CHAR (lvl_sequence, 'XX'));
    END IF;


    RETURN lvs_return;
EXCEPTION
    WHEN OTHERS
    THEN
        raise_application_error (
            -20003,
            'PAHSE=' || pahse || '  ' || p_model_name || ' ' || SQLERRM);
END;