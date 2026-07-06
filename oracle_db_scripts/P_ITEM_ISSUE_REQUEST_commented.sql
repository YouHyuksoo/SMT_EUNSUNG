CREATE OR REPLACE PROCEDURE "P_ITEM_ISSUE_REQUEST" (
  /* ================================================================
   * 프로시저명  : P_ITEM_ISSUE_REQUEST
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   제품, 재고, 입출고 관련 업무 데이터를 등록 또는 갱신한다.
   *   대상 데이터의 존재 여부와 수량 조건을 확인한 뒤 원본 로직에 따라 처리한다.
   *   COMMIT/ROLLBACK 포함 여부는 원본 트랜잭션 흐름을 그대로 유지한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_MODEL_NAME - 원본 선언부 기준 입력/출력 파라미터
   *   P_ITEM_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_LOCATION_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_TYPE - 원본 선언부 기준 입력/출력 파라미터
   *   P_QTY - 원본 선언부 기준 입력/출력 파라미터
   *   P_ERR - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 원본 로직 참조 테이블
   *   ID_ITEM - Item Master
   *   IM_ITEM_INVENTORY - Item Inventory Master
   *   IM_ITEM_REQUEST - Item Request Master
   *   IP_PRODUCT_LINE - Product Line Master
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_ITEM_CODE_FROM_BARCODE
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
   *   EXEC P_ITEM_ISSUE_REQUEST(...)
   * ================================================================ */
   p_line_code       IN     VARCHAR2,
   p_model_name      IN     VARCHAR2,
   p_item_barcode    IN     VARCHAR2,
   p_location_code   IN     VARCHAR2,
   p_type            IN     VARCHAR2,
   p_qty             IN     VARCHAR2,
   p_err                OUT VARCHAR2)
IS
   lvs_item_code               VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_bosch_item_code         VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvi_count                   NUMBER; -- [AI] 내부 처리용 변수
   lvs_barcode                 VARCHAR2 (200); -- [AI] 내부 처리용 변수
   lvs_location_address_rack   VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_suppliercode            VARCHAR2 (20); -- [AI] 내부 처리용 변수
   lvi_material_exists         NUMBER; -- [AI] 내부 처리용 변수
   LVI_CHECK_LINE              NUMBER; -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
   -----------------------------------------------------------------------
   --   P_TYPE : N = NORMAL , C = CANCEL
   --   1 : BARCODE INVALID
   --   2 : ITEM NOT FOUND
   --   3 : DELETE DATA NOT FOUND
   --   9 : SQLERROR
   -----------------------------------------------------------------------


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



   IF P_MODEL_NAME IS NULL OR P_MODEL_NAME = '*'
   THEN
      p_err := f_msg('[REQ:02] MODEL INVALID : 모델이 틀립니다.','C',1);
      RETURN;
   END IF;


   SELECT COUNT (*)
     INTO LVI_CHECK_LINE
     FROM IP_PRODUCT_LINE
    WHERE LINE_CODE = SUBSTR (P_LINE_CODE, 1, 2);

   IF NVL (LVI_CHECK_LINE, 0) = 0
   THEN
      p_err := f_msg('[REQ:03] LINE INVALID : 라인이 틀립니다.','C',1);
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
   -- 취소
   ----------------------------------------------------------------------
   IF p_type = 'C'
   THEN
      -------------------------------------------------------------------------
      --
      -------------------------------------------------------------------------

      SELECT COUNT (*)
        INTO lvi_count
        FROM im_item_request
       WHERE     item_code = lvs_item_code
             AND LINE_CODE = SUBSTR (P_LINE_CODE, 1, 2)
             AND MODEL_NAME = P_MODEL_NAME
             AND location_code = p_location_code
             AND request_status = 'R'
             ;

      IF NVL (lvi_count, 0) = 0
      THEN
         P_ERR :=
               SUBSTR (P_LINE_CODE, 1, 2)
            || ' '
            || P_MODEL_NAME
            || ' '
            || p_location_code
            || ' '
            || lvs_item_code
            || f_msg(' NOT FOUND FOR CANCEL','C',1);
         RETURN;
      END IF;

      ----------------------------------------------
      -- 가장 최근꺼 취소
      ----------------------------------------------

      DELETE FROM im_item_request
       WHERE     item_code = lvs_item_code
             AND LINE_CODE = SUBSTR (P_LINE_CODE, 1, 2)
             AND MODEL_NAME = P_MODEL_NAME
             AND location_code = p_location_code
             AND REQUEST_STATUS = 'R'
             AND request_date =
                    (SELECT MAX (REQUEST_DATE)
                       FROM im_item_request
                      WHERE     item_code = lvs_item_code
                            AND LINE_CODE = SUBSTR (P_LINE_CODE, 1, 2)
                            AND MODEL_NAME = P_MODEL_NAME
                            AND location_code = p_location_code
                            AND REQUEST_STATUS = 'R');

      P_ERR := '';
      RETURN;
   END IF;

     BEGIN

       SELECT MIN (NVL (a.location_address_rack, NVL (b.location_address, '*')))
         INTO lvs_location_address_rack
         FROM im_item_inventory a, id_item b
        WHERE a.item_code = b.item_code AND a.item_code = lvs_item_code
              AND a.last_receipt_date =
                     (SELECT MIN (last_receipt_date)
                        FROM im_item_inventory
                       WHERE item_code = lvs_item_code AND inventory_qty > 0 AND LOCATION_CODE <> 'M02')
              AND a.inventory_qty > 0
              AND A.LOCATION_CODE <> 'M02';

      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
          WHEN NO_DATA_FOUND
          THEN
             lvs_location_address_rack := '';
       END;



   ----------------------------------------------------------------------
   --  FEEDER LAYOUT CHECK
   ----------------------------------------------------------------------


      BEGIN
        SELECT COUNT (*)
          INTO lvi_material_exists
          FROM ib_product_plandata
         WHERE     line_code = SUBSTR (P_LINE_CODE, 1, 2)
               AND model_name = UPPER (p_model_name)
               AND item_code = UPPER (lvs_item_code)
               AND LOCATION_CODE = UPPER (p_location_code);
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
        WHEN NO_DATA_FOUND
        THEN
           lvi_material_exists := 0;
      END;



   IF lvi_material_exists = 0
   THEN
      p_err :=
            f_msg('[REQ:05] LAYOUT NOT FOUND : 피더레이아웃없는모델 : ' ,'C',1)
         || p_model_name
         || ' '
         || lvs_item_code
         || ' '
         || p_location_code;
     RETURN;
   END IF;

   --   ----------------------------------------------------------------------
   --   -- 이미 신청했는지 체크
   --   ----------------------------------------------------------------------
   --   lvi_count := 0;
   --
   --   SELECT COUNT (*)
   --     INTO lvi_count
   --     FROM im_item_request
   --    WHERE     item_code  = lvs_item_code
   --          AND LINE_CODE  = SUBSTR (P_LINE_CODE, 1, 2)
   --          AND MODEL_NAME = P_MODEL_NAME
   --          AND location_code = p_location_code
   --          AND request_status = 'R';
   --
   --   IF NVL (lvi_count, 0) > 0
   --   THEN
   --      P_ERR := '[REQ:06] ALREADY EXISTS';
   --      RETURN;
   --   END IF;

   INSERT INTO im_item_request (request_date,
                                request_sequence,
                                line_code,
                                workstage_code,
                                machine_code,
                                item_code,
                                location_code,
                                request_status,
                                confirm_date,
                                enter_by,
                                enter_date,
                                last_modify_by,
                                last_modify_date,
                                organization_id,
                                item_barcode,
                                location_address_rack,
                                model_name,
                                request_qty)
   VALUES (SYSDATE,
           seq_mat_issue_request.NEXTVAL,
           NVL (SUBSTR (p_line_code, 1, 2), '*'),
           '*',
           NVL (TRIM (SUBSTR (p_line_code, 4, 10)), '*'),
           NVL (lvs_item_code, p_item_barcode),
           p_location_code,
           'R',
           NULL,
           'SYSTEM',
           SYSDATE,
           'SYSTEM',
           SYSDATE,
           1,
           NULL,
           lvs_location_address_rack,
           p_model_name,
           NVL (TO_NUMBER (p_qty), 0));

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