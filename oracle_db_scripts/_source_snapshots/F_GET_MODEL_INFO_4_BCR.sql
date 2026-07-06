FUNCTION "F_GET_MODEL_INFO_4_BCR" (p_run_no IN VARCHAR2, p_type in varchar2 default 'MODEL_SPEC' )
   RETURN varchar2
IS
   lvs_return   varchar2(50);
BEGIN

     SELECT decode(p_type, 'HW_VERSION', NVL(substr(serial_no, 14, 2),''),
                           'SW_VERSION', NVL(substr(serial_no, 16, 2),''),
                           'INDEX',      NVL(substr(serial_no, 18, 2),''),
                           'ERROR' )
       INTO lvs_return
       FROM ip_product_2d_barcode
      WHERE run_no          = p_run_no
        AND rownum          = 1;

   RETURN lvs_return;
   
EXCEPTION
   WHEN OTHERS THEN
        RETURN '';
END;
