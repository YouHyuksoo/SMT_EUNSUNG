CREATE OR REPLACE PROCEDURE "P_INVENTORY_MOVE" (
  /* ================================================================
   * 프로시저명  : P_INVENTORY_MOVE
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   제품, 재고, 입출고 또는 팔레트 관련 업무 데이터를 등록/갱신한다.
   *   대상 데이터의 존재 여부와 수량 조건을 확인한 뒤 원본 로직에 따라 처리한다.
   *   COMMIT/ROLLBACK 포함 여부는 원본 트랜잭션 흐름을 그대로 유지한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_ITEM_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_FR_LOCATION - 원본 선언부 기준 입력/출력 파라미터
   *   P_TO_LOCATION - 원본 선언부 기준 입력/출력 파라미터
   *   P_ERR - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ITEM - Item Master
   *   IM_ITEM_INVENTORY - Item Inventory Master
   *   IM_ITEM_ISSUE - Item Issue Master
   *   IM_ITEM_RECEIPT_BARCODE - 원본 로직 참조 테이블
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
   *   EXEC P_INVENTORY_MOVE(...)
   * ================================================================ */
   p_item_barcode   IN     VARCHAR2,
   p_fr_location    IN     VARCHAR2,
   p_to_location    IN     VARCHAR2,
   p_err               OUT VARCHAR2)
IS
   lvs_lot_no             VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_item_code          VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_suppliercode       VARCHAR2 (20); -- [AI] 내부 처리용 변수
   lvs_barcode            VARCHAR2 (200); -- [AI] 내부 처리용 변수


   lvl_cnt                NUMBER; -- [AI] 내부 처리용 변수
   lvi_count              NUMBER; -- [AI] 내부 처리용 변수
   lvl_qty                NUMBER; -- [AI] 내부 처리용 변수
   lvs_issue_compare_yn   VARCHAR2 (10); -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
   
      lvs_barcode := f_get_prepare_barcode (p_item_barcode);
      lvs_item_code := f_get_item_code_from_barcode (lvs_barcode);
  
   IF    lvs_barcode = '--'
      OR lvs_barcode IS NULL
      OR LENGTH (lvs_barcode) > 50
      OR LENGTH (lvs_barcode) < 10
   THEN
      p_err := f_msg('[REQ:01] BARCODE INVALID : 바코드형식이틀립니다.','C',1);
      RETURN;
   END IF;

   ----------------------------------------------------------------------
   --
   ----------------------------------------------------------------------
   BEGIN
      SELECT COUNT (*)
        INTO lvi_count
        FROM id_item
       WHERE item_code = lvs_item_code;
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         p_err := f_msg('[REQ:04] ITEM NOT FOUND : 품목마스터가 없습니다.','C',1);
         RETURN;
   END;

   IF NVL (lvi_count, 0) = 0
   THEN
      p_err := f_msg('[REQ:04] ITEM NOT FOUND : 품목마스터가 없습니다.','C',1);
      RETURN;
   END IF;

   BEGIN
      SELECT SUPPLIER_CODE
        INTO lvs_suppliercode
        FROM id_item
       WHERE item_code = lvs_item_code;
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         lvs_suppliercode := '';
   END;


   ----------------------------------------------------------------------
   --  INVENTORY CHECK
   ----------------------------------------------------------------------
  
      lvs_lot_no := f_get_lot_no_from_barcode (p_item_barcode);
  
   BEGIN
      SELECT COUNT (*)
        INTO lvl_cnt
        FROM IM_ITEM_INVENTORY
       WHERE item_code = UPPER (lvs_item_code)
             AND material_mfs = UPPER (lvs_lot_no);
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         lvl_cnt := 0;
   END;


   IF lvl_cnt = 0
   THEN
      p_err :=
            f_msg('[REQ:05] INVENTORY NOT FOUND : 재고없는품목 : ' ,'C',1) 
         || lvs_item_code
         || ' '
         || lvs_lot_no;
      RETURN;
   END IF;

   --------------------------------------------------------------
   --
   --------------------------------------------------------------
   BEGIN
      SELECT NVL (issue_compare_yn, 'N')
        INTO lvs_issue_compare_yn
        FROM IM_ITEM_receipt_barcode
       WHERE lot_no = UPPER (lvs_lot_no);
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         lvs_issue_compare_yn := 'N';
   END;


   IF lvs_issue_compare_yn = 'Y'
   THEN
      p_err :=
            f_msg('[MOVE:05] 출고 반품 후 이동하세요 : ' ,'C',1) 
         || lvs_item_code
         || ' '
         || lvs_lot_no;
      RETURN;
   END IF;

   ------------------------------------------------------------------
   --재고수량
   ------------------------------------------------------------------
   BEGIN
      SELECT NVL (inventory_qty, 0)
        INTO lvl_qty
        FROM IM_ITEM_INVENTORY
       WHERE     item_code = UPPER (lvs_item_code)
             AND material_mfs = UPPER (lvs_lot_no)
             AND location_code = UPPER (p_fr_location);
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         lvl_qty := 0;
   END;

   IF lvl_qty <> 0
   THEN
      --기존 창고에서 출고처리
      INSERT INTO im_item_issue (issue_date,
                                 issue_sequence,
                                 organization_id,
                                 material_mfs,
                                 mfs,
                                 item_code,
                                 location_code,
                                 supplier_code,
                                 item_type,
                                 line_code,
                                 workstage_code,
                                 machine_code,
                                 issue_deficit,
                                 issue_qty,
                                 issue_status,
                                 issue_amt,
                                 issue_account,
                                 line_type,
                                 issue_price,
                                 issue_type,
                                 virtual_receipt_yn,
                                 work_order_no,
                                 comments,
                                 enter_date,
                                 enter_by,
                                 last_modify_date,
                                 last_modify_by,
                                 invoice_no,
                                 parent_item_code,
                                 interface_yn,
                                 interface_date,
                                 arrival_date,
                                 arrival_seq_no,
                                 dest_organization_id)
         SELECT TRUNC (SYSDATE),
                seq_mat_issue.NEXTVAL,
                1,
                material_mfs,
                '*' mfs,
                item_code,
                location_code,
                NVL (supplier_code, '*'),
                'T' item_type,
                '*',
                '*',
                '*' machine_code,
                3,
                ABS (lvl_qty),
                'N' issue_status,
                ABS (lvl_qty) * inventory_price,
                'M001' issue_account,
                line_type,
                inventory_price,
                'N' issue_type,
                'N' virtual_receipt_yn,
                seq_mat_issue.NEXTVAL work_order_no,
                'SELECT INSPECT' comments,
                SYSDATE,
                'SYSTEM',
                SYSDATE,
                'SYSTEM',
                TO_CHAR (SYSDATE, 'YYYYMMDD')
                || TRIM (
                      TO_CHAR (
                         SEQ_ISSUE_INVOICE_SEQUENCE.NEXTVAL)),
                '*' parent_item_code,
                'N' interface_yn,
                NULL interface_date,
                NULL arrival_date,
                NULL arrival_seq_no,
                NULL dest_organization_id
           FROM im_item_inventory
          WHERE     item_code = UPPER (lvs_item_code)
                AND location_code = UPPER (p_fr_location)
                AND material_mfs = UPPER (lvs_lot_no);


      --목적지 창고 반입처리
      INSERT INTO im_item_issue (issue_date,
                                 issue_sequence,
                                 organization_id,
                                 material_mfs,
                                 mfs,
                                 item_code,
                                 location_code,
                                 supplier_code,
                                 item_type,
                                 line_code,
                                 workstage_code,
                                 machine_code,
                                 issue_deficit,
                                 issue_qty,
                                 issue_status,
                                 issue_amt,
                                 issue_account,
                                 line_type,
                                 issue_price,
                                 issue_type,
                                 virtual_receipt_yn,
                                 work_order_no,
                                 comments,
                                 enter_date,
                                 enter_by,
                                 last_modify_date,
                                 last_modify_by,
                                 invoice_no,
                                 parent_item_code,
                                 interface_yn,
                                 interface_date,
                                 arrival_date,
                                 arrival_seq_no,
                                 dest_organization_id)
         SELECT TRUNC (SYSDATE),
                seq_mat_issue.NEXTVAL,
                1,
                material_mfs,
                '*' mfs,
                item_code,
                p_to_location,
                NVL (supplier_code, '*'),
                'T' item_type,
                '*',
                '*',
                '*' machine_code,
                4,
                ABS (lvl_qty) * -1,
                'N' issue_status,
                ABS (lvl_qty) * -1 * inventory_price,
                'M001' issue_account,
                line_type,
                inventory_price,
                'N' issue_type,
                'N' virtual_receipt_yn,
                seq_mat_issue.NEXTVAL work_order_no,
                'MOVE' comments,
                SYSDATE,
                'SYSTEM',
                SYSDATE,
                'SYSTEM',
                TO_CHAR (SYSDATE, 'YYYYMMDD')
                || TRIM (
                      TO_CHAR (
                         SEQ_ISSUE_INVOICE_SEQUENCE.NEXTVAL)),
                '*' parent_item_code,
                'N' interface_yn,
                NULL interface_date,
                NULL arrival_date,
                NULL arrival_seq_no,
                NULL dest_organization_id
           FROM im_item_inventory
          WHERE     item_code = UPPER (lvs_item_code)
                AND location_code = UPPER (p_fr_location)
                AND material_mfs = UPPER (lvs_lot_no);
   END IF;

   COMMIT;
   p_err := 'OK';
   RETURN;
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
      p_err := p_item_barcode || ' ' || SUBSTR (SQLERRM, 1, 100);
      RETURN;
END;