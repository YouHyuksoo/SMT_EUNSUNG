CREATE OR REPLACE PROCEDURE "P_INVENTORY_CHECK_QTY" (
  /* ================================================================
   * 프로시저명  : P_INVENTORY_CHECK_QTY
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건을 기준으로 업무 데이터의 유효성 또는 상태를 확인한다.
   *   조회 결과와 원본 분기 조건에 따라 OUT 파라미터 또는 상태 값을 설정한다.
   *   호출부가 결과 코드와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_ITEM_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_QTY - 원본 선언부 기준 입력/출력 파라미터
   *   P_ERR - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ITEM - Item Master
   *   IM_ITEM_INVENTORY_CHECK_BCD - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_INVENTORY_CHECK_QTY(...)
   * ================================================================ */
   p_line_code      IN     VARCHAR2,
   p_item_barcode   IN     VARCHAR2,
   p_qty            IN     VARCHAR2,
   p_err               OUT VARCHAR2)
IS
   lvs_line_code          VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_item_code          VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_lot_no             VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvi_count              NUMBER; -- [AI] 내부 처리용 변수
   lvs_our_barcode        VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvl_barcode_qty        NUMBER; -- [AI] 내부 처리용 변수
   lvi_scan_qty           NUMBER; -- [AI] 내부 처리용 변수
   lvs_location_address   VARCHAR2 (20); -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
   -------------------------------------------------------
   --   P_TYPE : N = NORMAL , C = CANCEL
   --   1 : BARCODE INVALID
   --   2 : ITEM NOT FOUND
   --   3 : DELETE DATA NOT FOUND
   --   9 : SQLERROR
   -------------------------------------------------------
   lvs_our_barcode := UPPER (p_item_barcode);

   lvs_item_code := UPPER (TRIM(SUBSTR (lvs_our_barcode, 1, INSTR (lvs_our_barcode, '-',7 ) -1)));


   lvs_lot_no :=
      UPPER (
         SUBSTR (lvs_our_barcode, INSTR (lvs_our_barcode, '-', 7) + 1, 100));


   IF lvs_lot_no = '' OR lvs_lot_no IS NULL
   THEN
      p_err := '바코드형식이 틀립니다.';
      RETURN;
   END IF;

   -------------------------------
   -- 사용자 지정 수량이 있으면
   -------------------------------
   IF NVL (p_qty, 0) > 0
   THEN
      lvl_barcode_qty := TO_NUMBER (p_qty);
   ELSE
      p_err := '수량을 입력하세요.';
      RETURN;
   END IF;

   -------------------------------------------------------------------------------------
   -- 품목존재 여부 체크
   -------------------------------------------------------------------------------------

   BEGIN
      SELECT COUNT (*), MAX (location_address)
        INTO lvi_count, lvs_location_address
        FROM id_item
       WHERE item_code = lvs_item_code
       GROUP BY ITEM_CODE;
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         p_err := lvs_item_code||' : 품목정보를 찾을수 없습니다'||SQLERRM;
         RETURN;
   END;

   IF NVL(lvi_count,0) < 1
   THEN
      p_err := lvs_item_code||f_msg( ' : 품목정보를 찾을수 없습니다.' , 'C' , 1 ) ;
      RETURN;
   END IF;

   BEGIN
      SELECT COUNT (*)
        INTO lvi_count
        FROM im_item_inventory_check_bcd
       WHERE lot_no = lvs_lot_no;
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         lvi_count := 0;
   END;

   IF NVL (lvi_count, 0) > 0
   THEN
      p_err := lvs_lot_no||f_msg(' : 이미존재 합니다.' ,'C' , 1 ) ;
      RETURN;
   END IF;

   --------------------------------------------------------
   --  barcode_qty 가 0 이면 트리거에서
   --  RECEIPT BARCODE 에서 scan_qty 수량을 가져와서 넣어줌
   --  여기서 넣어주면 안가져오고 여기서 넣은 수량으로 등록
   --------------------------------------------------------

   INSERT INTO im_item_inventory_check_bcd (check_yyyymm,
                                            line_code,
                                            item_barcode,
                                            item_code,
                                            enter_by,
                                            enter_date,
                                            last_modify_by,
                                            last_modify_date,
                                            barcode_qty,
                                            inventory_qty,
                                            organization_id,
                                            check_type,
                                            location_address)
   VALUES (TO_CHAR (SYSDATE, 'yyyymm'),
           UPPER (p_line_code),
           p_item_barcode,
           NVL (lvs_item_code, p_item_barcode),
           'PDA',
           SYSDATE,
           'SYSTEM',
           SYSDATE,
           NVL (lvl_barcode_qty, 0),
           0,
           1,
           'M',
           lvs_location_address);                               --MOVING CHECK

   COMMIT;
   p_err := '';
   RETURN;
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
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