CREATE OR REPLACE PROCEDURE "P_INVENTORY_RECEIPT" (
  /* ================================================================
   * 프로시저명  : P_INVENTORY_RECEIPT
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   제품, 재고, 입출고 관련 업무 데이터를 등록 또는 갱신한다.
   *   대상 데이터의 존재 여부와 수량 조건을 확인한 뒤 원본 로직에 따라 처리한다.
   *   COMMIT/ROLLBACK 포함 여부는 원본 트랜잭션 흐름을 그대로 유지한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LOCATION_ADDRESS - 원본 선언부 기준 입력/출력 파라미터
   *   P_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_SUPPLIER_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_RETURN - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_INVENTORY - Item Inventory Master
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_ITEM_CODE_FROM_BARCODE
   *   F_GET_LOT_NO_FROM_BARCODE
   *   F_GET_LOT_QTY_FROM_BARCODE
   *   F_GET_PREPARE_BARCODE
   *   F_GET_PREPARE_SUPPLIER_BARCODE
   *   F_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_INVENTORY_RECEIPT(...)
   * ================================================================ */
   P_LOCATION_ADDRESS   IN     VARCHAR2,
   P_BARCODE            IN     VARCHAR2,
   P_SUPPLIER_BARCODE   IN     VARCHAR2,
   P_RETURN                OUT VARCHAR2)
IS
   LVS_BARCODE            VARCHAR2 (200); -- [AI] 내부 처리용 변수
   lvl_item_qty           NUMBER; -- [AI] 내부 처리용 변수
   LVS_ITEM_CODE          VARCHAR2 (30); -- [AI] 내부 처리용 변수
   LVS_ITEM_CODE_SUP      VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_lot_no             VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvl_first_origin       NUMBER; -- [AI] 내부 처리용 변수
   lvl_second_origin      NUMBER; -- [AI] 내부 처리용 변수
   LVS_SUPPLIER_BARCODE   VARCHAR2 (50); -- [AI] 내부 처리용 변수

   phase                  VARCHAR2 (10); -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
   -----------------------------------------------------------------------
   --  자사 바코드

   -----------------------------------------------------------------------

   IF SUBSTR (UPPER (P_BARCODE), 1, 1) = '['
   THEN
      LVS_BARCODE :=
            f_get_item_code_from_barcode (P_BARCODE)
         || '-'
         || f_get_lot_no_from_barcode (P_BARCODE)
         || '-'
         || f_get_lot_qty_from_barcode (P_BARCODE);
   ELSE
      LVS_BARCODE := f_get_prepare_barcode (P_BARCODE);
   END IF;

   ----------------------------------------------------------------------------
   --
   ----------------------------------------------------------------------------
   IF LENGTH (LVS_BARCODE) < 8
   THEN
      p_return := f_msg('00 ORIGIN BARCODE INVALID(SUP)','C',1) 
      || LVS_BARCODE;
      RETURN;
   END IF;


   phase := '11';
   --------------------------------------------------------------------------------
   --
   --------------------------------------------------------------------------------
   lvl_first_origin := INSTR (LVS_BARCODE, '-', 1);
   lvl_second_origin := INSTR (LVS_BARCODE, '-', lvl_first_origin + 1);
   phase := '12';

   IF lvl_first_origin <= 0
   THEN
      LVS_ITEM_CODE := TRIM (SUBSTR (LVS_BARCODE, 1, 100));
   ELSE
      LVS_ITEM_CODE := SUBSTR (LVS_BARCODE, 1, lvl_first_origin - 1);
   END IF;


   phase := '13';

   ----------------------------------------------------------------------
   --
   ----------------------------------------------------------------------
   IF lvl_first_origin <= 0 AND lvl_second_origin <= 0
   THEN
      lvs_lot_no := LVS_BARCODE;
   ELSIF lvl_first_origin > 0 AND lvl_second_origin <= 0
   THEN
      BEGIN
         lvs_lot_no :=
            SUBSTR (LVS_BARCODE, INSTR (LVS_BARCODE, '-', 1) + 1, 100);
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS
         THEN
            lvs_lot_no :=
               SUBSTR (LVS_BARCODE, INSTR (LVS_BARCODE, '-', 1) + 1, 100);
      END;
   ----------------------------------------------------------------------
   --
   ----------------------------------------------------------------------
   ELSE
      BEGIN
         lvs_lot_no :=
            TO_NUMBER (
               SUBSTR (LVS_BARCODE,
                       INSTR (LVS_BARCODE, '-', 1) + 1,
                       (lvl_second_origin - lvl_first_origin) - 1));
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS
         THEN
            lvs_lot_no :=
               SUBSTR (LVS_BARCODE,
                       INSTR (LVS_BARCODE, '-', 1) + 1,
                       (lvl_second_origin - lvl_first_origin) - 1);
      END;
   END IF;


   ----------------------------------------------------------------------------
   --  거래처 바코드

   ----------------------------------------------------------------------------

   IF SUBSTR (UPPER (P_SUPPLIER_BARCODE), 1, 1) = '['
   THEN
      LVS_SUPPLIER_BARCODE :=
            f_get_item_code_from_barcode (P_SUPPLIER_BARCODE)
         || '-'
         || f_get_lot_no_from_barcode (P_SUPPLIER_BARCODE)
         || '-'
         || f_get_lot_qty_from_barcode (P_SUPPLIER_BARCODE);
   -----------------------------------------------------------------------
   --
   -----------------------------------------------------------------------
   ELSE
      LVS_SUPPLIER_BARCODE :=
         f_get_prepare_supplier_barcode (P_SUPPLIER_BARCODE);
   END IF;

   ----------------------------------------------------------------------------
   --
   ----------------------------------------------------------------------------
   IF LENGTH (LVS_SUPPLIER_BARCODE) < 8
   THEN
      p_return := f_msg('00 SUPPLIER BARCODE INVALID(SUP)' ,'C',1) 
      || LVS_SUPPLIER_BARCODE;
      RETURN;
   END IF;

   --------------------------------------------------------------------------------
   -- 거래처 바코드에서 품목 추출
   --------------------------------------------------------------------------------
   lvl_first_origin := INSTR (LVS_SUPPLIER_BARCODE, '-', 1);
   lvl_second_origin :=
      INSTR (LVS_SUPPLIER_BARCODE, '-', lvl_first_origin + 1);
   phase := '12';

   IF lvl_first_origin <= 0
   THEN
      LVS_ITEM_CODE_SUP := TRIM (SUBSTR (LVS_SUPPLIER_BARCODE, 1, 100));
   ELSE
      LVS_ITEM_CODE_SUP :=
         SUBSTR (LVS_SUPPLIER_BARCODE, 1, lvl_first_origin - 1);
   END IF;

   ---------------------------------------------------------------------
   -- 품목 비교
   ---------------------------------------------------------------------
   IF INSTR (LVS_ITEM_CODE, LVS_ITEM_CODE_SUP, 1) = 0
   THEN
      P_RETURN :=
            LVS_ITEM_CODE
         || ' '
         || LVS_ITEM_CODE_SUP
         || f_msg('품목코드가 일치하지 않습니다.','C',1);
      RETURN;
   END IF;

   ---------------------------------------------------------------------
   --
   ---------------------------------------------------------------------

   UPDATE im_item_invenTory
      SET location_address_rack = p_location_address
    WHERE MATERIAL_MFS = LVS_LOT_NO;

   COMMIT;
   p_return := 'OK';                           -- OK 로 PDA 에서 판단 하므로 수정 하면 안됨.
   RETURN;
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN NO_DATA_FOUND
   THEN
      P_RETURN :=
         LVS_ITEM_CODE || ' ' || LVS_LOT_NO || f_msg(' 자료가 없습니다','C',1);
      RETURN;
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
      P_RETURN := SQLERRM;
      RETURN;
END P_INVENTORY_RECEIPT;