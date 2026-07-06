PROCEDURE "P_CHECK_FULL_SCAN" (
   p_plan_date    IN     VARCHAR2,
   p_model_name   IN     VARCHAR2,
   p_line_code    IN     VARCHAR2,
   p_table_id     IN     VARCHAR2,
   p_barcode      IN     VARCHAR2,
   p_deficit      IN     VARCHAR2,
   p_userid       IN     VARCHAR2,
   p_return          OUT VARCHAR2)
IS
   -------------------------------------------------------
   -- PLAN DATE FORMAT : YYYYMMDD
   -- p_deficit : 3 = NORMAL , 4 = CANCEL
   -- RETURN : OK , OTHERS : ERROR
   -- BARCODE STATUS : 0 = PRINT , 1 = RECEIPT , 2 = ISSUE
   -------------------------------------------------------
   lvs_barcode_status        VARCHAR2 (1);
   lvs_partname              VARCHAR2 (30);
   lvs_item_code_new         VARCHAR2 (30);
   lvi_count                 NUMBER;
   lvl_item_qty              NUMBER;
   lvi_no_ccs                NUMBER;
   lvs_model_name            VARCHAR2 (50);
   lvs_receipt_compare_yn    VARCHAR2 (1);
   lvs_issue_compare_yn      VARCHAR2 (1);
   lvs_holding_yn            VARCHAR2 (1);
   phase                     VARCHAR2 (10);
   lvs_inventory_hold        VARCHAR2 (1);
   lvs_lot_no                VARCHAR2 (50);
   lvl_first                 NUMBER;
   lvl_second                NUMBER;
   lvl_first_origin          NUMBER;
   lvl_second_origin         NUMBER;
   lvi_lot_count             NUMBER;
   lvs_table_id              VARCHAR2 (10);
   lvs_barcode               VARCHAR2 (100);
   lvl_check_seq             NUMBER;
   lvs_check_location_code   VARCHAR2 (10);
   lvl_check_count           NUMBER;
   lvs_topbot                VARCHAR2 (10);
   lvs_new_barcode_status    VARCHAR2 (1);

   lvs_no_css_address        VARCHAR2 (30);
   lvdt_valid_date           DATE;
   lvs_lot_serial            VARCHAR2 (10);
   lvs_trace_code            VARCHAR2 (30);

   LVI_COUNT_NG              NUMBER;
   LVL_TIME_TERM             NUMBER := 100 ; --300000;
   lvi_msl_over_count        NUMBER;
   
   lvi_row_count NUMBER ;
   lvl_ng_location_count NUMBER ;
   lvi_line_nsnp_count NUMBER ;   
   lvs_smt_model_name varchar2(50);
   
BEGIN
   phase := '10';

  
   lvs_barcode := f_get_prepare_barcode (p_barcode);
  
   ------------------------------------------------------------------------------

   phase := '11';

   IF LENGTH (lvs_barcode) < 10 or instr( lvs_barcode , '@' , 1 ) > 0  or instr( lvs_barcode , '---' , 1 ) > 0
   THEN
      p_return := f_msg('[FULL] 바코드 규격이 틀립니다','K',1)   -- -'00 Barcode Spec Invalid.'
                  || ' = '
                  || lvs_barcode;  
      RETURN;
   END IF;

   phase := '12';

   ----------------------------------------------------------------------------
   --
   ----------------------------------------------------------------------------
   lvs_item_code_new := f_get_item_code_from_barcode (lvs_barcode);
   phase := '13';
   ----------------------------------------------------------------------------
   --
   ----------------------------------------------------------------------------
   lvs_lot_no := f_get_lot_no_from_barcode (lvs_barcode);
   phase := '16';

   --------------------------------------------------
   -- CHECK SMT ADDRES
   --------------------------------------------------

   SELECT MIN (location_code), MAX (pcb_item)
     INTO lvs_check_location_code, lvs_topbot
     FROM ib_product_plandata
    WHERE     model_name = p_model_name
          AND line_code = SUBSTR (p_line_code, 1, 2)
          AND table_id = p_table_id
          AND NVL (full_check_yn, 'N') = 'N'
          AND ccs_yn = 'Y'
          AND active_yn = 'Y'
   ORDER BY line_code,
            machine,
            model_name,
            location_code;

   ----------------------------------------------------------
   --
   ----------------------------------------------------------
   SELECT COUNT (*)
     INTO lvl_check_count
     FROM ib_product_plandata
    WHERE     model_name = p_model_name
          AND line_code = SUBSTR (p_line_code, 1, 2)
          AND table_id = p_table_id
          AND location_code = lvs_check_location_code
          AND lvs_item_code_new LIKE '%' || ITEM_CODE
          AND NVL (full_check_yn, 'N') = 'N'
          AND ccs_yn = 'Y'
          AND active_yn = 'Y';

   phase := '30';

   --------------------------------------------------
   -- CHECK  PLAN DATA WITH NEW ADDRES
   --------------------------------------------------
   BEGIN
      SELECT DISTINCT model_name , smt_model_name
        INTO lvs_model_name , lvs_smt_model_name
        FROM ib_product_plandata
       WHERE     model_name = UPPER (p_model_name)
             AND line_code = SUBSTR (p_line_code, 1, 2)
             AND location_code = lvs_check_location_code
             AND TRIM (lvs_item_code_new) LIKE '%' || ITEM_CODE
             AND ccs_yn = 'Y'
             AND active_yn = 'Y';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvs_model_name := '';
   END;

   ---------------------------------------------------------------------------
   -- PARTNAME SELECT
   ---------------------------------------------------------------------------
   BEGIN
      SELECT item_code
        INTO lvs_partname
        FROM ib_product_plandata
       WHERE     model_name = UPPER (p_model_name)
             AND line_code = SUBSTR (p_line_code, 1, 2)
             AND location_code = lvs_check_location_code
             AND pcb_item = lvs_topbot
             AND active_yn = 'Y'
             AND replace_yn = 'N';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   --------------------------------------------------------------------------------
   --  ccs 완료 여부 체크 
   --------------------------------------------------------------------------------
   
       BEGIN
           SELECT   COUNT ( * ), MAX (location_code)
             INTO   lvi_no_ccs, lvs_no_css_address
             FROM   ib_product_plandata
            WHERE       model_name = UPPER (p_model_name)
                    AND line_code = SUBSTR (p_line_code, 1, 2)
                    AND pcb_item = lvs_topbot
                    AND active_yn = 'Y'
                    AND ccs_yn = 'N';
       EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
               lvi_no_ccs := 0;
       END;

           IF lvi_no_ccs > 0 OR lvi_no_ccs is null  THEN
               p_return :=  f_msg('[FULL] CCS가 완료되지 않았습니다.','K',1)  -- '00 CSS NOT COMPLETED'
                            || ' = '
                            || lvs_no_css_address;
               RETURN;
           END IF ;
  
   -----------------------------------------------------------
   --
   -----------------------------------------------------------
   IF lvs_item_code_new = '' OR lvs_item_code_new IS NULL
   THEN
      lvl_check_seq := seq_check_seq.NEXTVAL;

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
                                    location_code,
                                    check_type,
                                    table_id,
                                    pcb_item,
                                    lot_no,
                                    item_code,
                                    smt_model_name,
                                    ng_type)
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                UPPER (p_model_name),
                lvs_item_code_new,                            -- OUR ITEM CODE
                lvs_item_code_new,                       -- SUPPLIER ITEM CODE
                'E',
                f_msg('[FULL] 피더레이아웃에 미등록 자재입니다.','K',1),    -- '03 Feeder Layout Notfound'
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_barcode,                                    -- OUR BARCODE
                lvs_check_location_code,
                p_deficit,
                DECODE (SUBSTR (lvs_check_location_code, 1, 4),
                        'TRAY', 'Z',
                        SUBSTR (lvs_check_location_code, 1, 1)),
                lvs_topbot,
                lvs_lot_no,
                lvs_partname,
                '*' ,
                '*');

      UPDATE ib_product_plandata
         SET check_status = 'E',
             check_msg =
             f_msg('[FULL] 피더레이아웃에 미등록 자재입니다.','K',1)  -- '03 Feeder Layout Notfound'
             || ' = '
             || lvs_barcode,
             full_check_time = SYSDATE
       WHERE     model_name = UPPER (p_model_name)
             AND line_code = SUBSTR (p_line_code, 1, 2)
             AND location_code = lvs_check_location_code
             AND ccs_yn = 'Y'
             AND active_yn = 'Y';

      BEGIN
         --------------------------------------------------------------------------------
         -- NSNP START
         --------------------------------------------------------------------------------
         p_interlock_set_nsnp_time_msg (
                                         p_line_code,
                                         1,
                                         LVL_TIME_TERM,
                                         p_model_name,
                                         '*',
                                         'FULL CHECK',
                                         f_msg('[FULL] 피더레이아웃에 미등록 자재입니다.','K',1)  -- '03 Feeder Layout Notfound'
                                         || lvs_barcode
                                         || ' ' 
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

      p_return := f_msg('[FULL] 피더레이아웃에 미등록 자재입니다.','K',1)  -- '03 Feeder Layout Notfound'
                  || ' = '
                  || lvs_barcode;
      COMMIT;
      RETURN;
   END IF;

   phase := '40';

   ----------------------------------------------------------------------------
   -- 함습자재 체크
   ----------------------------------------------------------------------------

   SELECT COUNT (*)
     INTO lvi_msl_over_count
     FROM ib_product_plandata a, id_item b, im_item_receipt_barcode c
    WHERE     a.item_code = b.item_code
          AND a.item_code = c.item_code(+)
          AND a.lot_no = c.lot_no(+)
          AND TRUNC (
                 ( (SYSDATE - a.change_date) * 24
                  + NVL (c.msl_passed_time, 0))
                 / b.msl_max_time
                 * 100,
                 2) >= 100
          AND a.active_yn = 'Y'
          AND b.msl_level IS NOT NULL
          AND NVL (b.msl_max_time, 0) <> 0
          AND NVL(B.MSL_LEVEL,'1')  >= '3'
          AND a.line_code = SUBSTR (p_line_code, 1, 2)
          AND A.LOCATION_CODE = lvs_check_location_code;

   IF lvi_msl_over_count > 0 AND 1 = 2
   THEN
      lvl_check_seq := seq_check_seq.NEXTVAL;

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
                                    location_code,
                                    check_type,
                                    table_id,
                                    pcb_item,
                                    lot_no,
                                    item_code,
                                    smt_model_name,
                                    ng_type)
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                UPPER (p_model_name),
                lvs_item_code_new,
                lvs_item_code_new,
                'E',
                f_msg('[FULL] MSL 시간을 초과 하였습니다.','K',1),   -- '06 MSL Time Over.(FULL) '
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_barcode,
                lvs_check_location_code,
                p_deficit,
                DECODE (SUBSTR (lvs_check_location_code, 1, 4),
                        'TRAY', 'Z',
                        SUBSTR (lvs_check_location_code, 1, 1)),
                lvs_topbot,
                lvs_lot_no,
                lvs_partname,
                '*',
                '*');

      ------------------------------------------------------------------------
      --
      ------------------------------------------------------------------------
      UPDATE ib_product_plandata
         SET check_status = 'E',
             check_msg =
             f_msg('[FULL] MSL 시간을 초과 하였습니다.','K',1)   -- '06 MSL Time Over.(FULL) '
             || ' = '
             || lvs_barcode,
             full_check_time = SYSDATE
       WHERE     model_name = UPPER (p_model_name)
             AND line_code = SUBSTR (p_line_code, 1, 2)
             AND location_code = lvs_check_location_code
             AND item_code = TRIM (lvs_item_code_new)
             AND ccs_yn = 'Y'
             AND active_yn = 'Y';

      --------------------------------------------------------------------------------
      -- NSNP START
      --------------------------------------------------------------------------------

      BEGIN
         p_interlock_set_nsnp_time_msg (
                                         p_line_code,
                                         1,
                                         LVL_TIME_TERM,
                                         p_model_name,
                                         '*',
                                         'FULL CHECK',
                                         f_msg('[FULL] MSL 시간을 초과 하였습니다.','K',1)   -- '06 MSL Time Over.(FULL) ' 
                                         || ' = '
                                         || lvs_barcode
                                         || ', '
                                         || lvl_check_seq
                                       );
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------

      p_return :=
         f_msg('06 MSL Time Over.(FULL) ','C',1)
         || lvs_barcode;
      COMMIT;
      RETURN;
   END IF;
-------------------------------------------------------------------------------
-- CHECK AREAY CHECK
-- 기존에 체크한 자재와 동일한지 체크
-------------------------------------------------------------------------------

   BEGIN
      lvl_check_count := 0 ;
      SELECT COUNT (*)
        INTO lvl_check_count
        FROM ib_product_plandata
       WHERE     model_name = UPPER (p_model_name)
             AND line_code = SUBSTR (p_line_code, 1, 2)
             AND location_code = lvs_check_location_code
             AND ITEM_CODE = TRIM (lvs_item_code_new)
             AND LOT_NO    = LVS_LOT_NO
             AND pcb_item  = lvs_topbot
             AND check_yn  = 'Y'
        --     AND check_status = 'P'
             AND active_yn = 'Y';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_check_count := 0;
         null;
   END;
   ----------------------------------------------------------
   -- 활성화 되어 있는 현재 라인에  이전에 검사에 성공한 이력이 있으면 
   ----------------------------------------------------------
   IF NVL(lvl_check_count,0) = 1
   THEN
--      lvl_check_seq := seq_check_seq.NEXTVAL;
--      p_sequence := lvl_check_seq;

--      INSERT INTO ib_smt_checkhist (check_date,
--                                    check_sequence,
--                                    plan_date,
--                                    lot_name,
--                                    partname,
--                                    chipname,
--                                    check_status,
--                                    check_msg,
--                                    check_by,
--                                    line_code,
--                                    machine,
--                                    plan_date_sequence,
--                                    scan_partname,
--                                    scan_supplier_partname,
--                                    location_code,
--                                    check_type,
--                                    table_id,
--                                    pcb_item,
--                                    lot_no,
--                                    item_code,
--                                    supplier_barcode_origin,
--                                    our_barcode_origin,
--                                    valid_date,
--                                    lot_serial,
--                                    trace_code,
--                                    scan_qty,
--                                    vendor_name,
--                                    inspect_date)
--      VALUES (
--                SYSDATE,
--                lvl_check_seq,
--                p_plan_date,
--                UPPER (p_model_name),
--                lvs_item_code,
--                '*',                                 --lvs_item_code_supplier,
--                'P',
--                'OK',
--                p_userid,
--                SUBSTR (p_line_code, 1, 2),
--                TRIM (SUBSTR (p_line_code, 4, 10)),
--                0,
--                lvs_new_barcode,
--                '*',                                   --lvs_supplier_barcode,
--                p_address,
--                p_deficit,
--                DECODE (SUBSTR (p_address, 1, 4),
--                        'TRAY', 'Z',
--                        SUBSTR (p_address, 1, 1)),
--                p_tobbot,
--                lvs_lot_no,
--                lvs_partname,
--                p_barcode,
--                p_barcode,
--                lvdt_valid_date,
--                lvs_lot_serial,
--                lvs_trace_code,
--                0,                                             --lvl_item_qty,
--                lvs_vendor_name,
--                lvdt_inspect_date
--                    );

--      p_return := 'OK';
--      COMMIT;
--      RETURN;
        NULL ;
   ELSE
      p_return := f_msg('[FULL] 자재가 바뀌었습니다 장착불가.','K',1); --'Full Check NG : Item changed '
      RETURN;
   END IF;
   
-------------------------------------------------------------------------------
-- 마지막으로 해당위치에 레이아웃이 맞는지 체크 
-------------------------------------------------------------------------------
   IF lvs_model_name = '' OR lvs_model_name IS NULL
   THEN
      lvl_check_seq := seq_check_seq.NEXTVAL;

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
                                    location_code,
                                    check_type,
                                    table_id,
                                    pcb_item,
                                    lot_no,
                                    item_code,
                                    smt_model_name,
                                    ng_type)
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                UPPER (p_model_name),
                lvs_item_code_new,
                lvs_item_code_new,
                'E',
                f_msg('[FULL] 피더레이아웃에 미등록 자재입니다.','K',1), -- '04 Feeder Layout Notfound.'
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_barcode,
                lvs_check_location_code,
                p_deficit,
                DECODE (SUBSTR (lvs_check_location_code, 1, 4),
                        'TRAY', 'Z',
                        SUBSTR (lvs_check_location_code, 1, 1)),
                lvs_topbot,
                lvs_lot_no,
                lvs_partname,
                '*',
                '*');

      ------------------------------------------------------------------------
      --
      ------------------------------------------------------------------------
      UPDATE ib_product_plandata
         SET check_status = 'E',
             check_msg = f_msg('[FULL] 피더레이아웃에 미등록 자재입니다.','K',1)  -- '04 Feeder Layout Notfound.'
                         || ' = '
                         || lvs_barcode,
             full_check_time = SYSDATE,
             full_check_yn = 'Y'
       --item_barcode = lvs_barcode
       WHERE     model_name = UPPER (p_model_name)
             AND line_code = SUBSTR (p_line_code, 1, 2)
             AND location_code = lvs_check_location_code
             AND TRIM (lvs_item_code_new) LIKE '%' || item_code
             AND ccs_yn = 'Y'
             AND active_yn = 'Y';


      --------------------------------------------------------------------------------
      -- NSNP START
      --------------------------------------------------------------------------------           
            
       p_interlock_set_nsnp_time_msg (
                                      p_line_code, 
                                      1 ,
                                      lvl_time_term ,
                                      p_model_name , 
                                      '*' , 
                                      'FULL CHECK' , 
                                      f_msg('[FULL] 피더레이아웃에 미등록 자재입니다.','K',1) -- '04 Feeder Layout Notfound.'
                                      || ' = '
                                      || lvs_barcode
                                      ||', ADD='
                                      ||lvs_check_location_code
                                      ||', SEQ='
                                      ||lvl_check_seq
                                     );
      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------

      p_return := f_msg('[FULL] 피더레이아웃에 미등록 자재입니다.','K',1) -- '04 Feeder Layout Notfound.'
                  || ' = '
                  || SUBSTR (p_line_code, 1, 2)
                  || ', '
                  || lvs_check_location_code
                  || ', '
                  || lvs_item_code_new;
      COMMIT;
      RETURN;
   ---------------------------------------------------------------------------
   -- OK
   ---------------------------------------------------------------------------
   ELSE
      lvi_count := 1;
      lvl_check_seq := seq_check_seq.NEXTVAL;

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
                                    location_code,
                                    check_type,
                                    table_id,
                                    pcb_item,
                                    lot_no,
                                    item_code,
                                    valid_date,
                                    lot_serial,
                                    trace_code,
                                    smt_model_name,
                                    ng_type)
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                UPPER (p_model_name),
                lvs_item_code_new,
                lvs_item_code_new,
                'P',
                'OK',
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_barcode,
                lvs_check_location_code,
                p_deficit,
                DECODE (SUBSTR (lvs_check_location_code, 1, 4),
                        'TRAY', 'Z',
                        SUBSTR (lvs_check_location_code, 1, 1)),
                lvs_topbot,
                lvs_lot_no,
                lvs_partname,
                lvdt_valid_date,
                lvs_lot_serial,
                lvs_trace_code,
                '*',
                '*');

      -----------------------------------------------------------------------
      --
      -----------------------------------------------------------------------

      UPDATE ib_product_plandata
         SET check_status = 'P',
             check_msg = 'OK',
             full_check_time = SYSDATE,
             full_check_yn = 'Y'
       WHERE     model_name = UPPER (p_model_name)
             AND line_code = SUBSTR (p_line_code, 1, 2)
             AND location_code = lvs_check_location_code
             AND ccs_yn = 'Y'
             -- AND item_code = TRIM (lvs_item_code_new)
             AND active_yn = 'Y';

      COMMIT;
      
--      ------------------------------------------------------------------
--      -- 매스캔시 잠금 해제 조건이면 
--      ------------------------------------------------------------------
--       IF lvi_row_count > 0 THEN 
--        
--              BEGIN
--               SELECT  COUNT(*)
--                 INTO lvl_ng_location_count
--                 FROM ib_product_plandata
--                WHERE     model_name = UPPER (p_model_name)
--                      AND line_code = SUBSTR (p_line_code, 1, 2)
--                      AND active_yn = 'Y'
--                      AND pcb_item = lvs_topbot 
--                      AND check_status = 'E';
--              EXCEPTION  WHEN NO_DATA_FOUND  THEN
--                lvl_ng_location_count := 0 ;
--              END;  
--              
--              -------------------------------------------------------
--              -- 현제 라인이 잠근 상태인지 체크
--              -- 중복으로 해제 신호를 안보내기 위해 
--              -------------------------------------------------------
--              BEGIN  
--                SELECT COUNT(*) INTO lvi_line_nsnp_count 
--                  FROM ip_product_line
--                  WHERE line_code = SUBSTR (p_line_code, 1, 2)
--                   AND nsnp_status  LIKE 'ON%';
--                   
--              EXCEPTION  WHEN NO_DATA_FOUND  THEN
--                  lvi_line_nsnp_count := 0 ;
--              END;  
--              
--              -----------------------------------------------------------
--              -- 기존에 잠겨있었는지 체크해서 잠겨있었으면 
--              -- 해제해줌 
--              -----------------------------------------------------------
--                IF lvl_ng_location_count = 0 and lvi_line_nsnp_count > 0 THEN 
--                    BEGIN
--                        --------------------------------------------------------------------------------
--                        -- NSNP START
--                        --------------------------------------------------------------------------------
--                        p_interlock_set_nsnp_time_msg (
--                           substr(p_line_code,1,2),
--                           0, --action code
--                           0, -- time
--                           p_model_name,
--                           '*', -- suffix 
--                           'UNLOCK', -- reason
--                           'AUTO UNLOCK' ); --error message
--                     --------------------------------------------------------------------------------
--                     -- NSNP END
--                     --------------------------------------------------------------------------------
--                     EXCEPTION
--                        WHEN OTHERS
--                        THEN
--                           NULL;
--                     END;              
--
--                END IF  ;
--      
--       END IF ;   
      
      
      
   END IF;

   -----------------------------------------------------
   -- 이미 잠겨 있을경우에만 풀어준
   -----------------------------------------------------
   LVI_COUNT_NG := 0;

   SELECT COUNT (*)
     INTO LVI_COUNT_NG
     FROM IP_PRODUCT_LINE
    WHERE     LINE_CODE = SUBSTR (p_line_code, 1, 2)
          AND SUBSTR (NSNP_STATUS, 1, 2) = 'ON'
          AND NSNP_LOCK_TYPE = 'FULL CHECK';

   IF LVI_COUNT_NG > 0
   THEN
      ---------------------------------------------------------------------
      -- 스캔을 시작하면
      -- 현재 라인이 검사중인거로 설정한다.
      ---------------------------------------------------------------------
      UPDATE IB_SMT_FULLCHECK_TIME
         SET CHECK_YN = 'Y', CHECK_DATE = SYSDATE                  -- 검사한거로 체크
       WHERE LINE_CODE = SUBSTR (p_line_code, 1, 2) 
         AND CHECK_YN = 'N';

      --------------------------------------------------------------------------------
      -- 해제 해준다
      -- 풀체트 타임 테이블에 정보를 업데이트 한다 .
      --------------------------------------------------------------------------------

      BEGIN
         --------------------------------------------------------------------------------
         -- NSNP START
         --------------------------------------------------------------------------------
         p_interlock_set_nsnp_time_msg (
            p_line_code,
            0,
            0,
            p_model_name,
            '*',
            'UNLOCK',
            'FULL CHECK NG UNLOCK ' || lvl_check_seq);
      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;
   ELSE
      ---------------------------------------------------------------------
      -- 스캔을 시작하면
      -- 현재 라인이 검사중인거로 설정한다.
      ---------------------------------------------------------------------
      UPDATE IB_SMT_FULLCHECK_TIME
         SET CHECK_YN = 'Y', CHECK_DATE = SYSDATE                  -- 검사한거로 체크
       WHERE LINE_CODE = SUBSTR (p_line_code, 1, 2)
         AND CHECK_YN = 'N';
   END IF;

   COMMIT;

   phase := '110';

   --------------------------------------------------
   -- CHECK SMT ADDRES OK
   --------------------------------------------------

   IF lvi_count > 0  THEN
      p_return := 'OK';
      RETURN;
   ELSIF lvi_count < 1  THEN
      p_return := f_msg('[FULL] 피더레이아웃에 미등록 자재입니다.','K',1);  -- '05 Feeder Layout Notfound. '
      RETURN;
   END IF;
   
EXCEPTION
   WHEN OTHERS THEN
      raise_application_error (-20003, 'NG, [FULL] Phase=' || phase || '  ' || SQLERRM);
END;
