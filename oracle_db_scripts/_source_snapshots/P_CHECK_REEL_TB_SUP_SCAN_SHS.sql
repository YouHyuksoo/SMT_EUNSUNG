PROCEDURE "P_CHECK_REEL_TB_SUP_SCAN_SHS" (
   p_plan_date          IN     VARCHAR2,
   p_model_name         IN     VARCHAR2,
   p_line_code          IN     VARCHAR2,
   p_topbot             IN     VARCHAR2,
   p_address            IN     VARCHAR2,
   p_supplier_barcode   IN     VARCHAR2,
   p_userid             IN     VARCHAR2,
   p_deficit            IN     VARCHAR2,
   p_return                OUT VARCHAR2,
   p_sequence              OUT VARCHAR2)
IS
   -------------------------------------------------------
   -- PLAN DATE FORMAT : YYYYMMDD
   -- p_deficit : 3 = NORMAL , 4 = CANCEL
   -- RETURN : OK , OTHERS : ERROR
   -- BARCODE STATUS : 0 = PRINT , 1 = RECEIPT , 2 = ISSUE
   -------------------------------------------------------
   lvi_count                        NUMBER;

   lvs_partname                     VARCHAR2 (30);


   lvs_new_barcode_status           VARCHAR2 (1);

   lvs_item_code_supplier           VARCHAR2 (30);
   lvs_item_code_new_replace        VARCHAR2 (50);
   lvs_item_code_supplier_replace   VARCHAR2 (100);

   lvl_item_qty                     NUMBER;
   lvs_model_name                   VARCHAR2 (50);

   lvs_lot_no                       VARCHAR2 (30);


   lvl_first_origin                 NUMBER;
   lvl_second_origin                NUMBER;

   lvs_supplier_barcode             VARCHAR2 (100);


   phase                            VARCHAR2 (10);

   lvl_check_seq                    NUMBER;
   lvs_label_type                   VARCHAR2 (10);
    lvl_time_term number := 1 ; --300000;
BEGIN
   phase := '10';

   
   --------------------------------------------------------------------------------
   -- 공급상 바코드가 제각각이라 의미없어서 그냥 리턴함 YHS 20201013
   --------------------------------------------------------------------------------   
      p_return := 'OK';
      RETURN;
      
   --------------------------------------------------------------------------------
   --
   --------------------------------------------------------------------------------

     lvs_supplier_barcode := f_get_prepare_barcode (p_supplier_barcode);

   ----------------------------------------------------------------------------
   --
   ----------------------------------------------------------------------------
   IF LENGTH (lvs_supplier_barcode) < 5
   THEN
      p_return := f_msg('[REEL SUP] 잘못된 바코드 입니다','K',1)   -- '00 ORIGIN BARCODE INVALID(SUP)'
                  || ' = '
                  || lvs_supplier_barcode;    
      RETURN;
   END IF;

   phase := '11';

   --------------------------------------------------------------------------------
   --
   --------------------------------------------------------------------------------

   lvs_item_code_supplier :=  f_get_item_code_from_barcode (lvs_supplier_barcode);
   
   if lvs_item_code_supplier is null then 
      lvs_item_code_supplier := '*' ;
   end if ;
   phase := '13';

   ----------------------------------------------------------------------
   --
   ----------------------------------------------------------------------

 --  lvs_lot_no := f_get_lot_no_from_barcode (lvs_supplier_barcode);


   -----------------------------------------------------------------
   --
   ----------------------------------------------------------------
   BEGIN
      lvl_item_qty := f_get_lot_qty_from_barcode (lvs_supplier_barcode);
   EXCEPTION
      WHEN OTHERS
      THEN
         lvl_item_qty := 0;
   END;

   ---------------------------------------------------------------------------
   -- PARTNAME SELECT
   ---------------------------------------------------------------------------
   BEGIN
      SELECT item_code
        INTO lvs_partname
        FROM ib_product_plandata
       WHERE     model_name = p_model_name
             AND line_code = SUBSTR (p_line_code, 1, 2)
             AND location_code = p_address
             AND pcb_item = p_topbot
             AND active_yn = 'Y'
             AND replace_yn = 'N';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;


   ----------------------------------------------------------------------------------
   -- REPLACE SUPPLIER ITEM CODE
   -- 거래처 품목으로 대체품목을 찾아온다
   ----------------------------------------------------------------------------------
   BEGIN
      SELECT MAX (item_code)
        INTO lvs_item_code_supplier_replace
        FROM id_item
       WHERE item_code = lvs_item_code_supplier
             OR part_no = lvs_item_code_supplier
             OR item_code =
                   SUBSTR (lvs_item_code_supplier, 1, LENGTH (item_code))
             OR part_no =
                   SUBSTR (lvs_item_code_supplier, 1, LENGTH (part_no));
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
        
           lvs_item_code_supplier_replace := '*';
         
          -- p_return := f_msg('[REEL SUP] 미등록 원자재 바코드 입니다.', 'K', 1);  --  '00 Our barcode Invalid.'
          -- RETURN;
   END;

   -----------------------------------------------------------
   --
   -----------------------------------------------------------
   IF lvs_item_code_supplier = '' OR lvs_item_code_supplier IS NULL
   THEN
      lvl_check_seq := seq_check_seq.NEXTVAL;
      p_sequence := lvl_check_seq;

      ---------------------------------------------------
      --  SMT PDA MATERIAL POSITION check history insert
      ---------------------------------------------------
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
                                    item_code,
                                    SUPPLIER_BARCODE_ORIGIN,
                                    enter_date,
                                    enter_by)
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                p_model_name,
                lvs_item_code_supplier,                       -- OUR ITEM CODE
                lvs_item_code_supplier,                  -- SUPPLIER ITEM CODE
                'E',
                f_msg('01 Supplier Barcode Invalid(SUP).','C',1),
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_supplier_barcode,                           -- OUR BARCODE
                '',
                p_address,
                p_deficit,
                DECODE (SUBSTR (p_address, 1, 4),
                        'TRAY', 'Z',
                        SUBSTR (p_address, 1, 1)),
                p_topbot,
                lvs_partname,
                p_supplier_barcode,
                sysdate,
                p_userid);

      COMMIT;

      UPDATE ib_product_plandata
         SET check_status = 'E',
             check_msg =
             f_msg('[REEL SUP] 공급상 바코드가 틀립니다','K',1)   -- '01 Supplier Barcode Invalid(SUP).'
             || ' = '
             || lvs_supplier_barcode
             ||' Item='
             || lvs_item_code_supplier,
             change_date = SYSDATE
       WHERE     model_name = p_model_name
             AND line_code = SUBSTR (p_line_code, 1, 2) --   AND machine = TRIM (SUBSTR (p_line_code, 4, 10))
             AND location_code = p_address
             AND active_yn = 'Y'
             AND pcb_item = p_topbot;

      p_return := f_msg('[REEL SUP] 공급상 바코드가 틀립니다','K',1)   -- '01 Supplier Barcode Invalid(SUP).'
                  || ' = ' 
                  || lvs_supplier_barcode
                  ||' Item='
                  || lvs_item_code_supplier;

      BEGIN
         --------------------------------------------------------------------------------
         -- NSNP START
         --------------------------------------------------------------------------------
         p_interlock_set_nsnp_time_msg (
                                        p_line_code,
                                        1,
                                        lvl_time_term,
                                        p_model_name,
                                        '*',
                                        'REEL CHECK',
                                        f_msg('[REEL SUP] 공급상 바코드가 틀립니다','K',1)   -- '01 Supplier Barcode Invalid(SUP).'
                                        || ' = '
                                        || lvs_supplier_barcode
                                        || ', '
                                        || p_address
                                        || ', '
                                        || lvl_check_seq
                                       );
      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      COMMIT;
      RETURN;
   END IF;

   phase := '30';

   --------------------------------------------------
   -- CHECK SMT ADDRES
   --------------------------------------------------
   BEGIN
      SELECT DISTINCT model_name
        INTO lvs_model_name
        FROM ib_product_plandata
       WHERE     model_name = p_model_name
             AND line_code = SUBSTR (p_line_code, 1, 2)
             AND location_code = p_address
             AND (TRIM (lvs_item_code_supplier) LIKE '%' || item_code
                  OR item_code LIKE '%' || lvs_item_code_supplier_replace)
             AND active_yn = 'Y'
             AND pcb_item = p_topbot;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvs_model_name := '';
   END;

   phase := '40';

   ------------------------------------------------------------------
   --
   ------------------------------------------------------------------
   IF lvs_model_name = '' OR lvs_model_name IS NULL
   THEN
      lvl_check_seq := seq_check_seq.NEXTVAL;
      p_sequence := lvl_check_seq;
      phase := '41';

      ---------------------------------------------
      --  SMT PDA MATERIAL POSITION check history insert
      ---------------------------------------------
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
                                    item_code,
                                    supplier_barcode_origin,
                                    enter_date,
                                    enter_by)
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                p_model_name,
                lvs_item_code_supplier,
                lvs_item_code_supplier,
                'E',
                f_msg('[REEL SUP] 피더레이아웃에 없는자재 입니다','K',1)    --   '02 Feeder layout notfound.(SUP) '
                || ' = '
                || ' Model='
                || p_model_name
                || ', Part='
                || lvs_partname
                || ', Scan='
                || lvs_item_code_supplier
                || ', Loc='
                || p_address,
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_supplier_barcode,
                '',
                p_address,
                p_deficit,
                DECODE (SUBSTR (p_address, 1, 4),
                        'TRAY', 'Z',
                        SUBSTR (p_address, 1, 1)),
                p_topbot,
                lvs_partname,
                p_supplier_barcode,
                sysdate,
                p_userid);

      COMMIT;
      phase := '42';

      ------------------------------------------------------------------------
      --
      ------------------------------------------------------------------------
      UPDATE ib_product_plandata
         SET check_status = 'E',
             check_msg =
              f_msg('[REEL SUP] 피더레이아웃에 없는자재 입니다','K',1)    -- '02 Feeder layout notfound.(SUP) '
              || ' = '
              || lvs_supplier_barcode,
             change_date = SYSDATE
       WHERE model_name = p_model_name
         AND line_code = SUBSTR (p_line_code, 1, 2)
         AND location_code = p_address
         AND active_yn = 'Y'
         AND pcb_item = p_topbot -- AND item_code = TRIM (lvs_item_code_new)
                                    ;

      BEGIN
         --------------------------------------------------------------------------------
         -- NSNP START
         --------------------------------------------------------------------------------
         p_interlock_set_nsnp_time_msg (
            SUBSTR(p_line_code,1,2),
            1,
            1,
            p_model_name,
            '*',
            'REEL CHECK PRE',
            f_msg('[REEL SUP] 피더레이아웃에 없는자재 입니다','K',1)   -- '02 Feeder layout notfound.(SUP) '
           );
      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------
      EXCEPTION
         WHEN OTHERS
         THEN
            RAISE_APPLICATION_ERROR( -20004 , SQLERRM ) ;
            RETURN ;
      END;

      phase := '43';
      
      p_return :=  f_msg('[REEL SUP] 피더레이아웃에 없는자재 입니다','K',1)  -- '02 Feeder layout notfound.(SUP) '
                   || ' = '
                   || SUBSTR (p_line_code, 1, 2)
                   || ', '
                   || p_address
                   || ', Scan:'
                   || lvs_item_code_supplier
                   || ', Replace:'
                   || lvs_item_code_supplier_replace;
      COMMIT;
      RETURN;
   --------------------------------------------------------------------------
   -- OK INSERT
   --------------------------------------------------------------------------
   ELSE
      lvi_count := 1;
   END IF;

   phase := '110';

   --------------------------------------------------
   -- CHECK SMT ADDRES OK
   --------------------------------------------------

   IF lvi_count > 0
   THEN
      p_return := 'OK';
      RETURN;
   ELSIF lvi_count < 1
   THEN
      p_return := f_msg('[REEL SUP] 피더레이아웃에 없는자재 입니다','K',1);   --'03 FEEDER LAYOUT NOT FOUND(SUP) '
      RETURN;
   END IF;
   
EXCEPTION
   WHEN OTHERS THEN
      raise_application_error (
                                -20003,
                               'NG, [REEL SUP] Phase='
                               || phase
                               || ', '
                               || p_model_name
                               || ', '
                               || p_line_code
                               || ', '
                               || p_address
                               || ', '
                               || SQLERRM);
END;
