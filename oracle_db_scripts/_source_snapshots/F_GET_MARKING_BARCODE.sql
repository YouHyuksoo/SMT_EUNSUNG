FUNCTION "F_GET_MARKING_BARCODE" (p_run_no       IN VARCHAR2,
                                p_run_date     IN DATE,
                                p_model_name   IN VARCHAR2,
                                p_org          IN NUMBER)
    RETURN VARCHAR2
IS
    lvs_return     VARCHAR2 (20);
    lvl_sequence   NUMBER;
    phase varchar2(10) ;
BEGIN
    lvs_return := f_get_company_code (p_model_name, p_org);
    lvs_return :=
        lvs_return
        || f_get_year_code (p_model_name, TO_CHAR (p_run_date, 'YYYY'));
    lvs_return :=
        lvs_return
        || f_get_month_code (p_model_name, TO_CHAR (p_run_date, 'YYYYMM'));
    lvs_return := lvs_return || f_get_day_code (TO_CHAR (p_run_date, 'DD'));

    SELECT   seq_marking_sequence.NEXTVAL INTO lvl_sequence FROM DUAL;

    lvs_return := lvs_return || TRIM (TO_CHAR (lvl_sequence, '00000'));
    RETURN lvs_return;
EXCEPTION
    WHEN OTHERS
    THEN
        raise_application_error (
            -20003,
            p_run_no || '  ' || p_model_name || ' ' || SQLERRM || CHR (13));
END;