-- PKG_MES_PLN — PB 이관 산출물 전용 생산(PLN) 패키지
--
-- 기존 전역 FUNCTION/PROCEDURE 와 이름이 충돌하지 않도록
-- 웹 이관으로 생기는 오브젝트는 전부 이 패키지 안에만 만든다.
-- standalone FUNCTION/PROCEDURE 로 만들지 않는다.
--
-- 오브젝트를 추가할 때는 이 파일에 얹어 SPEC/BODY 를 통째로 다시 배포한다.

CREATE OR REPLACE PACKAGE PKG_MES_PLN AS

  /**
   * PB f_get_marking_yn 이관 (2026-09-26)
   * 모델의 마킹 사용여부. 조회 실패 시 PB 원본과 같이 'N' 을 돌려준다.
   */
  FUNCTION F_GET_MARKING_YN(
    p_model_name      IN VARCHAR2,
    p_organization_id IN NUMBER
  ) RETURN VARCHAR2;

  /**
   * PB f_get_carrier_size 이관 (2026-09-26)
   * 모델의 캐리어 규격. 모델이 없으면 -1, 값이 비어 있으면 0 (PB 규약 유지).
   */
  FUNCTION F_GET_CARRIER_SIZE(
    p_model_name      IN VARCHAR2,
    p_organization_id IN NUMBER
  ) RETURN NUMBER;

  /**
   * PB f_get_magazine_lot_qty 이관 (2026-09-26)
   * 매거진 라벨의 LOT 수량. 라벨이 없으면 PB 원본과 같이 0 을 돌려준다.
   */
  FUNCTION F_GET_MAGAZINE_LOT_QTY(
    p_magazine_label_no IN VARCHAR2,
    p_organization_id   IN NUMBER
  ) RETURN NUMBER;

END PKG_MES_PLN;
/

CREATE OR REPLACE PACKAGE BODY PKG_MES_PLN AS

  /** PB f_get_marking_yn 이관 (2026-09-26) */
  FUNCTION F_GET_MARKING_YN(
    p_model_name      IN VARCHAR2,
    p_organization_id IN NUMBER
  ) RETURN VARCHAR2 IS
    l_return IP_PRODUCT_MODEL_MASTER.MARKING_YN%TYPE;
  BEGIN
    SELECT MAX(MARKING_YN)
      INTO l_return
      FROM IP_PRODUCT_MODEL_MASTER
     WHERE MODEL_NAME      = p_model_name
       AND ORGANIZATION_ID = p_organization_id;
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 'N';   -- PB: f_sql_check() < 0 이면 'N'
  END F_GET_MARKING_YN;

  /** PB f_get_carrier_size 이관 (2026-09-26) */
  FUNCTION F_GET_CARRIER_SIZE(
    p_model_name      IN VARCHAR2,
    p_organization_id IN NUMBER
  ) RETURN NUMBER IS
    l_count  NUMBER;
    l_return NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM IP_PRODUCT_MODEL_MASTER
     WHERE MODEL_NAME      = p_model_name
       AND ORGANIZATION_ID = p_organization_id;

    IF l_count = 0 THEN
      RETURN -1;    -- PB: 모델이 없으면 -1
    END IF;

    SELECT NVL(MAX(CARRIER_SIZE), 0)
      INTO l_return
      FROM IP_PRODUCT_MODEL_MASTER
     WHERE MODEL_NAME      = p_model_name
       AND ORGANIZATION_ID = p_organization_id;

    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;     -- PB: 두 번째 조회가 실패하면 0
  END F_GET_CARRIER_SIZE;

  /** PB f_get_magazine_lot_qty 이관 (2026-09-26) */
  FUNCTION F_GET_MAGAZINE_LOT_QTY(
    p_magazine_label_no IN VARCHAR2,
    p_organization_id   IN NUMBER
  ) RETURN NUMBER IS
    l_return NUMBER;
  BEGIN
    SELECT LOT_QTY
      INTO l_return
      FROM IP_PRODUCT_RUN_CARD_IO
     WHERE MAGAZINE_LABEL_NO = p_magazine_label_no
       AND ORGANIZATION_ID   = p_organization_id;
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;     -- PB: 라벨이 없거나 조회 실패면 초기값 0
  END F_GET_MAGAZINE_LOT_QTY;

END PKG_MES_PLN;
/
