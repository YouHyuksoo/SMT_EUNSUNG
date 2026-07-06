PROCEDURE "P_INTERLOCK_MODEL_INFO" (
   p_model_name       IN     VARCHAR2,
   p_line_code        IN     VARCHAR2,
   p_workstage_code   IN     VARCHAR2,
   p_machine_code     IN     VARCHAR2,
   p_type             IN     VARCHAR2,
   p_org              IN     NUMBER,
   p_out              OUT VARCHAR2,
   p_message          OUT VARCHAR2
   )
IS
   -- ---------   ------  -------------------------------------------
   lvs_customer_model_name        VARCHAR2 (50);
   lvs_model_name                 VARCHAR2 (50);
   lvs_part_no                    VARCHAR2 (50);
   lvs_carrier_size               VARCHAR2 (50);
   lvs_marking_condition          VARCHAR2 (50);
   lvs_carrier_barcode_yn         VARCHAR2 (50);
   lvs_ng_process                 VARCHAR2 (50);
   lvl_customer_code              VARCHAR2 (50);
   lvl_serial_no_length           NUMBER;
   lvl_packing_pcs_qty            NUMBER;
   lvl_serial_array_length        NUMBER;
   lvs_carrier_barcode_position   VARCHAR2 (50);
   lvi_magazine_print_x           NUMBER;
   lvi_magazine_print_y           NUMBER;
   lvs_barcode_type               VARCHAR2 (50);
   lvi_magazine_no_length         NUMBER;
   lvi_model_count                NUMBER;
   lvs_model_name_cond            VARCHAR2 (50);
   lvs_item_code                  VARCHAR2 (50);
   lvs_revision                   VARCHAR2 (50);
   lvs_ec_no                      VARCHAR2 (50);
   lvs_packing_tray_box_qty       NUMBER;
   lvl_pid_print_x                NUMBER := 34;
   lvl_pid_print_y                NUMBER := 26;
   lvs_model_suffix               VARCHAR2 (50);
   lvs_serial_no_position         VARCHAR2 (50);
------------------------------------------------------------------
-- spi
------------------------------------------------------------------

BEGIN

   BEGIN
      SELECT COUNT (*)
        INTO lvi_model_count
        FROM ip_product_model_master
       WHERE model_name = p_model_name
         AND organization_id = p_org;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvi_model_count := 0;
   END;

   --------------------------------------------------------------------
   --
   --------------------------------------------------------------------

   IF lvi_model_count > 0
   THEN
      lvs_model_name_cond := p_model_name;
   ELSE
      BEGIN
         SELECT model_name
           INTO lvs_model_name_cond
           FROM ip_product_2d_barcode
          WHERE serial_no = p_model_name
            AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_out     := 'NG';
            p_message := p_model_name||f_msg(', 바코드 이력 없음','C',1);

            RETURN;
      END;
   END IF;

   ---------------------------------------------------------------------------------
   --
   ---------------------------------------------------------------------------------
   BEGIN
      SELECT model_name,
             part_no,
             carrier_size,
             marking_condition,
             carrier_barcode_yn,
             serial_no_length,
             customer_code,
             packing_pcs_qty,
             serial_array_length,
             carrier_barcode_position,
             magazine_print_x,
             magazine_print_y,
             barcode_type,
             magazine_no_length,
             item_code,
             revision,
             customer_model_name,
             ec_no,
             packing_tray_box_qty,
             pid_print_x,
             pid_print_y,
             model_suffix,
             serial_no_position
        INTO lvs_model_name,
             lvs_part_no,
             lvs_carrier_size,
             lvs_marking_condition,
             lvs_carrier_barcode_yn,
             lvl_serial_no_length,
             lvl_customer_code,
             lvl_packing_pcs_qty,
             lvl_serial_array_length,
             lvs_carrier_barcode_position,
             lvi_magazine_print_x,
             lvi_magazine_print_y,
             lvs_barcode_type,
             lvi_magazine_no_length,
             lvs_item_code,
             lvs_revision,
             lvs_customer_model_name,
             lvs_ec_no,
             lvs_packing_tray_box_qty,
             lvl_pid_print_x,
             lvl_pid_print_y,
             lvs_model_suffix,
             lvs_serial_no_position
        FROM ip_product_model_master
       WHERE model_name = lvs_model_name_cond
         AND organization_id = p_org;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN

         p_out     := 'NG';
         p_message := lvs_model_name_cond||f_msg(', 미 등록 모델','C',1);
         RETURN;

   END;

   --------------------------------------------------------------------------
   --
   --------------------------------------------------------------------------
   IF p_type = 'CUSTOMER_MODEL_NAME'
   THEN
      p_out := lvs_customer_model_name;
   ELSIF p_type = 'SERIAL_NO_POSITION'
   THEN
      p_out := lvs_serial_no_position;
   ELSIF p_type = 'MODEL_NAME'
   THEN
      p_out := lvs_model_name;
   ELSIF p_type = 'PART_NO'
   THEN
      p_out := lvs_part_no;
   ELSIF p_type = 'CARRIER_BARCODE_YN'
   THEN
      p_out := lvs_carrier_barcode_yn;
   ELSIF p_type = 'CARRIER_SIZE'
   THEN
      p_out := lvs_carrier_size;
   ----------------------------------------------------
   ELSIF p_type = 'MARKING_CONDITION'
   THEN
      p_out := lvs_marking_condition;
   -----------------------------------------------------
   ELSIF p_type = 'NG_PROCESS'
   THEN
      p_out := lvs_ng_process;
   ELSIF p_type = 'SERIAL_NO_LENGTH'
   THEN
      p_out := lvl_serial_no_length;
   ELSIF p_type = 'SERIAL_ARRAY_LENGTH'                             -- ARRAY 2
   THEN
      p_out := lvl_serial_array_length;
   ELSIF p_type = 'CARRIER_BARCODE_POSITION'
   THEN
      p_out := lvs_carrier_barcode_position;
   ELSIF p_type = 'CUSTOMER_CODE'
   THEN
      p_out := lvl_customer_code;
   ----------------------------------------------------
   -- insprect / selectev
   ----------------------------------------------------
   ELSIF p_type = 'PACKING_PCS_QTY'
   THEN
      IF F_GET_WORKSTAGE_TYPE(p_workstage_code ) = 'MAGAZINE' -- 'W080'
      THEN
         p_out := lvl_packing_pcs_qty;
      END IF;
   ELSIF P_TYPE = 'PACKING_TRAY_BOX_QTY'
   THEN
      p_out := lvs_packing_tray_box_qty;
   ELSIF p_type = 'MAGAZINE_PRINT_X'
   THEN
    
         p_out := lvi_magazine_print_x;
     
   ELSIF p_type = 'MAGAZINE_PRINT_Y'
   THEN
    
         p_out := lvi_magazine_print_y;
    
   ELSIF p_type = 'BARCODE_TYPE'
   THEN
      p_out := lvs_barcode_type;
   ELSIF p_type = 'MAGAZINE_NO_LENGTH'
   THEN
      p_out := lvi_magazine_no_length;
   ELSIF p_type = 'ITEM_CODE'
   THEN
      p_out := lvs_item_code;
   ELSIF p_type = 'REVISION'
   THEN
      p_out := lvs_revision;
   ELSIF p_type = 'EC_NO'
   THEN
      p_out := lvs_ec_no;
   ELSIF p_type = 'MODEL_SUFFIX'
   THEN
      p_out := lvs_model_suffix;
   ELSE
      p_out := '*';
   END IF;

   --    -------------------------------------------------------------------------
   --    --
   --    ------------------------------------------------------------------------
   --    INSERT INTO iq_interlock_request_log (line_code,
   --                                          machine_code,
   --                                          serial_no,
   --                                          request_date,
   --                                          comments,
   --                                          log_sequence,
   --                                          workstage_code,
   --                                          interlock_type,
   --                                          return_value)
   --      VALUES   ('*',
   --                '*',
   --                p_model_name,
   --                SYSDATE,
   --                'MODEL INFOR',
   --                seq_interlock_log.NEXTVAL,
   --                '*',
   --                p_type,
   --                p_out);
   --
   --    COMMIT;
   ---------------------------------------------------------------------------
   --
   ---------------------------------------------------------------------------
   RETURN;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
     p_out     :=  'NG';
     p_message :=  'NOT FOUND';

      --        -------------------------------------------------------------------------
      --        --
      --        ------------------------------------------------------------------------
      --        INSERT INTO iq_interlock_request_log (line_code,
      --                                              machine_code,
      --                                              serial_no,
      --                                              request_date,
      --                                              comments,
      --                                              log_sequence,
      --                                              workstage_code,
      --                                              interlock_type,
      --                                              return_value)
      --          VALUES   ('*',
      --                    '*',
      --                    p_model_name,
      --                    SYSDATE,
      --                    'MODEL INFOR',
      --                    seq_interlock_log.NEXTVAL,
      --                    '*',
      --                    p_type,
      --                    p_out);
      --
      --        COMMIT;

      RETURN;
   WHEN OTHERS
   THEN
     p_out     := 'NG';
     p_message := SQLERRM;

     raise_application_error (-20003, SQLERRM);
END;