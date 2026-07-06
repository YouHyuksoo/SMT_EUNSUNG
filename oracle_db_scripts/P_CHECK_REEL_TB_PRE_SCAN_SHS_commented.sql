CREATE OR REPLACE PROCEDURE "P_CHECK_REEL_TB_PRE_SCAN_SHS" (
  /* ================================================================
   * 프로시저명  : P_CHECK_REEL_TB_PRE_SCAN_SHS
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
   *   P_TOPBOT - 원본 선언부 기준 입력/출력 파라미터
   *   P_ADDRESS - 원본 선언부 기준 입력/출력 파라미터
   *   P_OLD_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_USERID - 원본 선언부 기준 입력/출력 파라미터
   *   P_DEFICIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_RETURN - 원본 선언부 기준 입력/출력 파라미터
   *   P_SEQUENCE - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 원본 로직 참조 테이블
   *   IB_SMT_CHECKHIST - 원본 로직 참조 테이블
   *   ID_ITEM - Item Master
   *   IM_ITEM_RECEIPT_BARCODE - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   FOUND
   *   F_GET_ITEM_CODE_FROM_BARCODE
   *   F_GET_LOT_NO_FROM_BARCODE
   *   F_GET_LOT_QTY_FROM_BARCODE
   *   F_GET_PREPARE_BARCODE
   *   F_MSG
   *   P_INTERLOCK_SET_NSNP_TIME_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_REEL_TB_PRE_SCAN_SHS(...)
   * ================================================================ */
   p_plan_date     IN     VARCHAR2,
   p_model_name    IN     VARCHAR2,
   p_line_code     IN     VARCHAR2,
   p_topbot        IN     VARCHAR2,
   p_address       IN     VARCHAR2,
   p_old_barcode   IN     VARCHAR2,
   p_userid        IN     VARCHAR2,
   p_deficit       IN     VARCHAR2,
   p_return           OUT VARCHAR2,
   p_sequence         OUT VARCHAR2)
IS
   -------------------------------------------------------
   -- PLAN DATE FORMAT : YYYYMMDD
   -- p_deficit : 3 = NORMAL , 4 = CANCEL
   -- RETURN : OK , OTHERS : ERROR
   -- BARCODE STATUS : 0 = PRINT , 1 = RECEIPT , 2 = ISSUE
   -------------------------------------------------------
   lvi_count                   NUMBER; -- [AI] 내부 처리용 변수
   lvi_lot_count               NUMBER; -- [AI] 내부 처리용 변수
   lvi_replace                 NUMBER; -- [AI] 내부 처리용 변수
   lvi_no_ccs                  NUMBER; -- [AI] 내부 처리용 변수
   lvs_partname                VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvi_last_lot_no             NUMBER; -- [AI] 내부 처리용 변수

   lvs_new_barcode_status      VARCHAR2 (1); -- [AI] 내부 처리용 변수

   lvs_item_code_old           VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_item_code_old_replace   VARCHAR2 (50); -- [AI] 내부 처리용 변수

   lvl_item_qty                NUMBER; -- [AI] 내부 처리용 변수
   lvs_model_name              VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_receipt_compare_yn      VARCHAR2 (1); -- [AI] 내부 처리용 변수
   lvs_issue_compare_yn        VARCHAR2 (1); -- [AI] 내부 처리용 변수
   lvs_holding_yn              VARCHAR2 (1); -- [AI] 내부 처리용 변수

   lvs_inventory_hold          VARCHAR2 (1); -- [AI] 내부 처리용 변수
   lvs_lot_no                  VARCHAR2 (30); -- [AI] 내부 처리용 변수


   lvl_first_origin            NUMBER; -- [AI] 내부 처리용 변수
   lvl_second_origin           NUMBER; -- [AI] 내부 처리용 변수

   lvs_old_barcode             VARCHAR2 (50); -- [AI] 내부 처리용 변수


   phase                       VARCHAR2 (10); -- [AI] 내부 처리용 변수

   lvl_check_seq               NUMBER; -- [AI] 내부 처리용 변수

   lvs_no_css_address          VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_label_type              VARCHAR2 (10); -- [AI] 내부 처리용 변수

   lvs_item_code_replace       VARCHAR2 (30); -- [AI] 내부 처리용 변수
   LVI_BLOCKED_CHECK           NUMBER; -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
   phase := '10';

   --------------------------------------------------------------------------------
   --
   --------------------------------------------------------------------------------

    lvs_old_barcode := f_get_prepare_barcode (p_old_barcode);
  
   ----------------------------------------------------------------------------
   --
   ----------------------------------------------------------------------------
   IF LENGTH (lvs_old_barcode) < 20
   THEN                            
      p_return := f_msg('[REEL PRE] 잘못된 바코드 입니다.','K',1)   -- '[REEL PRE] Barcode Invalid.'
                  || ' = '
                  || lvs_old_barcode;  
      RETURN;
   END IF;

   phase := '11';
   --------------------------------------------------------------------------------
   -- 품목코드 추출 
   --------------------------------------------------------------------------------
   lvs_item_code_old := f_get_item_code_from_barcode (lvs_old_barcode);

--   ----------------------------------------------------------------------------------
--   -- 릴변경 안됨 체크
--   ----------------------------------------------------------------------------------
--   BEGIN
--      SELECT COUNT (*)
--        INTO LVI_BLOCKED_CHECK
--        FROM ID_ITEM
--       WHERE ITEM_CODE = lvs_item_code_old AND REEL_CHANGE_BLOCKED = 'Y';
--   EXCEPTION
--      WHEN OTHERS
--      THEN
--         NULL;
--   END;
--
--   IF LVI_BLOCKED_CHECK > 0
--   THEN
--      lvl_check_seq := seq_check_seq.NEXTVAL;
--      p_sequence := lvl_check_seq;
--      p_return :=
--         f_msg('[REEL PRE] Materials that should not be changed','C',1) -- 릴변경을 하면 안되는 자재 입니다.'
--         || lvs_old_barcode;
--   END IF;

   ----------------------------------------------------------------------------------
   -- REPLACE SUPPLIER ITEM CODE
   ----------------------------------------------------------------------------------
   BEGIN
      SELECT MAX (item_code)
        INTO lvs_item_code_replace
        FROM id_item
       WHERE    item_code = lvs_item_code_old
             OR part_no = lvs_item_code_old
             OR item_code = SUBSTR (lvs_item_code_old, 1, LENGTH (item_code))
             OR part_no = SUBSTR (lvs_item_code_old, 1, LENGTH (part_no));
   --     part_no = lvs_item_code_old;
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         lvs_item_code_replace := '*';
   END;

   phase := '13';

   ----------------------------------------------------------------------
   --
   ----------------------------------------------------------------------
   lvs_lot_no := f_get_lot_no_from_barcode (lvs_old_barcode);
   lvl_item_qty := f_get_lot_qty_from_barcode (lvs_old_barcode);

   --------------------------------------------------------------------------------
   --  ccs 완료 여부 체크 
   --------------------------------------------------------------------------------
   
       BEGIN
           SELECT   COUNT ( * ), MAX (location_code)
             INTO   lvi_no_ccs, lvs_no_css_address
             FROM   ib_product_plandata
            WHERE       model_name = p_model_name
                    AND line_code = SUBSTR (p_line_code, 1, 2)
                    AND pcb_item = p_topbot
                    AND active_yn = 'Y'
                    AND ccs_yn = 'N';
       EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
           WHEN NO_DATA_FOUND
           THEN
               lvi_no_ccs := 0;
       END;

           IF lvi_no_ccs > 0 OR lvi_no_ccs is null  THEN
               p_return := f_msg('[REEL PRE] CCS가 완료되지 않았습니다.','K',1)  -- '00 CSS NOT COMPLETED'
                           || ' = ' 
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
                  'REEL CHECK PRE',
                  f_msg('[REEL PRE] CCS가 완료되지 않았습니다.','K',1)   -- '00 CSS NOT COMPLETED'
                  || ' = '
                  || lvs_old_barcode
                  || ', '
                  || p_address
                  || ', '
                  || lvl_check_seq);
            --------------------------------------------------------------------------------
            -- NSNP END
            --------------------------------------------------------------------------------
            EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
               WHEN OTHERS
               THEN
                  NULL;
            END;
               RETURN;
           END IF ;
 
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         lvi_replace := 0;
   END;

   ---------------------------------------------------------------------------
   -- check replace item
   ---------------------------------------------------------------------------
   lvi_replace := 0;

   BEGIN
      SELECT COUNT (*)
        INTO lvi_replace
        FROM ib_product_plandata
       WHERE     model_name = p_model_name
             AND line_code = SUBSTR (p_line_code, 1, 2)
             AND location_code = p_address
             AND (item_code LIKE '%' || lvs_item_code_old
                  OR item_code = lvs_item_code_replace)
             AND pcb_item = p_topbot
             AND active_yn = 'Y';
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         lvi_replace := 0;
   END;

   --------------------------------------------------
   -- CHECK ERP BARCODE CREATE HISTORY
   --------------------------------------------------

   BEGIN
      SELECT barcode_status,
             scan_qty,
             receipt_compare_yn,
             NVL (issue_compare_yn, 'Y'),
             holding_yn,
             label_type
        INTO lvs_new_barcode_status,
             lvl_item_qty,
             lvs_receipt_compare_yn,
             lvs_issue_compare_yn,
             lvs_holding_yn,
             lvs_label_type
        FROM im_item_receipt_barcode
       WHERE     lot_no = lvs_lot_no
             AND UPPER (TRIM (lvs_item_code_old)) LIKE '%' || item_code
             AND issue_compare_yn = 'Y'
             AND receipt_compare_yn = 'Y';
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND  THEN
         /*      ----------------------------------------------------------
               --
               ----------------------------------------------------------
                   IF lvs_label_type IN ('R', 'B')
                   THEN
                       NULL;
                   ELSE

                       UPDATE   ib_product_plandata
                          SET   check_status = 'E',
                                check_msg = '02 NO ISSUE BARCODE(PRE) ' || lvs_old_barcode,
                                selected_date = TO_CHAR (SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
                        WHERE   model_name = UPPER (p_model_name)
                            AND line_code = SUBSTR (p_line_code, 1, 2)
                            AND location_code = p_address
                            AND active_yn = 'Y'
                            AND pcb_item = p_topbot;

                       COMMIT;

                       p_return := '02 NO ISSUE BARCODE(PRE) ' || lvs_item_code_old || ' ' || lvs_lot_no || ' ';
                       RETURN;
                   END IF;*/
                   
            p_return := f_msg('[REEL PRE] 자재출고 이력이 없습니다.','K',1) -- '02 NO ISSUE BARCODE(PRE) '
                        || ' = '
                        || lvs_item_code_old
                        || ' ' 
                        || lvs_lot_no || ' ';
             RETURN;

   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN OTHERS  THEN
         p_return := SQLERRM;
   END;


   -------------------------------------------------------------------------------
   -- TEMPORARY NO USE
   -------------------------------------------------------------------------------

   /*  IF lvs_issue_compare_yn = 'N' AND lvs_label_type NOT IN ('R', 'B')
     THEN
         p_return := '02 NO ISSUE BARCODE(PRE) ' || lvs_old_barcode;
     END IF;*/

    --------------------------------------------------------------------------------
    --  CCS COMPLETE CHECK
    --------------------------------------------------------------------------------
    BEGIN
        SELECT   COUNT ( * ), MAX (NVL (location_code, '*'))
          INTO   lvi_no_ccs, lvs_no_css_address
          FROM   ib_product_plandata
         WHERE   model_name = p_model_name
             AND line_code = SUBSTR (p_line_code, 1, 2)
             AND pcb_item = p_topbot
             AND active_yn = 'Y'
             AND check_yn = 'N';
    EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
        WHEN NO_DATA_FOUND
        THEN
            lvi_no_ccs := 0;
    END;



    IF lvi_no_ccs > 0 OR lvi_no_ccs IS NULL THEN
        p_return := f_msg('[REEL PRE] CCS가 완료되지 않았습니다.','K',1) -- '00 CSS NOT COMPLETED(PRE)'
                    || ' = '
                    || lvs_no_css_address;  
        RETURN;
    END IF;

   phase := '16';

   -----------------------------------------------------------
   --
   -----------------------------------------------------------
   IF lvs_item_code_old = '' OR lvs_item_code_old IS NULL
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
                                    smt_model_name,
                                    enter_date,
                                    enter_by)
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                p_model_name,
                lvs_item_code_old,                            -- OUR ITEM CODE
                lvs_item_code_old,                       -- SUPPLIER ITEM CODE
                'E',
                f_msg('[REEL PRE] 미등록 바코드 입니다.','K',1),   -- 03 BARCODE NOT FOUND(PRE)
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_old_barcode,                                -- OUR BARCODE
                '',
                p_address,
                p_deficit,
                DECODE (SUBSTR (p_address, 1, 4),
                        'TRAY', 'Z',
                        SUBSTR (p_address, 1, 1)),
                p_topbot,
                lvs_partname,
                '*',
                sysdate,
                p_userid);

      COMMIT;

      UPDATE ib_product_plandata
         SET check_status = 'E',
             check_msg = f_msg('[REEL PRE] 미등록 바코드 입니다.','K',1)   -- '03 BARCODE NOT FOUND(PRE) '
                         || ' = '
                         || lvs_old_barcode,
             change_date = SYSDATE
       WHERE     model_name = p_model_name
             AND line_code = SUBSTR (p_line_code, 1, 2) --   AND machine = TRIM (SUBSTR (p_line_code, 4, 10))
             AND location_code = p_address
             AND active_yn = 'Y'
             AND pcb_item = p_topbot;

            p_return := f_msg('[REEL PRE] 미등록 바코드 입니다.','K',1)    -- '03 BARCODE NOT FOUND(PRE) '
                        || ' = '
                        || lvs_old_barcode;   
            
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
                                               'REEL CHECK PRE',
                                               f_msg('[REEL PRE] 미등록 바코드 입니다.','K',1)   --   '03 BARCODE NOT FOUND(PRE) '
                                               || ' = '
                                               || lvs_old_barcode
                                               || ', '
                                               || p_address
                                               || ', '
                                               || lvl_check_seq
                                             );
            --------------------------------------------------------------------------------
            -- NSNP END
            --------------------------------------------------------------------------------
            EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
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
       WHERE model_name = p_model_name
         AND line_code = SUBSTR (p_line_code, 1, 2)
         AND location_code = p_address
         AND TRIM (lvs_item_code_old) LIKE '%' || item_code
         AND active_yn = 'Y'
         AND pcb_item = p_topbot;
         
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND THEN
           lvs_model_name := '';
   END;

   phase := '40';

   ------------------------------------------------------------------
   --
   ------------------------------------------------------------------
   IF lvs_model_name = '' OR lvs_model_name IS NULL THEN
     
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
                                    smt_model_name,
                                    enter_date,
                                    enter_by)
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                p_model_name,
                lvs_item_code_old,
                lvs_item_code_old,
                'E',
                f_msg('[REEL PRE] CCS 가 안되었거나 피더 레이아웃이 없습니다.','K',1)    -- '07 CCS Notfound or Layout Notfound(PRE) '
                || ' = '
                || ' Model='
                || p_model_name
                || ', Part='
                || lvs_partname
                || ', Scan='
                || lvs_item_code_old
                || ', Loc='
                || p_address,
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_old_barcode,
                '',
                p_address,
                p_deficit,
                DECODE (SUBSTR (p_address, 1, 4),
                        'TRAY', 'Z',
                        SUBSTR (p_address, 1, 1)),
                p_topbot,
                lvs_partname,
                '*',
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
             f_msg('[REEL PRE] CCS 가 안되었거나 피더 레이아웃이 없습니다.','K',1)    -- '07 CCS Notfound or Layout Notfound(PRE) '
             || ' = '
             || lvs_old_barcode,
             change_date = SYSDATE
       WHERE     model_name = p_model_name
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
                  p_line_code,
                  1,
                  1,
                  p_model_name,
                  '*',
                  'REEL CHECK PRE',
                  f_msg('[REEL PRE] CCS 가 안되었거나 피더 레이아웃이 없습니다.','K',1)    --   '07 REEL CHANGE PLAN NOT FOUND(PRE) '
                  || ' = '
                  || lvs_old_barcode
                  || ', '
                  || p_address
                  || ', '
                  || lvl_check_seq);
            --------------------------------------------------------------------------------
            -- NSNP END
            --------------------------------------------------------------------------------
            EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
               WHEN OTHERS
               THEN
                  NULL;
            END;

      phase := '43';
      
      p_return := f_msg('[REEL PRE] CCS 가 안되었거나 피더 레이아웃이 없습니다.','K',1)   --   '07 REEL CHANGE PLAN NOT FOUND(PRE) '
                  || ' = '
                  || SUBSTR (p_line_code, 1, 2)
                  || ', '
                  || p_address
                  || ', '
                  || lvs_item_code_old;
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
      p_return := f_msg('[REEL PRE] 피더 레이아웃이 없습니다.','K',1);   -- '05 FEEDER LAYOUT NOT FOUND(PRE) '
      RETURN;
   END IF;
   
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
      raise_application_error (
                                -20003,
                               'NG, [REEL PRE] Phase='
                               || phase
                               || ', '
                               || p_model_name
                               || ', '
                               || p_line_code
                               || ', '
                               || p_address
                               || ', '
                               || SQLERRM
                              );
END;
