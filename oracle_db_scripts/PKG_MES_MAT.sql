-- PKG_MES_MAT — PB 이관 산출물 전용 자재(MAT) 패키지
--
-- 기존 전역 FUNCTION/PROCEDURE(442/189개)와 이름이 충돌하지 않도록
-- 웹 이관으로 생기는 오브젝트는 전부 이 패키지 안에만 만든다.
-- standalone FUNCTION/PROCEDURE 로 만들지 않는다.
--
-- 오브젝트를 추가할 때는 이 파일에 얹어 SPEC/BODY 를 통째로 다시 배포한다.

CREATE OR REPLACE PACKAGE PKG_MES_MAT AS

  /**
   * PB f_mat_receipt_cancel 이관 (2026-09-25)
   *
   * 자재 입고 1건을 취소한다. 행을 지우지 않고 상계(역분개) 행을 새로 만든다.
   *   1) 원본 행의 RECEIPT_STATUS 를 'C' 로 바꾼다.
   *   2) SEQ_MAT_RECEIPT.NEXTVAL 로 새 순번을 받아 수량·금액 부호를 뒤집은 행을 INSERT 한다.
   *      RECEIPT_DEFICIT 는 1 <-> 2 로 뒤집고, 입고일자는 호출자가 지정한 취소일자를 쓴다.
   *
   * p_result : 1  상계 INSERT 성공 (PB 원본의 sqlca.sqlnrows 에 해당)
   *           -1  원본 입고건 조회 실패 또는 INSERT 실패 (PB 규약 유지)
   *           -2  이미 취소된 입고건 (웹 이관에서 추가. PB 원본에는 이 검사가 없다)
   *           -3  원본 행 UPDATE 실패 (PB 규약 유지)
   *
   * PB 원본에서 이미 주석 처리돼 있던 f_get_free_assy_issue_cost 호출은 옮기지 않았다.
   * 전역변수 gvi_organization_id / gvs_user_id 는 파라미터로 승격했다.
   */
  PROCEDURE SP_RECEIPT_CANCEL(
    p_receipt_date     IN  DATE,
    p_receipt_sequence IN  NUMBER,
    p_cancel_date      IN  DATE,
    p_organization_id  IN  NUMBER,
    p_user_id          IN  VARCHAR2,
    p_result           OUT NUMBER
  );

  /**
   * PB f_check_unit_price_dup 이관 (2026-09-26)
   * 유효기간이 겹치는 구매단가 중복 등록 검사.
   * 공급처+품목+라인유형 조합이 2건 이상이면 그 건수를, 중복이 없으면 0,
   * 중복 조합이 여러 개라 단일 값으로 못 줄이면 -1 (PB 규약 유지).
   */
  FUNCTION F_CHECK_UNIT_PRICE_DUP(
    p_item_code       IN VARCHAR2,
    p_organization_id IN NUMBER
  ) RETURN NUMBER;

END PKG_MES_MAT;
/

CREATE OR REPLACE PACKAGE BODY PKG_MES_MAT AS

  /** PB f_mat_receipt_cancel 이관 (2026-09-25) — 상세는 SPEC 주석 참조 */
  PROCEDURE SP_RECEIPT_CANCEL(
    p_receipt_date     IN  DATE,
    p_receipt_sequence IN  NUMBER,
    p_cancel_date      IN  DATE,
    p_organization_id  IN  NUMBER,
    p_user_id          IN  VARCHAR2,
    p_result           OUT NUMBER
  ) IS
    l_status      IM_ITEM_RECEIPT.RECEIPT_STATUS%TYPE;
    l_new_seq     NUMBER;
  BEGIN
    -- 원본 행을 잠그고 현재 상태를 읽는다 (PB 는 SELECT ... INTO 로 존재 확인만 했다)
    BEGIN
      SELECT RECEIPT_STATUS
        INTO l_status
        FROM IM_ITEM_RECEIPT
       WHERE RECEIPT_DATE     = p_receipt_date
         AND RECEIPT_SEQUENCE = p_receipt_sequence
         AND ORGANIZATION_ID  = p_organization_id
         FOR UPDATE;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_result := -1;
        RETURN;
    END;

    IF l_status = 'C' THEN
      p_result := -2;
      RETURN;
    END IF;

    UPDATE IM_ITEM_RECEIPT
       SET RECEIPT_STATUS = 'C'
     WHERE RECEIPT_DATE     = p_receipt_date
       AND RECEIPT_SEQUENCE = p_receipt_sequence
       AND ORGANIZATION_ID  = p_organization_id;

    IF SQL%ROWCOUNT <> 1 THEN
      p_result := -3;
      RETURN;
    END IF;

    SELECT SEQ_MAT_RECEIPT.NEXTVAL INTO l_new_seq FROM DUAL;

    INSERT INTO IM_ITEM_RECEIPT (
      RECEIPT_SEQUENCE, RECEIPT_DATE, LOCATION_CODE, RECEIPT_DEFICIT, DELIVERY, LINE_TYPE,
      RECEIPT_QTY, UNIT_PRICE, MATERIAL_COST, MATERIAL_COST_AMT, INVOICE_NO, RECEIPT_AMT,
      EXCHANGE_RATE, FOREIGN_RECEIPT_AMT, CONFIRM_YN, CONFIRM_DATE, RECEIPT_TYPE,
      MATERIAL_MFS, MFS, SUPPLIER_CODE, COMMENTS, CURRENCY, BARCODE, RECEIPT_STATUS,
      ITEM_CODE, ARRIVAL_DATE, ARRIVAL_SEQ_NO, ORGANIZATION_ID,
      ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE,
      VIRTUAL_RECEIPT_YN, WORK_ORDER_NO, INTERFACE_YN, INTERFACE_DATE, RECEIPT_LOT_NO,
      INCIDENTAL_EXPENSE_CODE, RECEIPT_EXPENSE_COST, INTERFACE_WORK_NO, TARIFF_RATE,
      TARIFF_AMT, ORDER_NO, ORIGIN_MFS, ORIGIN_SUPPLIER_CODE, INVOICE_OPEN_YN,
      INVOICE_OPEN_SEQUENCE, INVENTORY_TYPE
    )
    SELECT l_new_seq,
           TRUNC(p_cancel_date),
           LOCATION_CODE,
           DECODE(RECEIPT_DEFICIT, '1', '2', '2', '1'),
           DELIVERY, LINE_TYPE,
           RECEIPT_QTY * -1, UNIT_PRICE, MATERIAL_COST * -1, MATERIAL_COST_AMT * -1,
           INVOICE_NO, RECEIPT_AMT * -1, EXCHANGE_RATE, FOREIGN_RECEIPT_AMT * -1,
           CONFIRM_YN, CONFIRM_DATE, RECEIPT_TYPE,
           MATERIAL_MFS, MFS, SUPPLIER_CODE, COMMENTS, CURRENCY, BARCODE, 'C',
           ITEM_CODE, ARRIVAL_DATE, ARRIVAL_SEQ_NO, ORGANIZATION_ID,
           p_user_id, SYSDATE, p_user_id, SYSDATE,
           VIRTUAL_RECEIPT_YN, WORK_ORDER_NO, INTERFACE_YN, INTERFACE_DATE, RECEIPT_LOT_NO,
           INCIDENTAL_EXPENSE_CODE, RECEIPT_EXPENSE_COST, INTERFACE_WORK_NO, TARIFF_RATE,
           TARIFF_AMT, ORDER_NO, ORIGIN_MFS, ORIGIN_SUPPLIER_CODE, INVOICE_OPEN_YN,
           INVOICE_OPEN_SEQUENCE, INVENTORY_TYPE
      FROM IM_ITEM_RECEIPT
     WHERE RECEIPT_DATE     = p_receipt_date
       AND RECEIPT_SEQUENCE = p_receipt_sequence
       AND ORGANIZATION_ID  = p_organization_id;

    p_result := SQL%ROWCOUNT;   -- PB 원본의 sqlca.sqlnrows

    IF p_result <> 1 THEN
      p_result := -1;
    END IF;
  END SP_RECEIPT_CANCEL;

  /** PB f_check_unit_price_dup 이관 (2026-09-26) */
  FUNCTION F_CHECK_UNIT_PRICE_DUP(
    p_item_code       IN VARCHAR2,
    p_organization_id IN NUMBER
  ) RETURN NUMBER IS
    l_return NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO l_return
      FROM IM_ITEM_UNIT_PRICE
     WHERE ITEM_CODE       = p_item_code
       AND ORGANIZATION_ID = p_organization_id
       AND DATESET <= TRUNC(SYSDATE)
       AND DATEEND >= TRUNC(SYSDATE)
     GROUP BY SUPPLIER_CODE, ITEM_CODE, LINE_TYPE, ORGANIZATION_ID
    HAVING COUNT(*) > 1;
    RETURN l_return;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 0;     -- PB: 중복 조합이 없으면 초기값 0
    WHEN OTHERS THEN
      RETURN -1;    -- PB: f_sql_check() < 0 이면 -1 (중복 조합이 여러 개인 경우 포함)
  END F_CHECK_UNIT_PRICE_DUP;

END PKG_MES_MAT;
/
