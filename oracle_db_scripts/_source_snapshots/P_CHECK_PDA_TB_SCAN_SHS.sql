PROCEDURE P_CHECK_PDA_TB_SCAN_SHS (
                                                  p_plan_date        IN     VARCHAR2,
                                                  p_model_name       IN     VARCHAR2,
                                                  p_line_code        IN     VARCHAR2,
                                                  p_tobbot           IN     VARCHAR2,
                                                  p_address          IN     VARCHAR2,
                                                  p_origin_barcode   IN     VARCHAR2,
                                                  p_barcode          IN     VARCHAR2,
                                                  p_userid           IN     VARCHAR2,
                                                  p_deficit          IN     VARCHAR2,
                                                  p_return           OUT    VARCHAR2,
                                                  p_sequence         OUT    VARCHAR2
                                                )
IS
   -------------------------------------------------------
   -- PLAN DATE FORMAT : YYYYMMDD
   -- p_deficit : 3 = NORMAL , 4 = CANCEL
   -- RETURN : OK , OTHERS : ERROR
   -- BARCODE STATUS : 0 = PRINT , 1 = RECEIPT , 2 = ISSUE
   -------------------------------------------------------
   lvs_new_barcode_status           VARCHAR2 (1);
   lvs_line_code                    VARCHAR2 (20);
   lvs_item_code_supplier           VARCHAR2 (30);
   lvs_item_code_supplier_replace   VARCHAR2 (30);

   lvi_count                        NUMBER;

   lvs_item_code                    VARCHAR2 (30);
   lvl_item_qty                     NUMBER;
   lvs_model_name                   VARCHAR2 (50);
   lvs_receipt_compare_yn           VARCHAR2 (1);
   lvs_issue_compare_yn             VARCHAR2 (1);
   lvs_holding_yn                   VARCHAR2 (1);
   phase                            VARCHAR2 (10);
   lvs_inventory_hold               VARCHAR2 (1);
   lvs_lot_no                       VARCHAR2 (30);
   lvl_first                        NUMBER;
   lvl_second                       NUMBER;
   lvl_first_origin                 NUMBER;
   lvl_second_origin                NUMBER;
   lvi_lot_count                    NUMBER;
   lvs_supplier_barcode             VARCHAR2 (100);
   lvs_new_barcode                  VARCHAR2 (100);
   lvs_check_count                  NUMBER;
   lvl_check_seq                    NUMBER;

   lvs_partname                     VARCHAR2 (30);

   lvl_pos1                         NUMBER;
   lvl_pos2                         NUMBER;
   lvl_pos3                         NUMBER;

   lvdt_valid_date                  DATE;
   lvs_lot_serial                   VARCHAR2 (10);
   lvs_trace_code                   VARCHAR2 (30);
   lvs_item_code_new                VARCHAR2 (30);
   lvl_new_scan_qty                 NUMBER;
   lvs_vendor_name                  VARCHAR2 (30);
   lvdt_inspect_date                DATE;
   lvs_supplier_code                VARCHAR2 (30);
   lvs_supplier                     VARCHAR2 (30);

   lvs_ccs_yn                       VARCHAR2 (10);
   lvs_inventory_type               VARCHAR2 (10) ;
   lvs_production_type              VARCHAR2 (10) ;
   lvl_zethani_temp                 number; 
   
   lvs_smt_model_name               VARCHAR2(50) := '*' ;
   lvs_feeding_yn                   VARCHAR2(30) ;
   lvi_aready_exists                number ;
   
   lvi_row_count                    NUMBER ;
   lvl_ng_location_count            NUMBER ;
   lvi_line_nsnp_count              NUMBER ;
   
   lvi_msl_over_count               NUMBER;
   
   lvs_run_no                       VARCHAR2 (30);
   
   lvs_reel_destroy_yn              VARCHAR2 (10) ;
   
   lvs_machine_name                 VARCHAR2 (100);
    
   lvs_barcode                      VARCHAR2(50);
   

BEGIN

   phase := '05';
   
   ----------------------------------------------------------------------------------------------
   -- 2016/10/17 SHS, our barcode(p_barcode) 에 대해 바코드 master 등록여부 확인 및 KEFICO 경우 SKIP
   ----------------------------------------------------------------------------------------------

  
       IF (f_check_receipt_barcode_exists(p_barcode, 1) <> 'EXISTS') THEN

           p_return := f_msg('[CCS] 자사 바코드가 올바르지 않습니다.', 'K', 1) ; --'00 'Our Barcode Invalid. '
           p_sequence := '' ;
           RETURN;

       END IF;
       
   ----------------------------------------------------------------------------------------------
   -- 2020/11/16 SHS, 폐기여부 확인
   ----------------------------------------------------------------------------------------------       
       
       select count(*)
         into lvi_row_count
         from im_item_receipt_barcode
        where item_barcode = p_barcode
          and REEL_DESTROY_YN   = 'Y' ;
          
       IF ( lvi_row_count > 0 ) THEN

           p_return := f_msg('[CCS] 페기된 바코드 입니다.', 'K', 1) ; --'00 'Our Barcode Invalid. '
           p_sequence := '' ;
           RETURN;

       END IF;          
       
   ----------------------------------------------------------------------------------------------
   -- 2021/08/25  베이킹 또는 제습함 입고 자재인지 확인
   ----------------------------------------------------------------------------------------------       
       
	   select max(f_get_machine_name( chamber_code )), count(*)
       into lvs_machine_name, lvi_row_count
       from im_item_baking_master
      where item_barcode like p_barcode
        and output_scan_date is null;
        
            
       IF ( lvi_row_count > 0 ) THEN

           p_return := f_msg('[CCS] '|| lvs_machine_name ||'에 미출고 자재입니다.', 'K', 1) ; --'00 'Our Barcode Invalid. '
           p_sequence := '' ;
           RETURN;

       END IF;          
        

   ----------------------------------------------------------------------------------------------

   phase := '10';

   -----------------------------------------------------------------------
   -- 거래처 바코드

   lvs_supplier_barcode := f_get_prepare_barcode (p_origin_barcode);
 
   lvl_pos1 := 0;
   lvl_pos2 := 0;

   -------------------------------------------------------------------------------
   -- 자사 바코드

   lvs_new_barcode := f_get_prepare_barcode (p_barcode);
   ------------------------------------------------------------------------------
   --
   ------------------------------------------------------------------------------

   IF LENGTH (lvs_supplier_barcode) < 5 THEN
      p_return := f_msg('[CCS] 거래처 바코드가 올바르지 않습니다.', 'K', 1);  --  '00 Supplier barcode Invalid.'
      RETURN;
   END IF;

   phase := '11';

   IF LENGTH (lvs_new_barcode) < 20 or  instr( lvs_new_barcode , '@' , 1 ) > 0  or instr( lvs_new_barcode , '---' , 1 ) > 0 THEN
      p_return := f_msg('[CCS] 자사 바코드가 올바르지 않습니다.', 'K', 1);  --  '00 Our barcode Invalid.'
      RETURN;
   END IF;

   phase := '12';
   --------------------------------------------------------------------------------
   -- 공급상 바코드 에서 품목 코드를 추출하는데
   --
   --------------------------------------------------------------------------------

   lvs_item_code_supplier:= f_get_item_code_from_barcode(lvs_supplier_barcode);

   --------------------------------------------------------------------------------
   -- REPLACE SUPPLIER ITEM CODE
   --------------------------------------------------------------------------------
   BEGIN
     
      SELECT MAX (item_code)
        INTO lvs_item_code_supplier_replace
        FROM id_item
       WHERE item_code    = lvs_item_code_supplier
             OR part_no   = lvs_item_code_supplier
             OR item_code = SUBSTR (lvs_item_code_supplier, 1, LENGTH (item_code))
             OR part_no   = SUBSTR (lvs_item_code_supplier, 1, LENGTH (part_no));
             
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           lvs_item_code_supplier_replace := '*';
           
          -- p_return := f_msg('[CCS] 미등록 원자재 바코드 입니다.', 'K', 1);  --  '00 Our barcode Invalid.'
          -- RETURN;
   
   END;

   ----------------------------------------------------------------------------
   -- 자사 바코드에서 품목 / 롯트 추출
   ----------------------------------------------------------------------------
   lvs_item_code_new := f_get_item_code_from_barcode (lvs_new_barcode);
   lvs_lot_no := f_get_lot_no_from_barcode (lvs_new_barcode);

   phase := '13';

   -----------------------------------------------------------------
   -- 자사바코드에서 수량 추출
   ----------------------------------------------------------------
   BEGIN
      lvl_item_qty := f_get_lot_qty_from_barcode (lvs_new_barcode);
   EXCEPTION
      WHEN OTHERS THEN
        p_return := f_msg('[CCS] 바코드 내 수량정보 오류 입니다.', 'K', 1)    -- '01 Qty Invalid in baarcoe.'
                    || ' '
                    || lvs_new_barcode; 
        RETURN;
 
   END;
    ---------------------------------------------------------------------
    --   양산인지 샘플인지 체크 
    ---------------------------------------------------------------------
    begin 
    
      select nvl(production_type, 'P'), run_no
        into lvs_production_type , lvs_run_no  
        from ip_product_line 
       where line_code = SUBSTR (p_line_code, 1, 2) ;
     exception
        when others then 
             null;
    end ;

   phase := '14';

   --------------------------------------------------
   -- CHECK ERP BARCODE CREATE HISTORY
   --------------------------------------------------
   IF SUBSTR (p_address, 1, 4) = 'TRAY' THEN
      NULL;
   ELSE
     
      BEGIN
        
         SELECT NVL (barcode_status, 'N'),
                decode( nvl(new_scan_qty,0)  , 0  , NVL (scan_qty, 0), new_scan_qty ) ,
                NVL (receipt_compare_yn, 'N'),
                NVL (issue_compare_yn, 'N'),
                holding_yn,
                NVL(line_code,'*'),
                NVL (NEW_SCAN_QTY, 0),
                supplier_code ,
                NVL(inventory_type , 'P'),
                feeding_yn,
                NVL(reel_destroy_yn, 'N')  
           INTO lvs_new_barcode_status,
                lvl_item_qty,
                lvs_receipt_compare_yn,
                lvs_issue_compare_yn,
                lvs_holding_yn,
                lvs_line_code,
                lvl_new_scan_qty,
                lvs_supplier_code ,
                lvs_inventory_type ,
                lvs_feeding_yn,
                lvs_reel_destroy_yn
           FROM im_item_receipt_barcode
          WHERE lot_no = lvs_lot_no
            AND UPPER (TRIM (lvs_item_code_new)) LIKE '%' || item_code
            AND receipt_compare_yn = 'Y';
            
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
           
              p_return := f_msg('[CCS] 존재하지 않는 바코드 입니다.', 'K', 1)    --'01 Inventory Type Unmatch '
                          || ' = '
                          || lvs_lot_no
                          || ', '
                          || lvs_item_code_new; 
              RETURN; 
              
         WHEN OTHERS THEN
              p_return := SQLERRM;
      END;
      
   END IF;
   
   -----------------------------------------------------------------
   -- 이미종료된 자재인지 확인
   -----------------------------------------------------------------
   
   IF ( lvs_reel_destroy_yn = 'Y' ) THEN
     
        p_return := f_msg('[CCS] 이미 종료된 자재 입니다.', 'K', 1)    
                    || ' = '
                    || lvs_lot_no;
        RETURN; 
   
   END IF;  

   -----------------------------------------------------------------
   -- 생산유형과 자재 유형이 불일치 할 경우 
   -----------------------------------------------------------------
   
   IF ( lvs_production_type = 'P' ) THEN
     
         IF ( lvs_production_type <> lvs_inventory_type ) then 
           
               p_return := f_msg('[CCS] 자재유형이 일치하지 않습니다.', 'K', 1)    --'01 Inventory Type Unmatch '
                           || ' = '
                           || lvs_production_type
                           || ', '
                           || lvs_inventory_type; 
               RETURN; 
         
         END IF ; 
   
   END IF;

  ---------------------------------------------------------------------------
   --  이미 장착된 자재인지 체크 
   ---------------------------------------------------------------------------
   BEGIN
     
      SELECT count(*)
        INTO lvi_aready_exists
        FROM ib_product_plandata
       WHERE  model_name = p_model_name
          AND line_code  = SUBSTR (p_line_code, 1, 2)
          AND pcb_item   = p_tobbot
          AND lot_no     = lvs_lot_no
          AND active_yn  = 'Y'
          AND ccs_yn     = 'Y'
          AND ROWNUM     = 1 ;
         
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

  IF nvl(lvi_aready_exists,0) > 0  then 
         p_return   := f_msg('[CCS] 이미 장착된 자재 입니다.', 'K', 1)    --'Already Used Lot No'
                       || ' = '
                       || lvs_lot_no;
         p_sequence := NULL ;
         RETURN; 
  END IF ; 
  
   -----------------------------------------------------------------
   -- 품목마스터정보 가져오기- 주고객사코드

   ----------------------------------------------------------------
   BEGIN
         SELECT NVL (supplier_code, '*')
           INTO lvs_supplier
           FROM id_item
          WHERE UPPER (TRIM (lvs_item_code_new)) LIKE '%' || item_code ;
   EXCEPTION
         WHEN NO_DATA_FOUND THEN
              NULL;
         WHEN OTHERS THEN
              p_return := SQLERRM;
   END;

   -----------------------------------------------------------------
   -- 신규스캔(생산잔량) 이 있으면 그수량으로 장착 아니면
   -- 라벨에 기입된 수량
   ----------------------------------------------------------------
   BEGIN
     
      IF lvl_new_scan_qty <> 0 THEN
         lvl_item_qty := lvl_new_scan_qty;
      ELSE
         NULL;
      END IF;
      
   EXCEPTION
      WHEN OTHERS THEN
           lvl_item_qty := 0;
   END;

    ---------------------------------------------------------------------
    -- 제습함 check 
    ---------------------------------------------------------------------
         
        select count(*), max(item_barcode)
          into lvi_count, lvs_barcode
          from im_item_baking_master
         where chamber_type = 'D'
           and chamber_code = 'M0001'
           and output_scan_date is null
           and item_code        = lvs_item_code_new
           and input_scan_date  = (
                                    select min(input_scan_date)
                                      from im_item_baking_master
                                     where chamber_type = 'D'
                                       and chamber_code = 'M0001'
                                       and output_scan_date is null
                                       and item_code        = lvs_item_code_new
                                  );
                                     
       
    IF ( lvi_count > 0 ) then
      
         p_return := f_msg('[CCS] 제습함에 재고가 존재 합니다, 재고 소진 후 장착 하세요.', 'K', 1) 
                    || ' '
                    || lvs_barcode; 
          RETURN;
                              
    END IF;
    
   -------------------------------------------------------------------------
   -- 자재출고이력 체크
   -------------------------------------------------------------------------

--      IF NVL (lvs_issue_compare_yn, 'N') = 'N' THEN
--        
--         p_return :=  f_msg('[CCS] 미출고 바코드 입니다.', 'K', 1)    -- 'Unissued barode.
--                      || ' = '
--                      || lvs_new_barcode;
--         RETURN;
--         
--      END IF;

      --------------------------------------------------------------------------------
      -- 라인 불일치 체크
      -- 20170417 유혁수 
      --------------------------------------------------------------------------------
      
/*      
      IF SUBSTR (p_line_code, 1, 2) <> lvs_line_code THEN
         p_return := f_msg('[CCS] 투입라인이 일치 하지 않습니다.','K',1)  -- 06 Line Unmatch
                     || ' = '
                     || p_line_code
                     || ',  ' 
                     || lvs_line_code;
         RETURN;
      END IF;
*/
 
   phase := '15';
   ---------------------------------------------------------------------------
   -- PARTNAME SELECT
   ---------------------------------------------------------------------------
   BEGIN
     
      SELECT item_code, NVL(ccs_yn, 'N')
        INTO lvs_partname, lvs_ccs_yn
        FROM ib_product_plandata
       WHERE model_name    = p_model_name
         AND line_code     = SUBSTR (p_line_code, 1, 2)
         AND location_code = p_address
         AND pcb_item      = p_tobbot
         AND active_yn     = 'Y'
         AND replace_yn    = 'N';
         
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   --------------------------------------------------------------------------------
   --  SUP ITEM AND OUR ITEM COMPARE
   --------------------------------------------------------------------------------
   IF     lvs_item_code_supplier <> lvs_item_code_new
      AND lvs_item_code_supplier_replace <> lvs_item_code_new
      AND INSTR (lvs_item_code_supplier, lvs_item_code_new, 1) <= 0
      AND INSTR (lvs_item_code_supplier, TRIM (SUBSTR (lvs_item_code_new, 2, 20)), 1) <= 0
      AND INSTR (lvs_item_code_supplier, TRIM (SUBSTR (lvs_item_code_new, 1, 11)), 1) <= 0
   THEN
     
      lvl_check_seq := seq_check_seq.NEXTVAL;
      p_sequence    := lvl_check_seq;

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
                                    lot_no,
                                    item_code,
                                    smt_model_name ,
                                    ng_type,
                                    enter_date,
                                    enter_by)
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                p_model_name,
                lvs_item_code_new,                            -- OUR ITEM CODE
                lvs_item_code_supplier,                  -- SUPPLIER ITEM CODE
                'E',
                f_msg('[CCS] 바코드의 품목이 일치하지 않습니다.','K',1)       -- '01 Barcode Unmatch.'
                || lvs_item_code_supplier
                || ' '
                || lvs_item_code_new,
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_new_barcode,                         -- OUR ORIGIN BARCODE
                lvs_supplier_barcode,
                p_address,
                p_deficit,
                DECODE (SUBSTR (p_address, 1, 4), 'TRAY', 'Z', SUBSTR (p_address, 1, 1)),
                p_tobbot,
                lvs_lot_no,
                lvs_partname,
                lvs_smt_model_name,
                '*',
                sysdate,
                p_userid);
                
      -------------------------------------------------------------------------
      --
      -------------------------------------------------------------------------
      UPDATE ib_product_plandata
         SET check_status   = 'E',
             check_msg     = f_msg('[CCS] 바코드의 품목이 일치하지 않습니다.','K',1)     -- '01 Barcode Unmatch.'
                             || ' = '
                             || lvs_item_code_supplier
                             || ', '
                             || lvs_item_code_new,
             selected_date = TO_CHAR (SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
             change_date   = SYSDATE,
             ccs_yn        = 'N'
       WHERE model_name    = p_model_name
         AND line_code     = SUBSTR (p_line_code, 1, 2) --   AND machine = TRIM (SUBSTR (p_line_code, 4, 10))
         AND location_code = p_address
         AND pcb_item      = p_tobbot
         AND active_yn     = 'Y';

      BEGIN
         --------------------------------------------------------------------------------
         -- NSNP START
         --------------------------------------------------------------------------------
         p_interlock_set_nsnp_time_msg (
                                   p_line_code,
                                   1,
                                   1,
                                   p_model_name,
                                   '*',
                                   'CCS',
                                   f_msg('[CCS] 바코드의 품목이 일치하지 않습니다.','K',1) || lvs_new_barcode || ' ' || lvl_check_seq  -- '01 Barcode Unmatch.'
                                  );
      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------
      EXCEPTION
         WHEN OTHERS THEN
              NULL;
      END;

      p_return := f_msg('[CCS] 바코드의 품목이 일치하지 않습니다.','K',1);   -- '01 Barcode Unmatch.'
      
      COMMIT;    
      RETURN;
   END IF;

   ----------------------------------------------------------------------------
   -- 2016/09/12 SHS, CCS 이력 확인하여 error 처리
   ----------------------------------------------------------------------------

   IF (lvs_ccs_yn = 'Y') THEN

      p_return   := f_msg('[CCS] 이미 CCS가 완료 되었습니다.','K',1);    -- '01 Already CCS completed.'
      p_sequence := '' ;
      RETURN;

   END IF;

   phase := '16';
   -----------------------------------------------------------
   --
   -----------------------------------------------------------
   IF lvs_item_code_new = '' OR lvs_item_code_new IS NULL THEN
     
      lvl_check_seq := seq_check_seq.NEXTVAL;
      p_sequence    := lvl_check_seq;

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
                                    lot_no,
                                    item_code,
                                    smt_model_name,
                                    ng_type,
                                    enter_date,
                                    enter_by)
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                p_model_name,
                lvs_item_code_new,                            -- OUR ITEM CODE
                lvs_item_code_supplier,                  -- SUPPLIER ITEM CODE
                'E',
                f_msg('[CCS] 바코드 이력이 없습니다.','K',1),     -- '03 BARCODE NOT FOUND '
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_new_barcode,                                -- OUR BARCODE
                lvs_supplier_barcode,
                p_address,
                p_deficit,
                DECODE (SUBSTR (p_address, 1, 4), 'TRAY', 'Z', SUBSTR (p_address, 1, 1)),
                p_tobbot,
                lvs_lot_no,
                lvs_partname,
                lvs_smt_model_name,
                '*',
                sysdate,
                p_userid 
            );

      COMMIT;

      UPDATE ib_product_plandata
         SET check_status  = 'E',
             check_msg     =  f_msg('[CCS] 바코드 이력이 없습니다.','K',1)||' '||lvs_new_barcode,  -- '03 BARCODE NOT FOUND '
             selected_date = TO_CHAR (SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
             change_date   = SYSDATE,
             item_barcode  = lvs_new_barcode,
             chipname      = lvs_item_code_new,
             ccs_yn        = 'N'
       WHERE model_name    = p_model_name
         AND line_code     = SUBSTR (p_line_code, 1, 2) --  AND machine = TRIM (SUBSTR (p_line_code, 4, 10))
         AND location_code = p_address
         AND pcb_item      = p_tobbot
         AND active_yn     = 'Y';
             
      BEGIN
         --------------------------------------------------------------------------------
         -- NSNP START
         --------------------------------------------------------------------------------
         p_interlock_set_nsnp_time_msg (
                                   p_line_code,
                                   1,
                                   1,
                                   p_model_name,
                                   '*',
                                   'CCS',
                                   f_msg('[CCS] 바코드 이력이 없습니다.','K',1)     -- '01 BARCODE NOT FOUND '
                                   || ' = '
                                   || lvs_new_barcode
                                   || ', SEQ='
                                   || lvl_check_seq
                                  );
      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------
      EXCEPTION
         WHEN OTHERS THEN
              NULL;
      END;
      
      p_return :=   f_msg('[CCS] 바코드 이력이 없습니다.','K',1); -- '03 BARCODE NOT FOUND '
      COMMIT;
      RETURN;
      
   END IF;

   phase := '30';

   --------------------------------------------------
   -- CHECK SMT ADDRES
   --------------------------------------------------
   BEGIN
     
      SELECT DISTINCT model_name , smt_model_name
        INTO lvs_model_name , lvs_smt_model_name 
        FROM ib_product_plandata
       WHERE model_name = p_model_name
         AND line_code     = SUBSTR (p_line_code, 1, 2)
         AND location_code = p_address
         AND TRIM (lvs_item_code_new) LIKE '%' || item_code
         AND pcb_item      = p_tobbot
         AND active_yn     = 'Y';
         
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           lvs_model_name := '';
   END;

   phase := '40';

   IF lvs_model_name = '' OR lvs_model_name IS NULL  THEN
     
      lvl_check_seq := seq_check_seq.NEXTVAL;
      p_sequence := lvl_check_seq;

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
                                    lot_no,
                                    item_code,
                                    smt_model_name,
                                    ng_type,
                                    enter_date,
                                    enter_by)
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                p_model_name,
                lvs_item_code_new,
                lvs_item_code_supplier,
                'E',
                f_msg('[CCS] 피더레이아웃에 미등록된 품목입니다.','K',1),   -- '04 PLAN NOT FOUND'
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_new_barcode,
                lvs_supplier_barcode,
                p_address,
                p_deficit,
                DECODE (SUBSTR (p_address, 1, 4),
                        'TRAY', 'Z',
                        SUBSTR (p_address, 1, 1)),
                p_tobbot,
                lvs_lot_no,
                lvs_partname,
                lvs_smt_model_name,
                '*',
                sysdate,
                p_userid);

      COMMIT;

      ------------------------------------------------------------------------
      --
      ------------------------------------------------------------------------
      UPDATE ib_product_plandata
         SET check_status  = 'E',
             check_msg     = f_msg('[CCS] 피더레이아웃에 미등록된 품목입니다.','K',1)||' = '|| p_address || ', ' || lvs_new_barcode,  -- '04 PLAN NOT FOUND.'
             selected_date = TO_CHAR (SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
             change_date   = SYSDATE,
             item_barcode  = lvs_new_barcode,
             chipname      = lvs_item_code_new,
             ccs_yn        = 'N'
       WHERE model_name    = p_model_name
         AND line_code     = SUBSTR (p_line_code, 1, 2)
         AND location_code = p_address
         AND pcb_item      = p_tobbot
         AND active_yn     = 'Y'  ;


      BEGIN
         --------------------------------------------------------------------------------
         -- NSNP START
         --------------------------------------------------------------------------------
         p_interlock_set_nsnp_msg (
                                   p_line_code,
                                   1,
                                   p_model_name,
                                   '*',
                                   'CCS',
                                   f_msg('[CCS] 피더레이아웃에 미등록된 품목입니다.','K',1)  -- '04 PLAN NOT FOUND '
                                   || lvs_new_barcode
                                   || ' Feeder='
                                   || p_address
                                   || ' SEQ='
                                   || lvl_check_seq
                                  );
      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------
      EXCEPTION
         WHEN OTHERS THEN
              NULL;
      END;

      p_return :=   f_msg('[CCS] 피더레이아웃에 미등록된 품목입니다.','K',1);  -- '04 PLAN NOT FOUND '
      COMMIT;      
      RETURN;
      
   --------------------------------------------------------
   --
   --------------------------------------------------------
   ELSE
     
      lvi_count := 1;
      
   ----------------------------------------------------------------------------
   -- 함습자재 체크
   ----------------------------------------------------------------------------
      BEGIN
         
         SELECT COUNT(*) --A.ITEM_CODE, A.LOT_NO, FEEDING_YN, FEEDING_DATE,REEL_DESTROY_YN, MSL_MAX_TIME, ROUND(MSL_PASSED_TIME + (SYSDATE - NVL(FEEDING_DATE,SYSDATE)) * 24)
           INTO lvi_msl_over_count
           FROM IM_ITEM_RECEIPT_BARCODE A, ID_ITEM B
          WHERE A.ITEM_CODE              = B.ITEM_CODE 
            AND A.LOT_NO                 = LVS_LOT_NO
            AND F_GET_MSL_PASSED_TIME( item_barcode ) > B.MSL_MAX_TIME   --AND A.MSL_PASSED_TIME        >  B.MSL_MAX_TIME - ( (SYSDATE - NVL(FEEDING_DATE,SYSDATE)) * 24 )
            AND NVL(B.MSL_LEVEL,'1')     >= '3'
            AND NVL(FEEDING_YN,'N')      = 'N'
            AND NVL(REEL_DESTROY_YN,'N') = 'N';         
                 
      EXCEPTION
         WHEN OTHERS THEN
              lvi_msl_over_count := 0;
      END;
   
  --    IF ( lvi_msl_over_count > 0 AND 1 = 2 ) THEN
      IF ( lvi_msl_over_count > 0 ) THEN
             
            lvl_check_seq := seq_check_seq.NEXTVAL;
            p_sequence    := lvl_check_seq;      
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
                                          lot_no,
                                          item_code,
                                          smt_model_name,
                                          ng_type,
                                          enter_date,
                                          enter_by)
            VALUES (
                      SYSDATE,
                      lvl_check_seq,
                      p_plan_date,
                      p_model_name,
                      lvs_item_code_new,
                      lvs_item_code_supplier,
                      'E',
                      f_msg('[CCS] MSL 시간을 초과 되었습니다.','K',1),   -- '04 PLAN NOT FOUND'
                      p_userid,
                      SUBSTR (p_line_code, 1, 2),
                      TRIM (SUBSTR (p_line_code, 4, 10)),
                      0,
                      lvs_new_barcode,
                      lvs_supplier_barcode,
                      p_address,
                      p_deficit,
                      DECODE (SUBSTR (p_address, 1, 4),
                              'TRAY', 'Z',
                              SUBSTR (p_address, 1, 1)),
                      p_tobbot,
                      lvs_lot_no,
                      lvs_partname,
                      lvs_smt_model_name,
                      '*',
                      sysdate,
                      p_userid);

            ------------------------------------------------------------------------
            --
            ------------------------------------------------------------------------
            UPDATE ib_product_plandata
               SET check_status  = 'E',
                   check_msg     = f_msg('[CCS] MSL 시간을 초과 되었습니다.','K',1)||' = '|| p_address || ', ' || lvs_new_barcode,  -- '04 PLAN NOT FOUND.'
                   selected_date = TO_CHAR (SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
                   change_date   = SYSDATE,
                   item_barcode  = lvs_new_barcode,
                   chipname      = lvs_item_code_new,
                   ccs_yn        = 'N'
             WHERE model_name    = p_model_name
               AND line_code     = SUBSTR (p_line_code, 1, 2)
               AND location_code = p_address
               AND pcb_item      = p_tobbot
               AND active_yn     = 'Y'  ;


            BEGIN
               --------------------------------------------------------------------------------
               -- NSNP START
               --------------------------------------------------------------------------------
               p_interlock_set_nsnp_msg (
                                         p_line_code,
                                         1,
                                         p_model_name,
                                         '*',
                                         'CCS',
                                         f_msg('[CCS] MSL 시간을 초과 되었습니다.','K',1)  -- '04 PLAN NOT FOUND '
                                         || lvs_new_barcode
                                         || ' Feeder='
                                         || p_address
                                         || ' SEQ='
                                         || lvl_check_seq
                                        );
            --------------------------------------------------------------------------------
            -- NSNP END
            --------------------------------------------------------------------------------
            EXCEPTION
               WHEN OTHERS THEN
                    NULL;
            END;      
        
           p_return := F_MSG('[CCS] MSL 시간을 초과 되었습니다.', 'K', 1);
           p_sequence := '';
           
           COMMIT;
           RETURN;
         
       END IF;

      --------------------------------------------------
      -- CHECK AREAY CHECK
      --------------------------------------------------
      BEGIN
        
         SELECT COUNT (*)
           INTO lvs_check_count
           FROM ib_product_plandata
          WHERE model_name    = p_model_name
            AND line_code     = SUBSTR (p_line_code, 1, 2)
            AND location_code = p_address
            AND TRIM (lvs_item_code_new) LIKE '%' || ITEM_CODE
            AND pcb_item      = p_tobbot
            AND check_yn      = 'Y'
            AND check_status  = 'P'
            AND active_yn     = 'Y';
            
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvs_check_count := 0;
      END;


      IF lvs_check_count > 0 THEN
        
         p_return := F_MSG('[CCS] 이미 체크된 자재 입니다', 'K', 1);
         p_sequence := '';
         RETURN;
         
      ELSE
        
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
                                       smt_model_name,
                                       ng_type,
                                       run_no,
                                       enter_date,
                                       enter_by)
         VALUES (
                   SYSDATE,
                   lvl_check_seq,
                   p_plan_date,
                   p_model_name,
                   lvs_item_code_new,
                   lvs_item_code_supplier,
                   'P',
                   'OK',
                   p_userid,
                   SUBSTR (p_line_code, 1, 2),
                   TRIM (SUBSTR (p_line_code, 4, 10)),
                   0,
                   lvs_new_barcode,
                   lvs_supplier_barcode,
                   p_address,
                   p_deficit,
                   DECODE (SUBSTR (p_address, 1, 4), 'TRAY', 'Z', SUBSTR (p_address, 1, 1)),
                   p_tobbot,
                   lvs_lot_no,
                   lvs_partname,
                   p_origin_barcode,
                   p_barcode,
                   lvdt_valid_date,
                   lvs_lot_serial,
                   lvs_trace_code,
                   lvl_item_qty,
                   lvs_vendor_name,
                   lvdt_inspect_date,
                   lvs_smt_model_name,
                   '*',
                   lvs_run_no,
                   sysdate,
                   p_userid
                );
                
      END IF;

      ----------------------------------------------------------------------
      --이미 걸려 있던 거면 피딩 수량을 증가 하지 않는다.
      ----------------------------------------------------------------------
      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_lot_count
           FROM ib_product_plandata
          WHERE model_name    = p_model_name
            AND line_code     = SUBSTR (p_line_code, 1, 2)
            AND location_code = p_address
            AND TRIM (lvs_item_code_new) LIKE '%' || ITEM_CODE
            AND check_yn      = 'Y'
            AND check_status  = 'P'
            AND pcb_item      = p_tobbot
            AND active_yn     = 'Y';
                
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_lot_count := 0;
      END;

      -------------------------------------------------------------------------------
      -- 
      -------------------------------------------------------------------------------
      IF lvi_lot_count > 0 THEN
         NULL;
      ELSE
        
         UPDATE ib_product_plandata
            SET check_status       = 'P',
                check_yn           = 'Y',
                check_msg          = 'OK',
                selected_date      = TO_CHAR (SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
                item_barcode       = lvs_new_barcode,
                chipname           = lvs_item_code_new,                  -- SCAN PART NO
                supplier_barcode   = lvs_supplier_barcode,
                feeding_qty        = NVL (feeding_qty, 0) + lvl_item_qty,
                change_date        = SYSDATE,                            -- MSL CHECK
                lot_no             = f_get_lot_no_from_barcode (lvs_new_barcode),
                feeding_count      = 1,
                our_barcode_origin = p_barcode
          WHERE model_name         = p_model_name
            AND line_code          = SUBSTR (p_line_code, 1, 2)
            AND location_code      = p_address
            AND pcb_item           = p_tobbot
            AND active_yn          = 'Y';

         -------------------------------------------------------------
         -- FEEDING DATE / MSL OPEN DATE
         -- 신규 스캔 수량에 업데이트
         -- 회수 시점에서 new_scan_qty 에 잔량 업데이트
         -------------------------------------------------------------
         UPDATE im_item_receipt_barcode
            SET feeding_date  = SYSDATE,
                feeding_model = p_model_name,
                feeding_yn    = 'Y',
                MSL_OPEN_DATE = decode(MSL_OPEN_DATE, null, sysdate, MSL_OPEN_DATE)
          WHERE  lot_no       = f_get_lot_no_from_barcode (lvs_new_barcode);
          
      END IF;

      COMMIT;
      
      
      ---------------------------------------------------------------
      -- 레이아웃에 문제 로케이션 있는지 판단해서 해제 해줌 
      ---------------------------------------------------------------
       BEGIN
         
            SELECT NVL(COUNT(CONFIG_VALUE),0)  
              INTO lvi_row_count
              FROM ISYS_CONFIG      
             WHERE CONFIG_NAME     = 'NSNP_UNLCOK_BY_ACTION'  
               AND CONFIG_VALUE    = 'Y'
               AND ORGANIZATION_ID = 1 ;
        
        EXCEPTION 
           WHEN NO_DATA_FOUND THEN 
                lvi_row_count := 0 ;
       END ;
        
      ------------------------------------------------------------------
      -- 매스캔시 잠금 해제 조건이면 
      ------------------------------------------------------------------
       IF nvl(lvi_row_count,0) > 0 THEN 
        
              BEGIN
                
               SELECT COUNT(*)
                 INTO lvl_ng_location_count
                 FROM ib_product_plandata
                WHERE model_name   = p_model_name
                  AND line_code    = SUBSTR (p_line_code, 1, 2)
                  AND active_yn    = 'Y'
                  AND pcb_item     = p_tobbot
                  AND check_status = 'E';
                      
              EXCEPTION  
                 WHEN NO_DATA_FOUND  THEN
                      lvl_ng_location_count := 0 ;
              END;  
              
              -------------------------------------------------------
              -- 현제 라인이 잠근 상태인지 체크
              -- 중복으로 해제 신호를 안보내기 위해 
              -------------------------------------------------------
              BEGIN  
                
                SELECT COUNT(*) 
                  INTO lvi_line_nsnp_count 
                  FROM ip_product_line
                 WHERE line_code    = SUBSTR (p_line_code, 1, 2)
                   AND nsnp_status LIKE 'ON%';
                   
              EXCEPTION 
                 WHEN NO_DATA_FOUND  THEN
                      lvi_line_nsnp_count := 0 ;
              END;  
              
              -----------------------------------------------------------
              -- 기존에 잠겨있었는지 체크해서 문제가 해결 되었고 그리고 잠겨있었으면 
              -- 해제해줌 
              -----------------------------------------------------------
                IF nvl(lvl_ng_location_count,0) = 0 and nvl(lvi_line_nsnp_count,0) > 0 THEN 
                  
                    BEGIN
                        --------------------------------------------------------------------------------
                        -- NSNP START
                        --------------------------------------------------------------------------------
                        p_interlock_set_nsnp_time_msg (
                                                       substr(p_line_code,1,2),
                                                       0, --action code
                                                       0, -- time
                                                       p_model_name,
                                                       '*', -- suffix 
                                                       'UNLOCK', -- reason
                                                       'CCS AUTO UNLOCK' 
                                                      ); --error message
                     --------------------------------------------------------------------------------
                     -- NSNP END
                     --------------------------------------------------------------------------------
                     EXCEPTION
                        WHEN OTHERS THEN
                             NULL;
                     END;              

                END IF  ;
      
       END IF ;         
  
   END IF;

   phase := '110';
   
   --------------------------------------------------
   -- CHECK SMT ADDRES OK
   --------------------------------------------------

   IF lvi_count > 0  THEN  
      p_return := 'OK';
      RETURN;
   ELSIF lvi_count < 1  THEN
      p_return := f_msg('[CCS] 피더레이아웃에 미등록된 품목입니다.', 'K', 1);   -- '05 FEEDER LAYOUT NOT FOUND '
      RETURN;
   END IF;
   
EXCEPTION
   WHEN OTHERS THEN
        raise_application_error (
                                 -20003,
                                 'NG, [CCS] Phase='
                                 || phase
                                 || '  Sup Bcd='
                                 || lvs_supplier_barcode
                                 || ' Our BCD='
                                 || lvs_new_barcode
                                 || ' '
                                 || SQLERRM
                                );
END;
