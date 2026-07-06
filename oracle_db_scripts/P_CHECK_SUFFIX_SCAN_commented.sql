CREATE OR REPLACE PROCEDURE "P_CHECK_SUFFIX_SCAN" (p_line_code    IN     VARCHAR2,
  /* ================================================================
   * 프로시저명  : P_CHECK_SUFFIX_SCAN
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2015-05-18
   * 수정이력:
   *   2015-05-18 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건을 기준으로 상태 또는 기준 데이터의 유효성을 확인한다.
   *   조회 결과와 원본 분기 조건에 따라 OUT 파라미터 또는 관련 상태 값을 설정한다.
   *   호출부가 결과 코드와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_MODEL_NAME - 원본 선언부 기준 입력/출력 파라미터
   *   P_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_DEFICIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 원본 로직 참조 테이블
   *   ID_ENG_BOM_SMT_NO_REPLACE - 원본 로직 참조 테이블
   *   ID_ITEM - Item Master
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
   *   EXEC P_CHECK_SUFFIX_SCAN(...)
   * ================================================================ */
/* Formatted on 2015-05-18 10:02:25 (QP5 v5.126) */
                               p_model_name   IN     VARCHAR2,
                               p_barcode      IN     VARCHAR2,
                               p_deficit      IN     VARCHAR2,
                               p_out             OUT VARCHAR2)
IS
    lvi_count           NUMBER; -- [AI] 내부 처리용 변수
    lvi_suffix_count    NUMBER; -- [AI] 내부 처리용 변수
    lvs_item_code       VARCHAR2 (20); -- [AI] 내부 처리용 변수
    lvs_location_code   VARCHAR2 (20); -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
    IF p_deficit = 'N'
    THEN
        BEGIN
            SELECT   COUNT ( * )
              INTO   lvi_count
              FROM   ib_product_plandata
             WHERE   line_code = SUBSTR (p_line_code, 1, 2)
                 AND model_name = p_model_name
                 AND active_yn = 'Y'
                 AND organization_id = 1;
        EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
            WHEN NO_DATA_FOUND
            THEN
                p_out := p_line_code || '  ' || p_model_name || f_msg(' NOT FOUND','C',1);
                RETURN;
        END;

        ---------------------------------------------------------------------
        --
        ---------------------------------------------------------------------
        BEGIN
            SELECT   COUNT ( * )
              INTO   lvi_suffix_count
              FROM   id_item
             WHERE   model_name = p_model_name AND model_suffix = p_barcode AND organization_id = 1;
        EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
            WHEN NO_DATA_FOUND
            THEN
                lvi_suffix_count := 0;
        END;

        p_out := p_line_code || '  ' || p_model_name || ' ' || p_barcode || f_msg(' NOT FOUND','C',1);
        RETURN;

        -------------------------------------------------------------------
        -- NO REPLACE ITEM CHECK
        -------------------------------------------------------------------
        BEGIN
            SELECT   MAX (item_code), MAX (location_code), COUNT ( * )
              INTO   lvs_item_code, lvs_location_code, lvi_count
              FROM   ib_product_plandata
             WHERE   item_code IN
                             (SELECT   replace_item_code
                                FROM   id_eng_bom_smt_no_replace
                               WHERE   line_code = SUBSTR (p_line_code, 1, 2)
                                   AND model_name = p_model_name
                                   AND model_suffix = p_barcode);
        EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
            WHEN NO_DATA_FOUND
            THEN
                lvi_count := 0;
        END;

        IF lvi_count > 0
        THEN
            p_out := 'NG ' || lvs_item_code || ' ' || lvs_location_code || f_msg(' NO REPLACE ITEM EXISTS','C',1);
            RETURN;
        END IF;

        -------------------------------------------------------------------
        -- update
        -------------------------------------------------------------------

        UPDATE   ib_product_plandata
           SET   model_suffix = p_barcode
         WHERE   line_code = SUBSTR (p_line_code, 1, 2)
             AND model_name = p_model_name
             AND active_yn = 'Y'
             AND organization_id = 1;
    -------------------------------------------------------------------
    -- CANCEL
    -------------------------------------------------------------------
    ELSE
        UPDATE   ib_product_plandata
           SET   model_suffix = NULL
         WHERE   line_code = SUBSTR (p_line_code, 1, 2)
             AND model_name = p_model_name
             AND active_yn = 'Y'
             AND organization_id = 1;
    END IF;

    COMMIT;
    p_out := 'OK';
    RETURN;
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
    WHEN OTHERS
    THEN
        p_out := 'NG';
        RETURN;
END;