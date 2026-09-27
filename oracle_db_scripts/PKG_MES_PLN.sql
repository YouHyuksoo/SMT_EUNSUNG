-- PKG_MES_PLN — PB 이관 산출물 전용 생산(PLN) 패키지
--
-- 기존 전역 FUNCTION/PROCEDURE 와 이름이 충돌하지 않도록
-- 웹 이관으로 생기는 오브젝트는 전부 이 패키지 안에만 만든다.
-- standalone FUNCTION/PROCEDURE 로 만들지 않는다.
--
-- 오브젝트를 추가할 때는 이 파일에 얹어 SPEC/BODY 를 통째로 다시 배포한다.
--
-- ─────────────────────────────────────────────────────────────────────────
-- 확인한 것 (실측 근거를 남긴다)
--
--   · IP_PRODUCT_2D_BARCODE 는 약 1.8억 행이다. RUN_NO 는
--     INDXIP_PRODUCT_2D_BARCODE2(RUN_NO, SERIAL_NO) 의 선두 컬럼이므로
--     이 패키지의 모든 접근은 RUN_NO 등호 조건을 반드시 건다.
--     PB 도 `RUN_NO = :arg_run_no` 등호였다.
--
--   · PB 의 DELETE 들은 조직조건을 갖고 있다 (w_pln_product_pcb_kitting_scan_master
--     953행, w_product_run_card 1683행, w_product_run_card_duckil 606행).
--     SMT 에서 나온 무방비 DELETE 유형은 생산 화면에는 없다.
--
--   · IP_PRODUCT_RUN_CARD.RUN_TYPE_CODE 는 38,899행 전부 NULL 이고
--     'RUN TYPE CODE' 코드표도 없다. 이 패키지는 그 컬럼을 읽지도 쓰지도 않는다.
-- ─────────────────────────────────────────────────────────────────────────

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

  /**
   * PB w_pln_product_pcb_kitting_scan_master 스캔(등록) 이관 (2026-09-27)
   *
   * 롯트카드에 PCB 한 장(PID)을 매핑한다. PB 가 걸던 검사를 그대로 유지한다:
   *   1) 같은 PID 가 이미 있으면 거부 ("Already Exists").
   *   2) 모델매칭을 켜면 PID 7~11번째 다섯 글자와 모델명 7~11번째가 같아야 한다.
   *      PB 의 `mid(model,7,5) = mid(pid,7,5)` 를 그대로 옮겼다.
   *   3) 롯트카드가 없으면 거부.
   *
   * 넣는 값은 PB 와 같다 — 롯트카드에서 모델·라인·품목·작업일을 그대로 가져오고
   * QC_SCAN_YN='N', WORKSTAGE_CODE='*', BARCODE_STATUS='N', LOT_QTY=1 을 고정한다.
   *
   * p_result : 1  매핑 성공
   *           -1  롯트카드가 없음
   *           -2  같은 PID 가 이 롯트카드에 이미 있음
   *           -3  모델매칭 불일치
   *           -4  같은 PID 가 다른 롯트카드에 이미 매핑되어 있음
   *               (PB 는 현재 롯트카드 화면 안에서만 중복을 봤다. PID 는 제품
   *                한 장을 가리키므로 두 롯트카드에 동시에 들어가면 추적이 갈린다.)
   */
  PROCEDURE SP_PLN_KITTING_SCAN(
    p_run_no         IN  VARCHAR2,
    p_serial_no      IN  VARCHAR2,
    p_model_matching IN  VARCHAR2,          -- 'Y' | 'N'
    p_org            IN  NUMBER,
    p_user           IN  VARCHAR2,
    p_result         OUT NUMBER
  );

  /**
   * PB w_pln_product_pcb_kitting_scan_master 취소 이관 (2026-09-27)
   *
   * 매핑한 PID 를 되돌린다. PB 가 걸던 검사를 유지한다 —
   * QC 스캔이 끝난(QC_SCAN_YN='Y') PID 는 취소할 수 없다.
   *
   * p_result : 1  취소 성공
   *           -1  그 롯트카드에 그 PID 가 없음
   *           -2  이미 QC 스캔된 PID 다
   */
  PROCEDURE SP_PLN_KITTING_CANCEL(
    p_run_no    IN  VARCHAR2,
    p_serial_no IN  VARCHAR2,
    p_org       IN  NUMBER,
    p_result    OUT NUMBER
  );

  /**
   * PB w_pln_product_pcb_kitting_scan_master 의 '전체 해제' 이관 (2026-09-27)
   *
   * 한 롯트카드의 PID 매핑을 통째로 지운다. PB 953행의
   * `delete from ip_product_2d_barcode where run_no = ... and organization_id = ...` 다.
   * QC 스캔된 PID 가 한 장이라도 있으면 지우지 않는다 — PB 는 전체 해제에서는
   * 그 검사를 하지 않아 검사이력이 가리키는 바코드가 사라질 수 있었다.
   *
   * p_result : 지운 행수
   *           -1  롯트카드가 없음
   *           -2  QC 스캔된 PID 가 있음 (절대값/2 가 그 건수)
   */
  PROCEDURE SP_PLN_KITTING_CLEAR(
    p_run_no IN  VARCHAR2,
    p_org    IN  NUMBER,
    p_result OUT NUMBER
  );

  /**
   * PB w_product_run_card_duckil 의 롯트카드 삭제 이관 (2026-09-27)
   *
   * 은성 메뉴의 '롯트카드관리' 는 w_product_run_card_duckil 이다.
   * 일반판(w_product_run_card)이 하지 않는 일이 하나 있다 — 롯트카드를 지울 때
   * **반제품생산계획을 해제한다**:
   *     UPDATE IP_PRODUCT_SMD_PLAN SET PLAN_STATUS='W', MFS='*'
   *      WHERE MFS = :run_no AND ORGANIZATION_ID = :org
   * 이것을 빠뜨리면 계획이 사라진 롯트카드를 계속 가리켜 다시 롯트카드를
   * 만들 수 없다. 그래서 이 프로시저에 넣었다.
   *
   * 지우는 순서 (PB 와 같다):
   *   ① PID 매핑 (IP_PRODUCT_2D_BARCODE)
   *   ② 롯트카드 상세 (IP_PRODUCT_RUN_CARD_DETAIL)
   *   ③ 반제품생산계획 해제 (IP_PRODUCT_SMD_PLAN)
   *   ④ 롯트카드 (IP_PRODUCT_RUN_CARD)
   *
   * QC 스캔된 PID 나 공정실적(IP_PRODUCT_WORKSTAGE_IO)이 있으면 지우지 않는다.
   * 실적이 붙은 롯트카드를 지우면 실적이 없는 작업지시를 가리킨다.
   *
   * p_result : 지운 행수 합계 (① + ② + ④)
   *           -1  롯트카드가 없음
   *           -2  QC 스캔된 PID 가 있음
   *           -3  공정실적이 있음
   */
  PROCEDURE SP_PLN_RUN_CARD_DELETE_CASCADE(
    p_run_no IN  VARCHAR2,
    p_org    IN  NUMBER,
    p_user   IN  VARCHAR2,
    p_result OUT NUMBER
  );

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

  PROCEDURE SP_PLN_KITTING_SCAN(
    p_run_no         IN  VARCHAR2,
    p_serial_no      IN  VARCHAR2,
    p_model_matching IN  VARCHAR2,
    p_org            IN  NUMBER,
    p_user           IN  VARCHAR2,
    p_result         OUT NUMBER
  ) IS
    v_model   VARCHAR2(100);
    v_line    VARCHAR2(30);
    v_item    VARCHAR2(100);
    v_date    DATE;
    v_cnt     NUMBER;
    v_other   VARCHAR2(100);
  BEGIN
    BEGIN
      -- IP_PRODUCT_RUN_CARD 에는 MODEL_SUFFIX 컬럼이 없다. PB 도 여기서 가져오지
      -- 않았다 — lvs_model_suffix 는 선언만 되고 대입이 없는 빈 문자열이라
      -- 바코드의 MODEL_SUFFIX 에 빈 값(= Oracle NULL)이 들어갔다. 그대로 둔다.
      SELECT MODEL_NAME, LINE_CODE, ITEM_CODE, RUN_DATE
        INTO v_model, v_line, v_item, v_date
        FROM IP_PRODUCT_RUN_CARD
       WHERE RUN_NO = p_run_no AND ORGANIZATION_ID = p_org;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      p_result := -1;
      RETURN;
    END;

    -- 같은 롯트카드에 이미 있나 (PB: dw_2.find 로 화면 안에서 찾던 것)
    SELECT COUNT(*) INTO v_cnt
      FROM IP_PRODUCT_2D_BARCODE
     WHERE RUN_NO = p_run_no
       AND SERIAL_NO = p_serial_no
       AND ORGANIZATION_ID = p_org;
    IF v_cnt > 0 THEN
      p_result := -2;
      RETURN;
    END IF;

    -- 모델매칭. PB 의 mid(x,7,5) 는 Oracle SUBSTR(x,7,5) 와 같다.
    IF NVL(p_model_matching, 'N') = 'Y'
       AND SUBSTR(v_model, 7, 5) <> SUBSTR(p_serial_no, 7, 5) THEN
      p_result := -3;
      RETURN;
    END IF;

    -- 다른 롯트카드에 이미 매핑되어 있나 (PB 에 없던 검사. 헤더 주석 참고)
    -- SERIAL_NO 는 INDXIP_PRODUCT_2D_BARCODE 의 선두 컬럼이라 인덱스를 탄다.
    BEGIN
      SELECT MAX(RUN_NO) INTO v_other
        FROM IP_PRODUCT_2D_BARCODE
       WHERE SERIAL_NO = p_serial_no
         AND ORGANIZATION_ID = p_org
         AND RUN_NO <> p_run_no;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      v_other := NULL;
    END;
    IF v_other IS NOT NULL THEN
      p_result := -4;
      RETURN;
    END IF;

    INSERT INTO IP_PRODUCT_2D_BARCODE
      (RUN_NO, SERIAL_NO, LABEL_TEXT, MODEL_NAME, MODEL_SUFFIX, ITEM_CODE,
       LINE_CODE, RUN_DATE, QC_SCAN_YN, WORKSTAGE_CODE, BARCODE_STATUS, LOT_QTY,
       ORGANIZATION_ID, ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
    VALUES
      (p_run_no, p_serial_no, p_serial_no, v_model, NULL, v_item,
       v_line, v_date, 'N', '*', 'N', 1,
       p_org, p_user, SYSDATE, p_user, SYSDATE);

    p_result := 1;
  END SP_PLN_KITTING_SCAN;


  PROCEDURE SP_PLN_KITTING_CANCEL(
    p_run_no    IN  VARCHAR2,
    p_serial_no IN  VARCHAR2,
    p_org       IN  NUMBER,
    p_result    OUT NUMBER
  ) IS
    v_qc VARCHAR2(1);
  BEGIN
    BEGIN
      SELECT NVL(QC_SCAN_YN, 'N') INTO v_qc
        FROM IP_PRODUCT_2D_BARCODE
       WHERE RUN_NO = p_run_no
         AND SERIAL_NO = p_serial_no
         AND ORGANIZATION_ID = p_org;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      p_result := -1;
      RETURN;
    END;

    IF v_qc = 'Y' THEN
      p_result := -2;
      RETURN;
    END IF;

    DELETE FROM IP_PRODUCT_2D_BARCODE
     WHERE RUN_NO = p_run_no
       AND SERIAL_NO = p_serial_no
       AND ORGANIZATION_ID = p_org;

    p_result := 1;
  END SP_PLN_KITTING_CANCEL;


  PROCEDURE SP_PLN_KITTING_CLEAR(
    p_run_no IN  VARCHAR2,
    p_org    IN  NUMBER,
    p_result OUT NUMBER
  ) IS
    v_cnt NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_cnt
      FROM IP_PRODUCT_RUN_CARD
     WHERE RUN_NO = p_run_no AND ORGANIZATION_ID = p_org;
    IF v_cnt = 0 THEN
      p_result := -1;
      RETURN;
    END IF;

    SELECT COUNT(*) INTO v_cnt
      FROM IP_PRODUCT_2D_BARCODE
     WHERE RUN_NO = p_run_no
       AND ORGANIZATION_ID = p_org
       AND NVL(QC_SCAN_YN, 'N') = 'Y';
    IF v_cnt > 0 THEN
      p_result := -2 * v_cnt;
      RETURN;
    END IF;

    DELETE FROM IP_PRODUCT_2D_BARCODE
     WHERE RUN_NO = p_run_no AND ORGANIZATION_ID = p_org;

    p_result := SQL%ROWCOUNT;
  END SP_PLN_KITTING_CLEAR;


  PROCEDURE SP_PLN_RUN_CARD_DELETE_CASCADE(
    p_run_no IN  VARCHAR2,
    p_org    IN  NUMBER,
    p_user   IN  VARCHAR2,
    p_result OUT NUMBER
  ) IS
    v_cnt NUMBER;
    v_sum NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO v_cnt
      FROM IP_PRODUCT_RUN_CARD
     WHERE RUN_NO = p_run_no AND ORGANIZATION_ID = p_org;
    IF v_cnt = 0 THEN
      p_result := -1;
      RETURN;
    END IF;

    SELECT COUNT(*) INTO v_cnt
      FROM IP_PRODUCT_2D_BARCODE
     WHERE RUN_NO = p_run_no
       AND ORGANIZATION_ID = p_org
       AND NVL(QC_SCAN_YN, 'N') = 'Y';
    IF v_cnt > 0 THEN
      p_result := -2;
      RETURN;
    END IF;

    SELECT COUNT(*) INTO v_cnt
      FROM IP_PRODUCT_WORKSTAGE_IO
     WHERE RUN_NO = p_run_no AND ORGANIZATION_ID = p_org;
    IF v_cnt > 0 THEN
      p_result := -3;
      RETURN;
    END IF;

    -- ① PID 매핑
    DELETE FROM IP_PRODUCT_2D_BARCODE
     WHERE RUN_NO = p_run_no AND ORGANIZATION_ID = p_org;
    v_sum := v_sum + SQL%ROWCOUNT;

    -- ② 롯트카드 상세
    DELETE FROM IP_PRODUCT_RUN_CARD_DETAIL
     WHERE RUN_NO = p_run_no AND ORGANIZATION_ID = p_org;
    v_sum := v_sum + SQL%ROWCOUNT;

    -- ③ 반제품생산계획 해제 — 일반판에는 없고 _duckil 에만 있는 처리다.
    --    빠뜨리면 계획이 사라진 롯트카드를 계속 가리켜 재발행이 막힌다.
    UPDATE IP_PRODUCT_SMD_PLAN
       SET PLAN_STATUS = 'W',
           MFS = '*',
           LAST_MODIFY_BY = p_user,
           LAST_MODIFY_DATE = SYSDATE
     WHERE MFS = p_run_no AND ORGANIZATION_ID = p_org;

    -- ④ 롯트카드
    DELETE FROM IP_PRODUCT_RUN_CARD
     WHERE RUN_NO = p_run_no AND ORGANIZATION_ID = p_org;
    v_sum := v_sum + SQL%ROWCOUNT;

    p_result := v_sum;
  END SP_PLN_RUN_CARD_DELETE_CASCADE;

END PKG_MES_PLN;
/
