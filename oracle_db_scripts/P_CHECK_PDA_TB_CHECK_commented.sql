CREATE OR REPLACE PROCEDURE "P_CHECK_PDA_TB_CHECK" (
  /* ================================================================
   * 프로시저명  : P_CHECK_PDA_TB_CHECK
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
   *   P_TOBBOT - 원본 선언부 기준 입력/출력 파라미터
   *   P_ADDRESS - 원본 선언부 기준 입력/출력 파라미터
   *   P_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_USERID - 원본 선언부 기준 입력/출력 파라미터
   *   P_DEFICIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_RETURN - 원본 선언부 기준 입력/출력 파라미터
   *   P_SEQUENCE - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 원본 로직 참조 테이블
   *   IB_SMT_CHECKHIST - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_ITEM_CODE_FROM_BARCODE
   *   F_GET_LOT_NO_FROM_BARCODE
   *   F_GET_PREPARE_BARCODE
   *   F_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_PDA_TB_CHECK(...)
   * ================================================================ */
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

   lvs_line_code     VARCHAR2 (20); -- [AI] 내부 처리용 변수
   lvi_count         NUMBER; -- [AI] 내부 처리용 변수

   lvs_item_code     VARCHAR2 (30); -- [AI] 내부 처리용 변수
   phase             VARCHAR2 (10); -- [AI] 내부 처리용 변수
   lvs_lot_no        VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_new_barcode   VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_check_count   NUMBER; -- [AI] 내부 처리용 변수
   lvl_check_seq     NUMBER; -- [AI] 내부 처리용 변수

   lvs_partname      VARCHAR2 (30); -- [AI] 내부 처리용 변수


   lvdt_valid_date   DATE; -- [AI] 내부 처리용 변수
   lvs_lot_serial    VARCHAR2 (10); -- [AI] 내부 처리용 변수
   lvs_trace_code    VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_vendor_name   VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvdt_inspect_date  DATE; -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
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