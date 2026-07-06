FUNCTION "F_GET_ANY_NO" (p_name IN VARCHAR2, p_org IN NUMBER)
   RETURN VARCHAR2
IS
   lvs_return_value   VARCHAR2 (100);
BEGIN

  IF p_name = 'TRANSFER_INVOICE_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd') || SEQ_TRANSFER_INVOICE_SEQ.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;

  IF p_name = 'RECEIPT_LOT_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd') || SEQ_RECEIPT_LOT_NO.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;


  IF p_name = 'CUSTOMER_ORDER_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd') || SEQ_CUSTOMER_ORDER_NO.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;

   IF p_name = 'ORDER_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd') || seq_purchase_order_no.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;

   IF p_name = 'PRODUCT_SHIPPING_INVOICE_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd') || seq_product_shipping_seq.CURRVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;

   IF p_name = 'PRODUCT_SHIPPING_LOT_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd')
             || seq_product_shipping_lot_no.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;


  /* IF p_name = 'WQC_INSPECT_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd')
             || seq_wqc_inspect_no.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;*/

   IF p_name = 'LQC_INSPECT_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd')
             || seq_lqc_inspect_no.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;

   IF p_name = 'OQC_INSPECT_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd')
             || seq_qc_oqc_inspect_no.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;

   IF p_name = 'FQC_INSPECT_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd')
             || seq_fqc_inspect_no.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;


   IF p_name = 'MFS'
   THEN
      SELECT SUBSTR(TO_CHAR (SYSDATE, 'yy'),1,2)||'TC-'
             || seq_mfs.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;

   IF p_name = 'MFS_MGT'
   THEN
      SELECT SUBSTR(TO_CHAR (SYSDATE, 'yy'),1,2)||'TM-'
             || seq_mfs.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;



   IF p_name = 'MATERIAL_SALE_ISSUE_INVOICE'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd')
             || SEQ_MAT_SALE_ISSUE.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;

   IF p_name = 'PRODUCT_DATE'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yyyymmdd')
        INTO lvs_return_value
        FROM DUAL;
   END IF;

   IF p_name = 'PRODUCT_DATE_LAST'
   THEN
      SELECT TO_CHAR (SYSDATE - 1, 'yyyymmdd')
        INTO lvs_return_value
        FROM DUAL;
   END IF;

   RETURN lvs_return_value;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;