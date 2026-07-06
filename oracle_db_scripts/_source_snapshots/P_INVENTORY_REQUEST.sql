PROCEDURE "P_INVENTORY_REQUEST" (
   p_line_code       IN     VARCHAR2,
   p_model_name      IN     VARCHAR2,
   p_item_barcode    IN     VARCHAR2,
   p_location_code   IN     VARCHAR2,
   p_type            IN     VARCHAR2,
   p_err                OUT VARCHAR2)
IS
   lvs_line_code               VARCHAR2 (30);
   lvs_machine                 VARCHAR2 (30);
   lvs_item_code               VARCHAR2 (100);
   lvs_suppliercode            VARCHAR2 (20);
   lvi_count                   NUMBER;
   lvs_barcode                 VARCHAR2 (200);
   lvs_location_address_rack   VARCHAR2 (30);
   lvi_material_exists         NUMBER;
BEGIN
   -----------------------------------------------------------------------
   --   P_TYPE : N = NORMAL , C = CANCEL
   --   1 : BARCODE INVALID
   --   2 : ITEM NOT FOUND
   --   3 : DELETE DATA NOT FOUND
   --   9 : SQLERROR
   -----------------------------------------------------------------------

  
      lvs_barcode := f_get_prepare_barcode (p_item_barcode);
      lvs_item_code := f_get_item_code_from_barcode (lvs_barcode);
  
   IF    lvs_barcode = '--'
      OR lvs_barcode IS NULL
      OR LENGTH (lvs_barcode) > 50
      OR LENGTH (lvs_barcode) < 10
   THEN
      p_err := f_msg('E00 바코드형식이틀립니다.','C',1);
      RETURN;
   END IF;

   ----------------------------------------------------------------------
   --
   ----------------------------------------------------------------------
   BEGIN
      SELECT COUNT (*)
      INTO   lvi_count
      FROM   id_item
      WHERE  item_code = lvs_item_code;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_err := f_msg('E01 품목마스터가 없습니다.','C',1);
         RETURN;
   END;
   
   BEGIN
      SELECT SUPPLIER_CODE
        INTO lvs_suppliercode
        FROM id_item
       WHERE item_code = lvs_item_code;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
        lvs_suppliercode := '';
   END;
   
   ----------------------------------------------------------------------
   --
   ----------------------------------------------------------------------
   if p_type = 'C' then 
      delete from im_item_request where item_barcode = p_item_barcode ;
      P_ERR := '' ;
      RETURN ;
   end if ;
   
   ----------------------------------------------------------------------
   -- check FIFO location code
   -- 선입선출 자재 위치조
   ----------------------------------------------------------------------

   SELECT
          MIN (NVL (a.location_address_rack, NVL (b.location_address, '*')))
   INTO
          lvs_location_address_rack
   FROM
          im_item_inventory a, id_item b
   WHERE
              a.item_code = b.item_code
          AND a.item_code = lvs_item_code
          AND a.last_receipt_date = (SELECT
                                            MIN (last_receipt_date)
                                     FROM
                                            im_item_inventory
                                     WHERE
                                            item_code = lvs_item_code
                                      AND    INVENTORY_QTY > 0)
          AND a.inventory_qty > 0;


   ----------------------------------------------------------------------
   --  FEEDER LAYOUT CHECK
   ----------------------------------------------------------------------

   BEGIN
      SELECT
             COUNT (*)
      INTO
             lvi_material_exists
      FROM
             ib_product_plandata
      WHERE
             model_name = p_model_name AND item_code = lvs_item_code;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvi_material_exists := 0;
   END;


   IF lvi_material_exists = 0
   THEN
      p_err :=
            f_msg('E02 피더레이아웃없는모델 : ' ,'C',1) 
         || p_model_name
         || ' '
         || lvs_item_code;
   --  RETURN;
   END IF;

   ----------------------------------------------------------------------
   --
   ----------------------------------------------------------------------
   IF p_type = 'N'
   THEN
      
      INSERT INTO
             im_item_request (request_date,
                              request_sequence,
                              line_code,
                              workstage_code,
                              machine_code,
                              item_code,
                              location_code,
                              request_status,
                              confirm_date,
                              enter_by,
                              enter_date,
                              last_modify_by,
                              last_modify_date,
                              organization_id,
                              item_barcode,
                              location_address_rack,
                              model_name)
      VALUES
             (SYSDATE,
              seq_mat_issue_request.NEXTVAL,
              SUBSTR (p_line_code, 1, 2),
              '*',
              NVL (TRIM (SUBSTR (p_line_code, 4, 10)), '*'),
              NVL (lvs_item_code, p_item_barcode),
              p_location_code,
              'R',
              NULL,
              'SYSTEM',
              SYSDATE,
              'SYSTEM',
              SYSDATE,
              1,
              NULL,
              lvs_location_address_rack,
              p_model_name);
               
   ELSE
      -------------------------------------------------------------------------
      --
      -------------------------------------------------------------------------
      BEGIN
         SELECT
                COUNT (*)
         INTO
                lvi_count
         FROM
                im_item_request
         WHERE
                    line_code = SUBSTR (p_line_code, 1, 2)
                AND item_barcode = p_item_barcode
                AND request_status = 'R';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_err := f_msg('E03 신청이력없음.','C',1);
            RETURN;
      END;

      DELETE FROM
             im_item_request
      WHERE
                 line_code = SUBSTR (p_line_code, 1, 2)
             AND item_barcode = p_item_barcode
             AND request_status = 'R';
   END IF;

   COMMIT;
   p_err := '';
   RETURN;
EXCEPTION
   WHEN OTHERS
   THEN
      p_err :=
            p_line_code
         || ' '
         || p_item_barcode
         || ' '
         || SUBSTR (SQLERRM, 1, 100);
      RETURN;
END;