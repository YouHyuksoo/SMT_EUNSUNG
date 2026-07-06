CREATE OR REPLACE PROCEDURE "P_CHECK_FULL_SCAN_LOCK" (
  /* ================================================================
   * 프로시저명  : P_CHECK_FULL_SCAN_LOCK
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건을 기준으로 업무 데이터의 유효성 또는 상태를 확인한다.
   *   조회 결과와 원본 분기 조건에 따라 OUT 파라미터 또는 상태 값을 설정한다.
   *   호출부가 결과 코드와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_PLAN_DATE - 원본 선언부 기준 입력/출력 파라미터
   *   P_MODEL_NAME - 원본 선언부 기준 입력/출력 파라미터
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_TABLE_ID - 원본 선언부 기준 입력/출력 파라미터
   *   P_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_DEFICIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_USERID - 원본 선언부 기준 입력/출력 파라미터
   *   P_RETURN - 원본 선언부 기준 입력/출력 파라미터
   *   P_SEQUENCE - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 원본 로직 참조 테이블
   *   IB_SMT_CHECKHIST - 원본 로직 참조 테이블
   *   IB_SMT_FULLCHECK_TIME - 원본 로직 참조 테이블
   *   IP_PRODUCT_LINE - Product Line Master
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_ITEM_CODE_FROM_BARCODE
   *   F_GET_LOT_NO_FROM_BARCODE
   *   F_GET_PREPARE_BARCODE
   *   F_MSG
   *   P_INTERLOCK_SET_NSNP_MSG
   *   P_INTERLOCK_SET_NSNP_TIME_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_FULL_SCAN_LOCK(...)
   * ================================================================ */
   p_plan_date    IN     VARCHAR2,
   p_model_name   IN     VARCHAR2,
   p_line_code    IN     VARCHAR2,
   p_table_id     IN     VARCHAR2,
   p_barcode      IN     VARCHAR2,
   p_deficit      IN     VARCHAR2,
   p_userid       IN     VARCHAR2,
   p_return          OUT VARCHAR2,
   p_sequence OUT  VARCHAR2)
IS
   -------------------------------------------------------
   -- PLAN DATE FORMAT : YYYYMMDD
   -- p_deficit : 3 = NORMAL , 4 = CANCEL
   -- RETURN : OK , OTHERS : ERROR
   -- BARCODE STATUS : 0 = PRINT , 1 = RECEIPT , 2 = ISSUE
   -------------------------------------------------------
   lvs_barcode_status        VARCHAR2 (1); -- [AI] 내부 처리용 변수
   lvs_partname              VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_item_code_new         VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvi_count                 NUMBER; -- [AI] 내부 처리용 변수
   lvl_item_qty              NUMBER; -- [AI] 내부 처리용 변수
   lvi_no_ccs                NUMBER; -- [AI] 내부 처리용 변수
   lvs_model_name            VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_receipt_compare_yn    VARCHAR2 (1); -- [AI] 내부 처리용 변수
   lvs_issue_compare_yn      VARCHAR2 (1); -- [AI] 내부 처리용 변수
   lvs_holding_yn            VARCHAR2 (1); -- [AI] 내부 처리용 변수
   phase                     VARCHAR2 (10); -- [AI] 내부 처리용 변수
   lvs_inventory_hold        VARCHAR2 (1); -- [AI] 내부 처리용 변수
   lvs_lot_no                VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvl_first                 NUMBER; -- [AI] 내부 처리용 변수
   lvl_second                NUMBER; -- [AI] 내부 처리용 변수
   lvl_first_origin          NUMBER; -- [AI] 내부 처리용 변수
   lvl_second_origin         NUMBER; -- [AI] 내부 처리용 변수
   lvi_lot_count             NUMBER; -- [AI] 내부 처리용 변수
   lvs_table_id              VARCHAR2 (10); -- [AI] 내부 처리용 변수
   lvs_barcode               VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvl_check_seq             NUMBER; -- [AI] 내부 처리용 변수
   lvs_check_location_code   VARCHAR2 (10); -- [AI] 내부 처리용 변수
   lvl_check_count           NUMBER; -- [AI] 내부 처리용 변수
   lvs_topbot                VARCHAR2 (10); -- [AI] 내부 처리용 변수
   lvs_new_barcode_status    VARCHAR2 (1); -- [AI] 내부 처리용 변수

   lvs_no_css_address        VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvdt_valid_date           DATE; -- [AI] 내부 처리용 변수
   lvs_lot_serial            VARCHAR2 (10); -- [AI] 내부 처리용 변수
   lvs_trace_code            VARCHAR2 (30); -- [AI] 내부 처리용 변수

   LVI_COUNT_NG              NUMBER; -- [AI] 내부 처리용 변수
   LVL_TIME_TERM             NUMBER := 1 ; --300000; -- [AI] 내부 처리용 변수
   lvi_msl_over_count        NUMBER; -- [AI] 내부 처리용 변수
 lvi_aready_exists number ; -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
   phase := '10';


   lvs_barcode := f_get_prepare_barcode (p_barcode);

   -----------------------------------------------------------------------------
   --
   -----------------------------------------------------------------------------

   phase := '11';

   IF LENGTH (lvs_barcode) < 10 or instr( lvs_barcode , '@' , 1 ) > 0  or instr( lvs_barcode , '---' , 1 ) > 0 THEN
      p_return :=  f_msg('[FULL LOCK] 바코드 규격이 틀립니다.','K',1)   --  '00 Barcode Spec Invalid'
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
    WHERE model_name = p_model_name
      AND line_code  = SUBSTR (p_line_code, 1, 2)
      AND table_id   = p_table_id
      AND NVL (full_check_yn, 'N') = 'N'
      AND ccs_yn     = 'Y'
      AND active_yn  = 'Y'
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
    WHERE model_name    = p_model_name
      AND line_code     = SUBSTR (p_line_code, 1, 2)
      AND table_id      = p_table_id
      AND location_code = lvs_check_location_code
      AND lvs_item_code_new LIKE '%' || ITEM_CODE
      AND NVL (full_check_yn, 'N') = 'N'
      AND ccs_yn        = 'Y'
      AND active_yn     = 'Y';

   phase := '30';

   --------------------------------------------------
   -- CHECK  PLAN DATA WITH NEW ADDRES
   --------------------------------------------------
   BEGIN
     
      SELECT DISTINCT model_name
        INTO lvs_model_name
        FROM ib_product_plandata
       WHERE model_name    = p_model_name
         AND line_code     = SUBSTR (p_line_code, 1, 2)
         AND location_code = lvs_check_location_code
         AND TRIM (lvs_item_code_new) LIKE '%' || ITEM_CODE
         AND ccs_yn        = 'Y'
        AND active_yn      = 'Y';
        
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND THEN
           lvs_model_name := '';
   END;

   ---------------------------------------------------------------------------
   -- PARTNAME SELECT
   ---------------------------------------------------------------------------
   BEGIN
     
      SELECT item_code
        INTO lvs_partname
        FROM ib_product_plandata
       WHERE model_name    = p_model_name
         AND line_code     = SUBSTR (p_line_code, 1, 2)
         AND location_code = lvs_check_location_code
         AND pcb_item      = lvs_topbot
         AND active_yn     = 'Y'
         AND replace_yn    = 'N';
         
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND THEN
         NULL;
   END;

   --------------------------------------------------------------------------------
   -- ccs 여부체크 
   --------------------------------------------------------------------------------
   
       BEGIN
         
           SELECT COUNT  (*), MAX(location_code)
             INTO lvi_no_ccs, lvs_no_css_address
             FROM ib_product_plandata
            WHERE model_name  = p_model_name
              AND line_code  = SUBSTR (p_line_code, 1, 2)
              AND pcb_item   = lvs_topbot
              AND active_yn  = 'Y'
              AND ccs_yn     = 'N';
              
       EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
           WHEN NO_DATA_FOUND THEN
                lvi_no_ccs := 0;
       END;
       
           IF lvi_no_ccs > 0 OR lvi_no_ccs is null  THEN
             
               p_return := f_msg('[FULL LOCK] CCS가 완료되지 않았습니다.','K',1)  -- '00 CSS NOT COMPLETED'
                           ||' = '
                           ||lvs_no_css_address;
               
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
                                                     'FULL CHECK',
                                                     f_msg('[FULL LOCK] CCS가 완료되지 않았습니다.','K',1)   -- '00 CSS NOT COMPLETED '
                                                   );
                  --------------------------------------------------------------------------------
                  -- NSNP END
                  --------------------------------------------------------------------------------
                  EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
                     WHEN OTHERS THEN
                          NULL;
                  END;
                  
                return ;
                
           END IF ;
           
--   -----------------------------------------------------------
--   --
--   -----------------------------------------------------------
--   IF lvs_item_code_new = '' OR lvs_item_code_new IS NULL
--   THEN
--
--        lvl_check_seq := seq_check_seq.NEXTVAL;
--        p_sequence := lvl_check_seq;
--      
--      ---------------------------------------------------
--      --  SMT PDA MATERIAL POSITION check history insert
--      ---------------------------------------------------
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
--                                    location_code,
--                                    check_type,
--                                    table_id,
--                                    pcb_item,
--                                    lot_no,
--                                    item_code)
--      VALUES (
--                SYSDATE,
--                lvl_check_seq,
--                p_plan_date,
--                UPPER (p_model_name),
--                lvs_item_code_new,                            -- OUR ITEM CODE
--                lvs_item_code_new,                       -- SUPPLIER ITEM CODE
--                'E',
--                f_msg('03 Feeder Layout Notfound','C',1),
--                p_userid,
--                SUBSTR (p_line_code, 1, 2),
--                TRIM (SUBSTR (p_line_code, 4, 10)),
--                0,
--                lvs_barcode,                                    -- OUR BARCODE
--                lvs_check_location_code,
--                p_deficit,
--                DECODE (SUBSTR (lvs_check_location_code, 1, 4),
--                        'TRAY', 'Z',
--                        SUBSTR (lvs_check_location_code, 1, 1)),
--                lvs_topbot,
--                lvs_lot_no,
--                lvs_partname);
--
--      UPDATE ib_product_plandata
--         SET check_status = 'E',
--             check_msg =
--                f_msg('03 Feeder Layout Notfound. ','C',1) || lvs_barcode,
--             full_check_time = SYSDATE
--       WHERE     model_name = UPPER (p_model_name)
--             AND line_code = SUBSTR (p_line_code, 1, 2)
--             AND location_code = lvs_check_location_code
--             AND ccs_yn = 'Y'
--             AND active_yn = 'Y';
--
--      BEGIN
--         --------------------------------------------------------------------------------
--         -- NSNP START
--         --------------------------------------------------------------------------------
--         p_interlock_set_nsnp_msg (
--            p_line_code,
--            1,
--            p_model_name,
--            '*',
--            'FULL CHECK',
--            f_msg('03 Feeder Layout Notfound ','C',1) || lvs_barcode || ' ' || lvl_check_seq);
--      --------------------------------------------------------------------------------
--      -- NSNP END
--      --------------------------------------------------------------------------------
--      EXCEPTION
--         WHEN OTHERS
--         THEN
--            NULL;
--      END;
--
--      p_return := f_msg('03 Feeder Layout Notfound. ','C',1) || lvs_barcode;
--      p_sequence :=  '0' ;
--      COMMIT;
--      RETURN;
--   END IF;
   phase := '40';
   ----------------------------------------------------------------------------
   -- 함습자재 체크
   ----------------------------------------------------------------------------

   SELECT COUNT (*)
     INTO lvi_msl_over_count
     FROM ib_product_plandata a, id_item b, im_item_receipt_barcode c
    WHERE a.item_code = b.item_code
      AND a.item_code = c.item_code(+)
      AND a.lot_no    = c.lot_no(+)
      AND TRUNC (
                 ( (SYSDATE - a.change_date) * 24
                  + NVL (c.msl_passed_time, 0))
                 / b.msl_max_time
                 * 100,
                 2) >= 100
      AND a.active_yn             = 'Y'
      AND b.msl_level             IS NOT NULL
      AND NVL (b.msl_max_time, 0) <> 0
      AND NVL(B.MSL_LEVEL,'1')    >= '3'
      AND a.line_code             = SUBSTR (p_line_code, 1, 2)
      AND A.LOCATION_CODE         = lvs_check_location_code;

   IF lvi_msl_over_count > 0 AND 1 = 2
   THEN
      lvl_check_seq := seq_check_seq.NEXTVAL;
      p_sequence :=  '0' ;
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
                                    ng_type,
                                    enter_date,
                                    enter_by
                                    )
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                p_model_name,
                lvs_item_code_new,
                lvs_item_code_new,
                'E',
                f_msg('[FULL LOCK] MSL 시간을 초과 했습니다.','K',1),  -- '06 MSL Time Over.(FULL)'
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_barcode,
                lvs_check_location_code,
                p_deficit,
                DECODE (SUBSTR (lvs_check_location_code, 1, 4),'TRAY', 'Z',SUBSTR (lvs_check_location_code, 1, 1)),
                lvs_topbot,
                lvs_lot_no,
                lvs_partname,
                '*' ,
                '*',
                sysdate,
                p_userid
              );

      ------------------------------------------------------------------------
      --
      ------------------------------------------------------------------------
      UPDATE ib_product_plandata
         SET check_status    = 'E',
             check_msg       =  f_msg('[FULL LOCK] MSL 시간을 초과 했습니다.','K',1)  -- '06 MSL Time Over.(FULL) '
                                || ' = '
                                || lvs_barcode,
             full_check_time = SYSDATE,
             full_check_yn   = 'N'
       WHERE  model_name   = p_model_name
         AND line_code     = SUBSTR (p_line_code, 1, 2)
         AND location_code = lvs_check_location_code
         AND item_code     = TRIM (lvs_item_code_new)
         AND ccs_yn        = 'Y'
         AND active_yn     = 'Y';

      --------------------------------------------------------------------------------
      -- NSNP START
      -- 
      --------------------------------------------------------------------------------

      BEGIN
        
         p_interlock_set_nsnp_time_msg (
                                         p_line_code,
                                         1,
                                         LVL_TIME_TERM,
                                         p_model_name,
                                         '*',
                                         'FULL CHECK',
                                         f_msg('[FULL LOCK] MSL 시간을 초과 했습니다.','K',1)   -- '06 MSL Time Over.(FULL) '
                                         || ' = '
                                         || lvs_barcode
                                         || ', '
                                         || lvl_check_seq
                                       );
            
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS THEN
              NULL;
      END;

      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------
      p_return := f_msg('[FULL LOCK] MSL 시간을 초과 했습니다.','K',1)  -- '06 MSL Time Over.(FULL) '
                  || ' = '
                  || lvs_barcode;
      COMMIT;
      RETURN;
      
   END IF;
   
   
   ---------------------------------------------------------------------------
   --  이미 장착된 자재인지 체크 
   ---------------------------------------------------------------------------
   BEGIN
     
      SELECT count(*)
        INTO lvi_aready_exists
        FROM ib_product_plandata
       WHERE model_name    = p_model_name
         AND line_code     = SUBSTR (p_line_code, 1, 2)
         AND pcb_item      = lvs_topbot
         AND lot_no        = lvs_lot_no
         AND active_yn     = 'Y'
         AND FULL_CHECK_YN = 'Y'
         AND ROWNUM        = 1 ;
             
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND THEN
           NULL;
   END;


  IF nvl(lvi_aready_exists,0) > 0  then 
         p_return := f_msg('[FULL LOCK] 이미 장착된 바코드 입니다.','K',1)  -- 'Aready Used Barcode '
                     || ' = '
                     || lvs_barcode;
         RETURN; 
  END IF ;   
   
-------------------------------------------------------------------------------
-- CHECK AREAY CHECK
-- 기존에 체크한 자재와 동일한지 체크
-------------------------------------------------------------------------------

   BEGIN
     
      lvl_check_count := 0 ;
      SELECT COUNT (*)
        INTO lvl_check_count
        FROM ib_product_plandata
       WHERE model_name    = p_model_name
         AND line_code     = SUBSTR (p_line_code, 1, 2)
         AND location_code = lvs_check_location_code
   --      AND item_code     = TRIM (lvs_item_code_new)
         AND lot_no        = LVS_LOT_NO
         AND pcb_item      = lvs_topbot
         AND check_yn      = 'Y'
     --    AND check_status  = 'P'
         AND active_yn     = 'Y';
             
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND THEN
           lvl_check_count := 0;
   END;
   ----------------------------------------------------------
   -- 활성화 되어 있는 현재 라인에  이전에 검사에 성공한 이력이 있으면 
   ----------------------------------------------------------
   IF NVL(lvl_check_count,0) >= 1 THEN
        NULL ;
   ELSE
   
      --------------------------------------------------------------------------------
      -- NSNP START
      -- 
      --------------------------------------------------------------------------------

      BEGIN
        
         p_interlock_set_nsnp_time_msg (
                                         p_line_code,
                                         1,
                                         LVL_TIME_TERM,
                                         p_model_name,
                                         '*',
                                         'FULL CHECK',
                                         f_msg('[FULL LOCK] 자재가 바뀌었습니다, 장착불가.','K',1)    -- 'Full Check NG : Item changed '
                                         || ' = '
                                         || lvs_barcode
                                         || ', '
                                         || lvl_check_seq
                                       );
            
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS THEN
              NULL;
      END;
  
      p_return := f_msg('[FULL LOCK] 자재가 바뀌었습니다, 장착불가.','K',1)  -- 'Full Check NG : Item changed '
                  || ' = '
                  || lvs_check_location_code
                  || ', '
                  || LVS_LOT_NO ;
      RETURN;
      
   END IF;
   
   
   IF lvs_model_name = '' OR lvs_model_name IS NULL THEN
     
--      lvl_check_seq := seq_check_seq.NEXTVAL;
--      p_sequence :=  '0' ;

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
                                    location_code,
                                    check_type,
                                    table_id,
                                    pcb_item,
                                    lot_no,
                                    item_code,
                                    smt_model_name,
                                    ng_type,
                                    enter_date,
                                    enter_by
                                    )
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                p_model_name,
                lvs_item_code_new,
                lvs_item_code_new,
                'E',
                f_msg('[FULL LOCK] 피더레이아웃에 미등록 자재입니다.','K',1),    -- '04 Feeder Layout Notfound.(FULL)'
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
                '*',
                sysdate,
                p_userid);

      ------------------------------------------------------------------------
      --
      ------------------------------------------------------------------------
      UPDATE ib_product_plandata
         SET check_status    = 'E',
             check_msg       = f_msg('[FULL LOCK] 피더레이아웃에 미등록 자재입니다.','K',1)    -- '04 Feeder Layout Notfound.(FULL)'
                               || ' = '
                               || lvs_barcode,
             full_check_time = SYSDATE,
             full_check_yn   = 'N'
       --item_barcode = lvs_barcode
       WHERE     model_name    = p_model_name
             AND line_code     = SUBSTR (p_line_code, 1, 2)
             AND location_code = lvs_check_location_code
             AND TRIM (lvs_item_code_new) LIKE '%' || item_code
             AND ccs_yn        = 'Y'
             AND active_yn     = 'Y';


              --------------------------------------------------------------------------------
              -- NSNP START
              --------------------------------------------------------------------------------
               p_interlock_set_nsnp_time_msg (
                                              p_line_code, 
                                              1 , 
                                              0 ,
                                              p_model_name , 
                                              '*' , 
                                              'FULL CHECK' , 
                                              f_msg('[FULL LOCK] 피더레이아웃에 미등록 자재입니다.','K',1)    -- '04 Feeder Layout Notfound.(FULL)'
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

      p_return := f_msg('[FULL LOCK] 피더레이아웃에 미등록 자재입니다.','K',1)    -- '04 Feeder Layout Notfound.(FULL)'
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
      lvi_count     := 1;

      lvl_check_seq := seq_check_seq.NEXTVAL;
      p_sequence    :=  '0' ;
      
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
                                    ng_type,
                                    enter_date,
                                    enter_by
                                    ) 
                                    
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                p_model_name,
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
                '*',
                sysdate,
                p_userid);

      -----------------------------------------------------------------------
      --
      -----------------------------------------------------------------------

      UPDATE ib_product_plandata
         SET check_status    = 'P',
             check_msg       = 'OK',
             full_check_time = SYSDATE,
             full_check_yn   = 'Y'
       WHERE model_name      = p_model_name
         AND line_code       = SUBSTR (p_line_code, 1, 2)
         AND location_code   = lvs_check_location_code
         AND ccs_yn          = 'Y'
             -- AND item_code = TRIM (lvs_item_code_new)
         AND active_yn       = 'Y';

      COMMIT;
      
   END IF;

   -----------------------------------------------------
   -- 이미 잠겨 있을경우에만 풀어준
   -----------------------------------------------------
   LVI_COUNT_NG := 0;

   SELECT COUNT (*)
     INTO LVI_COUNT_NG
     FROM IP_PRODUCT_LINE
    WHERE LINE_CODE                  = SUBSTR (p_line_code, 1, 2)
      AND SUBSTR (NSNP_STATUS, 1, 2) = 'ON'
      AND NSNP_LOCK_TYPE             = 'FULL CHECK';

   IF LVI_COUNT_NG > 0
   THEN
      ---------------------------------------------------------------------
      -- 스캔을 시작하면
      -- 현재 라인이 검사중인거로 설정한다.
      ---------------------------------------------------------------------
      UPDATE IB_SMT_FULLCHECK_TIME
         SET CHECK_YN = 'Y', 
             CHECK_DATE = SYSDATE                  -- 검사한거로 체크
       WHERE LINE_CODE = SUBSTR (p_line_code, 1, 2) 
         AND CHECK_YN = 'N';

      --------------------------------------------------------------------------------
      -- 해제 해준다
      -- 풀체트 타임 테이블에 정보를 업데이트 한다 .
      --------------------------------------------------------------------------------

      --------------------------------------------------------------------------------
      BEGIN
        
  --    IF nvl(lvl_ng_location_count,0) = 0 and nvl(lvi_line_nsnp_count,0) > 0 THEN 
        
         -----------------------------------------------------------------------------
         -- NSNP START
         -----------------------------------------------------------------------------
         p_interlock_set_nsnp_time_msg (
                                        p_line_code,
                                        0,
                                        0,
                                        p_model_name,
                                        '*',
                                       'UNLOCK',
                                       'FULL CHECK NG UNLOCK ' || lvl_check_seq
                                       );
      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------
      
   --   end if;
      
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS THEN
              NULL;
      END;
      
   ELSE
      ---------------------------------------------------------------------
      -- 스캔을 시작하면
      -- 현재 라인이 검사중인거로 설정한다.
      ---------------------------------------------------------------------
      UPDATE IB_SMT_FULLCHECK_TIME
         SET CHECK_YN   = 'Y', 
             CHECK_DATE = SYSDATE                  -- 검사한거로 체크
       WHERE LINE_CODE  = SUBSTR (p_line_code, 1, 2)
         AND CHECK_YN   = 'N';
       
   END IF;

   COMMIT;

   phase := '110';

   --------------------------------------------------
   -- CHECK SMT ADDRES OK
   --------------------------------------------------

   IF lvi_count > 0 THEN
      p_return   :=  'OK';
      p_sequence :=  '0' ;
      RETURN;
   ELSIF lvi_count < 1 THEN
      p_return   := f_msg('[FULL LOCK] 피더레이아웃에 미등록 자재입니다.','K',1) ;    -- '05 Feeder Layout Notfound. '
      p_sequence :=  '0' ;
      RETURN;
   END IF;
   
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS THEN
        raise_application_error (-20003, 'NG, [FULL LOCK] Phase=' || phase || '  ' || SQLERRM);
END;
