FUNCTION "F_GET_MASTER_PID_SHS" (p_item_code IN VARCHAR2)
/* Formatted on 2015-06-29 19:19:57 (QP5 v5.126) */
    RETURN VARCHAR2
IS
    lvs_return          VARCHAR2 (30);
    lvs_customer_code   VARCHAR2 (10);
    lvs_days            VARCHAR2 (10);
    lvs_seq             VARCHAR2 (10);
    lvs_model_type      VARCHAR2 (10);
    lvs_site_code       VARCHAR2 (10);
    LVS_REVISION        VARCHAR2 (10);
    LVS_ITEM_CODE       VARCHAR2 (30);
    lvs_model_name      VARCHAR2 (30);

BEGIN

    BEGIN
        SELECT   customer_code , model_type ,site_code  , substr(revision,1,1) , item_code, model_name
          INTO   lvs_customer_code , lvs_model_type  , lvs_site_code , lvs_revision , lvs_item_code, lvs_model_name
          FROM   ip_product_model_master
         WHERE   (item_code = p_item_code OR model_name = p_item_code) AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            raise_application_error (-20005, p_item_code || ' ' || lvs_customer_code || ' ' || SQLERRM);
    END;

    --------------------------------------------------------------
    --  FACTORY , LINE , YY , DAYS , SERIAL(3)    -- 11 digit
    --------------------------------------------------------------
    SELECT   TO_CHAR (SYSDATE, 'DDD') INTO lvs_days FROM DUAL;

    --------------------------------------------------------------
    -- KEFICO
    --------------------------------------------------------------
    IF lvs_customer_code = '50401'
    THEN
        lvs_seq := TRIM (TO_CHAR (seq_pid_sequnce4.NEXTVAL, '0000'));

      -- 20161223 SHS, Sequence ？？？？？？？ ？？？？？？？ 
        lvs_return := '4' || SUBSTR (lvs_seq, 1, 1) || TO_CHAR (SYSDATE, 'YY') || lvs_days || SUBSTR (lvs_seq, 2, 3);
      --  lvs_return := '4' || SUBSTR (lvs_seq, 1, 1) || '26' || lvs_days || SUBSTR (lvs_seq, 2, 3);

    --------------------------------------------------------------
    --BOSCH
    --------------------------------------------------------------
    ELSIF lvs_customer_code = 'BOSCH'
    THEN
        lvs_seq := TRIM (TO_CHAR (seq_pid_sequnce7.NEXTVAL, '0000000'));

        lvs_return := '91' ||lvs_seq;

    --------------------------------------------------------------
    --  LG INNOTEK 10 DIGIT
    --------------------------------------------------------------
    ELSIF lvs_customer_code = '00844'
    THEN

        -- 20161223 SHS, model_name？？ item_code ？？ ？？？？ ？？？？？？ ？？？？
        lvs_return :=
               'Y'
            || f_get_smtdate_code (lvs_model_name, SYSDATE)
            || f_get_model_type (p_item_code, 1)
            || TRIM (TO_CHAR (seq_pid_sequnce5.NEXTVAL, '00000'));

    --------------------------------------------------------------
    -- DY
    --------------------------------------------------------------
    ELSIF lvs_customer_code = 'DY'
    THEN
        lvs_seq := TRIM (TO_CHAR (seq_pid_sequnce4_dy.NEXTVAL, '0000'));

        --？？？？ ？？？ ？？？？  1

        lvs_return := nvl(lvs_model_type,'1') || SUBSTR (lvs_seq, 1, 1) || TO_CHAR (SYSDATE, 'YY') || lvs_days || SUBSTR (lvs_seq, 2, 3);

    --------------------------------------------------------------
    -- HLDS
    --------------------------------------------------------------
   ELSIF lvs_customer_code = 'HLDS'
   THEN
      lvs_seq := TRIM (TO_CHAR (seq_pid_sequnce5.NEXTVAL, '00000'));

      lvs_return := lvs_site_code||lvs_seq||TO_CHAR(SYSDATE,'YYMMDD')||LVS_REVISION||LVS_ITEM_CODE ;

    --------------------------------------------------------------
    --  ？？？？？？？u 10 DIGIT
    --------------------------------------------------------------
    ELSIF lvs_customer_code = '00200'
    THEN

        lvs_return := lvs_site_code
                      || 'A'  -- line code : 1~9, A-Z
                      || f_get_year_code (lvs_model_name, SUBSTR(TO_CHAR (sysdate, 'yyyymmdd'), 1, 6))
                      || f_get_month_code(lvs_model_name, SUBSTR(TO_CHAR (sysdate, 'yyyymmdd'), 1, 6))
                      || to_char(sysdate,'DD')
                      || lvs_revision
                      || TRIM (TO_CHAR (SEQ_PID_SEQUNCE8_SEOUL.NEXTVAL, '000'));

   ELSE
        lvs_return := '*';
    END IF;

    RETURN lvs_return;

EXCEPTION
    WHEN OTHERS
    THEN
        raise_application_error (-20005, p_item_code || ' ' || lvs_customer_code || ' ' || SQLERRM);
END;
