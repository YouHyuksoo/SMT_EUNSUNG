CREATE OR REPLACE PROCEDURE "P_INVENTORY_ISSUE_BCD" (
  /* ================================================================
   * 프로시저명  : P_INVENTORY_ISSUE_BCD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2016-11-11
   * 수정이력:
   *   2016-11-11 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   제품, 재고, 입출고 또는 팔레트 관련 업무 데이터를 등록/갱신한다.
   *   대상 데이터의 존재 여부와 수량 조건을 확인한 뒤 원본 로직에 따라 처리한다.
   *   COMMIT/ROLLBACK 포함 여부는 원본 트랜잭션 흐름을 그대로 유지한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_DEFICIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ITEM - Item Master
   *   IM_ITEM_INVENTORY - Item Inventory Master
   *   IM_ITEM_ISSUE - Item Issue Master
   *   IM_ITEM_RECEIPT_BARCODE - 원본 로직 참조 테이블
   *   IM_ITEM_REQUEST - Item Request Master
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_ITEM_CODE_FROM_BARCODE
   *   F_GET_LOT_NO_FROM_BARCODE
   *   F_GET_LOT_QTY_FROM_BARCODE
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
   *   EXEC P_INVENTORY_ISSUE_BCD(...)
   * ================================================================ */
   P_BARCODE     IN     VARCHAR2,
   P_LINE_CODE   IN     VARCHAR2,
   P_DEFICIT     IN     VARCHAR2,
   P_OUT            OUT VARCHAR2)
IS
   LVS_ITEM_CODE               VARCHAR2 (30); -- [AI] 내부 처리용 변수
   LVS_BOSCH_ITEM_CODE         VARCHAR2 (30); -- [AI] 내부 처리용 변수
   LVS_LOT_NO                  VARCHAR2 (50); -- [AI] 내부 처리용 변수
   LVL_LOT_QTY                 NUMBER; -- [AI] 내부 처리용 변수
   LVS_BARCODE                 VARCHAR2 (100); -- [AI] 내부 처리용 변수
   LVS_LOCATION_CODE           VARCHAR2 (30); -- [AI] 내부 처리용 변수
   LVS_LINE_TYPE               VARCHAR2 (10); -- [AI] 내부 처리용 변수
   LVS_SLIP_NO                 VARCHAR2 (30); -- [AI] 내부 처리용 변수
   LVS_SUPPLIER_CODE           VARCHAR2 (30); -- [AI] 내부 처리용 변수
   LVS_SUPPLIER                VARCHAR2 (30); -- [AI] 내부 처리용 변수
   LVS_ISSUE_COMPARE_YN        VARCHAR2 (10); -- [AI] 내부 처리용 변수
   LVS_receipt_COMPARE_YN      VARCHAR2 (10); -- [AI] 내부 처리용 변수
   LVL_MSL_PASSED_TIME         NUMBER; -- [AI] 내부 처리용 변수
   LVDT_RECEIPT_COMPARE_DATE   DATE; -- [AI] 내부 처리용 변수
   LVS_LABEL_TYPE              VARCHAR2 (10); -- [AI] 내부 처리용 변수
   LVI_FIFO_COUNT              NUMBER; -- [AI] 내부 처리용 변수
   LVS_MAX_LOT_NO              VARCHAR2 (30); -- [AI] 내부 처리용 변수
   LVI_REQUEST_COUNT           NUMBER; -- [AI] 내부 처리용 변수
   LVL_SCAN_QTY                NUMBER; -- [AI] 내부 처리용 변수
   LVL_SEL_COUNT               NUMBER; -- [AI] 내부 처리용 변수
   LVS_BARCODE_INPUT           VARCHAR2 (100); -- [AI] 내부 처리용 변수

   LVS_LOCATION_ADDRESS_RACK   VARCHAR2 (30); -- [AI] 내부 처리용 변수
   PHASE                       VARCHAR2 (10); -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
   PHASE := '00';


   IF LENGTH (P_BARCODE) < 9
   THEN
      P_OUT := f_msg('바코드가 잘못 스캔 되었습니다','C',1);
   END IF;

   PHASE := '10';

   LVS_BARCODE := f_get_prepare_barcode (P_BARCODE);
   LVS_ITEM_CODE := F_GET_ITEM_CODE_FROM_BARCODE (P_BARCODE);

   BEGIN
      SELECT NVL (SUPPLIER_CODE, '*'), NVL (LINE_TYPE, 'F')
        INTO LVS_SUPPLIER, LVS_LINE_TYPE
        FROM ID_ITEM
       WHERE ITEM_CODE = LVS_ITEM_CODE;
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         LVS_SUPPLIER := '*';
   END;

   
      LVS_LOT_NO := F_GET_LOT_NO_FROM_BARCODE (P_BARCODE);
      LVL_LOT_QTY := F_GET_LOT_QTY_FROM_BARCODE (P_BARCODE);
  
   PHASE := '20';

   ------------------------------------------------------------------
   --
   ------------------------------------------------------------------
   IF LVS_LOT_NO = '' OR LVS_LOT_NO IS NULL
   THEN
      P_OUT := f_msg('롯트 번호가 잘못 되었습니다.','C',1);
   END IF;

   -------------------------------------------------------------------
   -- 신청내역에 있는지 체크 한다
   -------------------------------------------------------------------

   SELECT COUNT (*)
     INTO LVI_REQUEST_COUNT
     FROM IM_ITEM_REQUEST
    WHERE ITEM_CODE = LVS_ITEM_CODE AND REQUEST_STATUS = 'R';

   -------------------------------------------------------------------
   --
   -------------------------------------------------------------------

   BEGIN
      SELECT RECEIPT_SLIP_NO,
             NVL (SUPPLIER_CODE, '*'),
             NVL (ISSUE_COMPARE_YN, 'N'),
             NVL (RECEIPT_COMPARE_YN, 'N'),
             NVL (LABEL_TYPE, 'N'),
             NVL (MANUFACTURE_DATE, RECEIPT_COMPARE_DATE),
             NVL (MSL_PASSED_TIME, 0),
             NVL (SCAN_QTY, 0)
        INTO LVS_SLIP_NO,
             LVS_SUPPLIER_CODE,
             LVS_ISSUE_COMPARE_YN,
             LVS_RECEIPT_COMPARE_YN,
             LVS_LABEL_TYPE,
             LVDT_RECEIPT_COMPARE_DATE,
             LVL_MSL_PASSED_TIME,
             LVL_SCAN_QTY
        FROM IM_ITEM_RECEIPT_BARCODE
       WHERE     LOT_NO = LVS_LOT_NO
       --     AND ITEM_CODE = LVS_ITEM_CODE
             AND ORGANIZATION_ID = 1;
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         P_OUT :=
               'BCD='
            || P_BARCODE
            || ' ITEM='
            || LVS_ITEM_CODE
            || ' LOT='
            || LVS_LOT_NO
            || f_msg(' SLIP 스캔 이력이 없습니다','C',1);
         RETURN;
   END;

   PHASE := '40';

   IF LVS_SLIP_NO = '' OR LVS_SLIP_NO IS NULL
   THEN
      P_OUT := LVS_LOT_NO || f_msg(' SLIP 스캔 이력이 없습니다','C',1);
      RETURN;
   END IF;

   --======================================================
   -- 창고 위치를 자동 판단
   --======================================================
   IF LVS_LABEL_TYPE = 'R'
   THEN
      lvs_location_code := 'M06';                                 --리벌가능 대기 창고

   ELSIF LVS_LABEL_TYPE = 'B'
   THEN
      lvs_location_code := 'M05';                                      -- 벌크창고

   ELSE
      lvs_location_code := 'M01';                                       --양산창고

   END IF;

   --=======================================================
   --
   --=======================================================
   PHASE := '50';

   IF LVS_RECEIPT_COMPARE_YN = 'N'
   THEN
      P_OUT :=
         f_msg('입고 된  이력이 없습니다 입고처리 후 출고 하세요','C',1);
      RETURN;
   END IF;

   --===================================================
   --
   --===================================================
   IF LVS_ISSUE_COMPARE_YN = 'Y'
   THEN
      P_OUT := f_msg('이미 출고 되었습니다','C',1);
      RETURN;
   END IF;


   --=====================================================================
   -- 2016/11/11 SHS, location 이 불량창고(M02) 일경우 출고 못하도록 막음
   --=====================================================================

  PHASE := '55';

  SELECT NVL(SUM(1),0)
	  INTO LVL_SEL_COUNT
    FROM IM_ITEM_INVENTORY
   WHERE MATERIAL_MFS = LVS_LOT_NO
     AND LOCATION_CODE   = 'M02'
     AND INVENTORY_QTY   > 0 ;

  IF LVL_SEL_COUNT > 0  THEN

     P_OUT := 'BCD='
            || P_BARCODE
            || ' ITEM='
            || LVS_ITEM_CODE
            || ' LOT='
            || LVS_LOT_NO
            || f_msg(' 불량창고에 임고된 부품은 출고 불가 입니다','C',1);

      RETURN;

  END IF;

   --=====================================================
   --
   --=====================================================
   PHASE := '60';

   SELECT COUNT (*), MIN (LOT_NO)
     INTO LVI_FIFO_COUNT, LVS_MAX_LOT_NO
     FROM IM_ITEM_RECEIPT_BARCODE
    WHERE     LOT_NO = LVS_LOT_NO
          AND ITEM_CODE = LVS_ITEM_CODE
          AND RECEIPT_COMPARE_DATE < LVDT_RECEIPT_COMPARE_DATE
          AND ORGANIZATION_ID = 1;

   PHASE := '70';

   IF NVL (lvi_fifo_count, 0) > 0
   THEN
      SELECT MAX (location_address_rack)
        INTO LVS_LOCATION_ADDRESS_RACK
        FROM im_item_inventory
       WHERE material_mfs = LVS_LOT_NO AND organization_id = 1;


      P_OUT :=
            f_msg('랙번호=' ,'C',1) 
         || LVS_LOCATION_ADDRESS_RACK
         || f_msg('  롯트번호='  ,'C',1) 
         || LVS_MAX_LOT_NO
         || f_msg(' 선입선출 안된 자재.','C',1);
      RETURN;
   END IF;


   -------------------------------------------------------
   --출고 완료 플래그 설정
   -------------------------------------------------------
   PHASE := '80';

   UPDATE IM_ITEM_RECEIPT_BARCODE
      SET ISSUE_COMPARE_YN = 'Y',
          ISSUE_COMPARE_DATE = SYSDATE,
          ISSUE_COMPARE_BY = 'PDA',
          ISSUE_RETURN_YN = 'N',
          LINE_CODE = P_LINE_CODE,
          WORKSTAGE_CODE = '*'
    WHERE     LOT_NO = LVS_LOT_NO
          AND ITEM_CODE = LVS_ITEM_CODE
          AND ORGANIZATION_ID = 1;

   PHASE := '90';

   IF LVS_SUPPLIER = 'BOSCH'
   THEN
      IF SUBSTR (LVS_ITEM_CODE, 1, 1) = 'R'
         OR SUBSTR (LVS_ITEM_CODE, 1, 1) = 'D'
      THEN
         LVS_BARCODE_INPUT := LVS_BARCODE;
      ELSE
         LVS_BARCODE_INPUT := P_BARCODE;
      END IF;
   ELSE
      LVS_BARCODE_INPUT := P_BARCODE;
   END IF;


   INSERT INTO IM_ITEM_ISSUE (ITEM_CODE,
                              ISSUE_DATE,
                              ISSUE_SEQUENCE,
                              ORGANIZATION_ID,
                              MFS,
                              LOCATION_CODE,
                              ITEM_TYPE,
                              LINE_CODE,
                              WORKSTAGE_CODE,
                              ISSUE_DEFICIT,
                              ISSUE_QTY,
                              ISSUE_STATUS,
                              ISSUE_AMT,
                              ISSUE_ACCOUNT,
                              LINE_TYPE,
                              COMMENTS,
                              ISSUE_PRICE,
                              VIRTUAL_RECEIPT_YN,
                              ISSUE_TYPE,
                              SUPPLIER_CODE,
                              WORK_ORDER_NO,
                              ENTER_DATE,
                              ENTER_BY,
                              LAST_MODIFY_DATE,
                              LAST_MODIFY_BY,
                              MACHINE_CODE,
                              INVOICE_NO,
                              MADE_BY,
                              PARENT_ITEM_CODE,
                              MATERIAL_MFS,
                              INTERFACE_YN,
                              INTERFACE_DATE,
                              SALE_PRICE,
                              SALE_AMT,
                              SALE_CURRENCY,
                              ARRIVAL_DATE,
                              ARRIVAL_SEQ_NO,
                              DEST_ORGANIZATION_ID,
                              INSPECT_NO,
                              RETURN_REQUEST_DATE,
                              RETURN_REQUEST_SEQUENCE,
                              CLOSE_YN,
                              CLOSE_DATE,
                              DEMAND_QTY,
                              BARCODE)
   VALUES (LVS_ITEM_CODE,                                        -- ITEM_CODE,
           TRUNC (SYSDATE),                                     -- ISSUE_DATE,
           SEQ_MAT_ISSUE.NEXTVAL,                           -- ISSUE_SEQUENCE,
           1,                                              -- ORGANIZATION_ID,
           '*',                                                        -- MFS,
           LVS_LOCATION_CODE,                                -- LOCATION_CODE,
           'T',                                                  -- ITEM_TYPE,
           P_LINE_CODE,                                          -- LINE_CODE,
           '*',                                             -- WORKSTAGE_CODE,
           3,                                                -- ISSUE_DEFICIT,
           LVL_LOT_QTY,                                          -- ISSUE_QTY,
           'N',                                               -- ISSUE_STATUS,
           0,                                                    -- ISSUE_AMT,
           'M001',                                           -- ISSUE_ACCOUNT,
           LVS_LINE_TYPE,
           -- 'F',
           -- LINE_TYPE,
           LVS_LOCATION_ADDRESS_RACK,
           -- COMMENTS,
           0,
           -- ISSUE_PRICE,
           NULL,
           -- VIRTUAL_RECEIPT_YN,
           'N',
           -- ISSUE_TYPE,
           LVS_SUPPLIER_CODE,
           -- SUPPLIER_CODE,
           '*',
           -- WORK_ORDER_NO,
           SYSDATE,
           -- ENTER_DATE,
           'PDA',
           -- ENTER_BY,
           SYSDATE,
           -- LAST_MODIFY_DATE,
           'PDA',
           -- LAST_MODIFY_BY,
           '*',
           -- MACHINE_CODE,
           LVS_SLIP_NO,
           -- INVOICE_NO,
           NULL,
           -- MADE_BY,
           '*',
           -- PARENT_ITEM_CODE,
           LVS_LOT_NO,
           -- MATERIAL_MFS,
           NULL,
           -- INTERFACE_YN,
           NULL,
           -- INTERFACE_DATE,
           NULL,
           -- SALE_PRICE,
           NULL,
           -- SALE_AMT,
           NULL,
           -- SALE_CURRENCY,
           NULL,
           -- ARRIVAL_DATE,
           NULL,
           -- ARRIVAL_SEQ_NO,
           NULL,
           -- DEST_ORGANIZATION_ID,
           NULL,
           -- INSPECT_NO,
           NULL,
           -- RETURN_REQUEST_DATE,
           NULL,
           -- RETURN_REQUEST_SEQUENCE,
           'N',
           -- CLOSE_YN,
           NULL,
           -- CLOSE_DATE,
           NULL,
           -- DEMAND_QTY
           LVS_BARCODE_INPUT);

   PHASE := '100';

   --   --------------------------------------------------------------------------
   --   --  출고완료 처리
   --   --------------------------------------------------------------------------
   --
   --   UPDATE IM_ITEM_REQUEST
   --      SET REQUEST_STATUS = 'C',
   --          MATERIAL_MFS = LVS_LOT_NO,
   --          ITEM_BARCODE = LVS_BARCODE_INPUT,
   --          LOCATION_ADDRESS_RACK = LVS_LOCATION_ADDRESS_RACK,
   --          ISSUE_QTY = LVL_SCAN_QTY,
   --          CONFIRM_DATE = SYSDATE,
   --          ISSUE_DATE = SYSDATE
   --    WHERE     ITEM_CODE = LVS_ITEM_CODE
   --          AND REQUEST_STATUS = 'R'
   --          AND LINE_CODE = SUBSTR(P_LINE_CODE,1,2)
   --          AND REQUEST_DATE =
   --                 (SELECT MIN (REQUEST_DATE)
   --                    FROM IM_ITEM_REQUEST
   --                   WHERE     ITEM_CODE = LVS_ITEM_CODE
   --                         AND REQUEST_STATUS = 'R'
   --                         AND LINE_CODE = SUBSTR(P_LINE_CODE,1,2));
   --
   --
   --   COMMIT;
   --
   --------------------------------------------------------------------------
   --  출고요청건 중 동일 자재가 미처리인경우 자재위치 다시처리
   --------------------------------------------------------------------------
   /*
    SELECT MIN (NVL (a.location_address_rack, NVL (b.location_address, '*')))
      INTO LVS_LOCATION_ADDRESS_RACK
      FROM im_item_inventory a, id_item b
     WHERE a.item_code = b.item_code
       AND a.item_code = LVS_ITEM_CODE
       AND a.last_receipt_date = (SELECT MIN (last_receipt_date)
                                   FROM im_item_inventory
                                  WHERE item_code = LVS_ITEM_CODE
                                    AND INVENTORY_QTY > 0 AND LOCATION_CODE <> 'M02')
       AND a.inventory_qty > 0
       AND a.LOCATION_CODE <> 'M02';
   */
   IF LVS_SUPPLIER_CODE = 'BOSCH'
   THEN
      IF SUBSTR (UPPER (LVS_ITEM_CODE), 1, 1) = 'R'
         OR SUBSTR (UPPER (LVS_ITEM_CODE), 1, 1) = 'D'
      THEN
         lvs_bosch_item_code := SUBSTR (UPPER (LVS_ITEM_CODE), 2, 10);
      ELSE
         lvs_bosch_item_code := LVS_ITEM_CODE;
      END IF;

      SELECT MIN (
                NVL (a.location_address_rack, NVL (b.location_address, '*')))
        INTO LVS_LOCATION_ADDRESS_RACK
        FROM im_item_inventory a, id_item b
       WHERE a.item_code = b.item_code
             AND a.item_code LIKE '%' || lvs_bosch_item_code
             AND a.last_receipt_date =
                    (SELECT MIN (last_receipt_date)
                       FROM im_item_inventory
                      WHERE     item_code LIKE '%' || lvs_bosch_item_code
                            AND INVENTORY_QTY > 0
                            AND LOCATION_CODE <> 'M02')
             AND a.inventory_qty > 0
             AND a.LOCATION_CODE <> 'M02';
   ELSE
      SELECT MIN (
                NVL (a.location_address_rack, NVL (b.location_address, '*')))
        INTO LVS_LOCATION_ADDRESS_RACK
        FROM im_item_inventory a, id_item b
       WHERE a.item_code = b.item_code AND a.item_code = LVS_ITEM_CODE
             AND a.last_receipt_date =
                    (SELECT MIN (last_receipt_date)
                       FROM im_item_inventory
                      WHERE     item_code = LVS_ITEM_CODE
                            AND INVENTORY_QTY > 0
                            AND LOCATION_CODE <> 'M02')
             AND a.inventory_qty > 0
             AND a.LOCATION_CODE <> 'M02';
   END IF;


   UPDATE IM_ITEM_REQUEST
      SET LOCATION_ADDRESS_RACK = LVS_LOCATION_ADDRESS_RACK
    WHERE     ITEM_CODE = LVS_ITEM_CODE
          AND REQUEST_STATUS = 'R'
          AND LINE_CODE = SUBSTR (P_LINE_CODE, 1, 2);


   COMMIT;
   P_OUT := 'OK';
---------------------------------------------------------------------------
--
---------------------------------------------------------------------------
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN NO_DATA_FOUND
   THEN
      P_OUT := 'NG';
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
      RAISE_APPLICATION_ERROR (-20003, 'PHASE=' || PHASE || ' ' || SQLERRM);
END ;