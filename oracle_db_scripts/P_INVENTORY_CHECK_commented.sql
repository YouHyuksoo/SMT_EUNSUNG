CREATE OR REPLACE PROCEDURE "P_INVENTORY_CHECK" (
  /* ================================================================
   * 프로시저명  : P_INVENTORY_CHECK
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건을 기준으로 상태 또는 기준 데이터의 유효성을 확인한다.
   *   조회 결과와 원본 분기 조건에 따라 OUT 파라미터 또는 관련 상태 값을 설정한다.
   *   호출부가 결과 코드와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_ITEM_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_ERR - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ITEM - Item Master
   *   IM_ITEM_INVENTORY_CHECK_BCD - 원본 로직 참조 테이블
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
   *   EXEC P_INVENTORY_CHECK(...)
   * ================================================================ */
   p_line_code      IN     VARCHAR2,
   p_item_barcode   IN     VARCHAR2,
   p_err               OUT VARCHAR2)
IS
   lvs_line_code     VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_item_code     VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvi_count         NUMBER; -- [AI] 내부 처리용 변수
   lvs_our_barcode   VARCHAR2 (100); -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
   -------------------------------------------------------
   --   P_TYPE : N = NORMAL , C = CANCEL
   --   1 : BARCODE INVALID
   --   2 : ITEM NOT FOUND
   --   3 : DELETE DATA NOT FOUND
   --   9 : SQLERROR
   -------------------------------------------------------
  -- lvs_our_barcode := UPPER (p_item_barcode);


   lvs_our_barcode := f_get_prepare_barcode (p_item_barcode);

   ------------------------------------------------------------------------------


   IF LENGTH (lvs_our_barcode) < 10 or instr( lvs_our_barcode , '@' , 1 ) > 0  or instr( lvs_our_barcode , '---' , 1 ) > 0  OR length (lvs_our_barcode) > 40
   THEN
      p_err :=f_msg( '00 BARCODE INVLIAD' , 'C' , 1 );
      RETURN;
   END IF;


   --------------------------------------------------------
   --
   --------------------------------------------------------

   lvs_item_code :=    f_get_item_code_from_barcode(lvs_our_barcode) ;  -- SUBSTR (lvs_our_barcode, 1, INSTR (lvs_our_barcode, '-', 7) - 1);

   IF lvs_item_code = '' OR LENGTH (lvs_item_code) <> 11
   THEN
      lvs_item_code :=
         SUBSTR (lvs_our_barcode, 1, INSTR (lvs_our_barcode, '+', 1) - 1);

      IF lvs_item_code = '' OR LENGTH (lvs_item_code) <> 11
      THEN
         lvs_item_code := SUBSTR (lvs_our_barcode, 1, 11);
      END IF;
   END IF;

-------------------------------------------------------------
--  폼목 코드 체크
-------------------------------------------------------------
   BEGIN
      SELECT COUNT (*)
        INTO lvi_count
        FROM id_item
       WHERE item_code = lvs_item_code;
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         p_err := f_msg('02 ITEM NOT FOUND' , 'C' , 1 ) ;
         RETURN;
   END;

   IF NVL (lvi_count, 0) < 1
   THEN
      p_err :=f_msg( '02 ITEM NOT FOUND' , 'C' ,1 ) ;
      RETURN;
   END IF;

   BEGIN
      SELECT COUNT (*)
        INTO lvi_count
        FROM im_item_inventory_check_bcd
       WHERE item_barcode = lvs_our_barcode;
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         lvi_count := 0;
   END;

   IF NVL (lvi_count, 0) > 0
   THEN
      p_err :=f_msg( '03 AREADY EXITS' , 'C' , 1 ) ;
      RETURN;
   END IF;

   INSERT INTO im_item_inventory_check_bcd (check_yyyymm,
                                            line_code,
                                            item_barcode,
                                            item_code,
                                            lot_no,
                                            enter_by,
                                            enter_date,
                                            last_modify_by,
                                            last_modify_date,
                                            organization_id)
   VALUES (TO_CHAR (SYSDATE, 'yyyymm'),
           SUBSTR (p_line_code, 1, 2),
           p_item_barcode,
           NVL (lvs_item_code, p_item_barcode),
           f_get_lot_no_from_barcode (p_item_barcode),
           'SYSTEM',
           SYSDATE,
           'SYSTEM',
           SYSDATE,
           1);

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