FUNCTION "F_GET_NEW_RUN_NO" (
   p_smt_date     IN DATE,
   p_model_name   IN VARCHAR2,
   p_line_code    IN VARCHAR2,
   p_shift_code   IN VARCHAR2,
   p_org          IN NUMBER)
   RETURN VARCHAR2
IS
   lvs_return     VARCHAR2 (20);
   lvl_sequence   NUMBER;
   pahse          VARCHAR2 (10);
   lvs_yyyy       VARCHAR2 (4);
BEGIN
   pahse := '10';
 
   lvs_return := p_line_code||p_shift_code ;
 
   lvs_return := lvs_return||f_get_year_code (p_model_name, TO_CHAR (p_smt_date, 'YYYY')); --temp
   pahse := '30';
   lvs_return :=
      lvs_return
      || f_get_month_code (p_model_name, TO_CHAR (p_smt_date, 'YYYYMM'));
   pahse := '40';
   lvs_return := lvs_return || f_get_day_code (TO_CHAR (p_smt_date, 'DD'));

   pahse := '60';

   SELECT seq_run_no_sequence.NEXTVAL INTO lvl_sequence FROM DUAL;

   pahse := '50';


   IF lvl_sequence <= 15
   THEN
      lvs_return := lvs_return || '00' || TRIM (TO_CHAR (lvl_sequence, 'XXX'));
   ELSIF lvl_sequence <= 255
   THEN
      lvs_return := lvs_return || '0' || TRIM (TO_CHAR (lvl_sequence, 'XXX'));
   ELSE
      lvs_return := lvs_return || TRIM (TO_CHAR (lvl_sequence, 'XXX'));
   END IF;

   RETURN lvs_return;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (
         -20003,
         'PAHSE=' || pahse || '  ' || p_model_name || ' ' || SQLERRM);
END;