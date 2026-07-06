FUNCTION "F_GET_WINDOW_NAME" (p_window_id in varchar2)
/* Formatted on 2015-06-19 10:30:31 (QP5 v5.126) */
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (200);
BEGIN

    select korea_text
      into lvs_return
      from isys_dual_language
     where english_text = p_window_id ;

    RETURN lvs_return;

EXCEPTION
    WHEN others THEN

         RETURN p_window_id ;

END;