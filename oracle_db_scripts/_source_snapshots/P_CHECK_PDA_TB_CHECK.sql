PROCEDURE "P_CHECK_PDA_TB_CHECK" (
   p_plan_date    IN     VARCHAR2,
   p_model_name   IN     VARCHAR2,
   p_line_code    IN     VARCHAR2,
   p_tobbot       IN     VARCHAR2,
   p_address      IN     VARCHAR2,
   p_barcode      IN     VARCHAR2,
   p_userid       IN     VARCHAR2,
   p_deficit      IN     VARCHAR2,
   p_return          OUT VARCHAR2,
   p_sequence        OUT VARCHAR2)
IS
   -------------------------------------------------------
   -- PLAN DATE FORMAT : YYYYMMDD
   -- p_deficit : 3 = NORMAL , 4 = CANCEL
   -- RETURN : OK , OTHERS : ERROR
   -- BARCODE STATUS : 0 = PRINT , 1 = RECEIPT , 2 = ISSUE
   -------------------------------------------------------

   lvs_line_code     VARCHAR2 (20);
   lvi_count         NUMBER;

   lvs_item_code     VARCHAR2 (30);
   phase             VARCHAR2 (10);
   lvs_lot_no        VARCHAR2 (30);
   lvs_new_barcode   VARCHAR2 (100);
   lvs_check_count   NUMBER;
   lvl_check_seq     NUMBER;

   lvs_partname      VARCHAR2 (30);


   lvdt_valid_date   DATE;
   lvs_lot_serial    VARCHAR2 (10);
   lvs_trace_code    VARCHAR2 (30);
   lvs_vendor_name   VARCHAR2 (30);
   lvdt_inspect_date  DATE;
BEGIN
   phase := '10';


  
      lvs_new_barcode := f_get_prepare_barcode (p_barcode);
   ------------------------------------------------------------------------------
   --
   ------------------------------------------------------------------------------

   phase := '11';

   IF LENGTH (lvs_new_barcode) < 8 THEN
     
      p_return := f_msg('[CHECK REEL] 자사 바코드가 올바르지 않습니다.','K',1)
                  || ' = '
                  || p_address
                  || ', '
                  || lvs_new_barcode;
      RETURN;
      
   END IF;

   phase := '12';

   ----------------------------------------------------------------------------
   -- 자사 바코드에서 품목 / 롯트 추출
   ----------------------------------------------------------------------------
   lvs_item_code := f_get_item_code_from_barcode (lvs_new_barcode);
   lvs_lot_no    := f_get_lot_no_from_barcode (lvs_new_barcode);

   phase := '13';

   -----------------------------------------------------------
   --
   -----------------------------------------------------------
   IF lvs_item_code = '' OR lvs_item_code IS NULL THEN
     
      lvl_check_seq := seq_check_seq.NEXTVAL;
      p_sequence    := lvl_check_seq;

      p_return := f_msg('[CHECK REEL] 바코드내 품목을 알수없습니다.','K',1)   -- '03 Item code Unknown' 
                  || ' = '
                  || p_address
                  || ', '
                  || lvs_new_barcode;
                  
      COMMIT;
      RETURN;
      
   END IF;

   phase := '30';

   --------------------------------------------------
   -- CHECK AREAY CHECK
   -- 기존에 체크한 자재와 동일한지 체크
   --------------------------------------------------
   BEGIN
     
      SELECT COUNT (*)
        INTO lvs_check_count
        FROM ib_product_plandata
       WHERE model_name    = UPPER (p_model_name)
         AND line_code     = SUBSTR (p_line_code, 1, 2)
         AND location_code = p_address
         AND ITEM_CODE     = lvs_item_code
         AND LOT_NO        = LVS_LOT_NO
         AND pcb_item      = p_tobbot
         AND check_yn      = 'Y'
         AND check_status  = 'P'
         AND active_yn     = 'Y';
             
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           lvs_check_count := 0;
   END;

   IF NVL(lvs_check_count,0) = 1 THEN
     
      lvl_check_seq := seq_check_seq.NEXTVAL;
      p_sequence    := lvl_check_seq;

      INSERT INTO ib_smt_checkhist (check_date,
                                    check_sequence,
                                    plan_date,
                                    lot_name,
                                    partname,
                                    chipname,
                                    check_status,
                                    check_msg,
                                    check_by,
                                    line_code,
                                    machine,
                                    plan_date_sequence,
                                    scan_partname,
                                    scan_supplier_partname,
                                    location_code,
                                    check_type,
                                    table_id,
                                    pcb_item,
                                    lot_no,
                                    item_code,
                                    supplier_barcode_origin,
                                    our_barcode_origin,
                                    valid_date,
                                    lot_serial,
                                    trace_code,
                                    scan_qty,
                                    vendor_name,
                                    inspect_date,
                                    ng_type)
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                UPPER (p_model_name),
                lvs_item_code,
                '*',                                 --lvs_item_code_supplier,
                'P',
                'OK',
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_new_barcode,
                '*',                                   --lvs_supplier_barcode,
                p_address,
                p_deficit,
                DECODE (SUBSTR (p_address, 1, 4),'TRAY', 'Z', SUBSTR (p_address, 1, 1)),
                p_tobbot,
                lvs_lot_no,
                lvs_partname,
                p_barcode,
                p_barcode,
                lvdt_valid_date,
                lvs_lot_serial,
                lvs_trace_code,
                0,                                             --lvl_item_qty,
                lvs_vendor_name,
                lvdt_inspect_date,
                '*'
                    );

      p_return := 'OK';
      COMMIT;
      RETURN;
      
   ELSE
     
      p_return := f_msg('[CHECK REEL] 자재가 바뀌었습니다, 장착불가','K',1)   -- 'PQC Item changed '
                  || ' = '
                  || SUBSTR (p_line_code, 1, 2)
                  || ', '
                  || p_address
                  || ', '
                  ||LVS_LOT_NO ;--'자재가 바뀌었습니다 장착불가.';
      RETURN;
      
   END IF;

   phase := '110';
--------------------------------------------------
--
--------------------------------------------------

EXCEPTION WHEN OTHERS
   THEN
      raise_application_error (
                               -20003,
                               'NG, [CHECK REEL] Phase='
                               || phase
                               || ' Our BCD='
                               || lvs_new_barcode
                               || ' '
                               || SQLERRM);
END;