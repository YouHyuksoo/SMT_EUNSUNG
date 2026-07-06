CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_RUN_NO_INFO
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 파라미터와 기준 테이블을 이용해 업무 코드, 명칭, 수량, 상태 등의 조회 값을 반환한다.
   *   조회 실패 또는 예외 상황에서는 원본 로직에 정의된 기본값/NULL/오류 처리를 따른다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_PID  (IN, VARCHAR2) - 제품 식별자
   *   P_OPTION  (IN, VARCHAR2) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_RUN_CARD - 제품 / 작업지시/런 관련 값 조회 또는 참조
   *   IP_PRODUCT_2D_BARCODE - 바코드 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_RUN_NO_INFO(...) FROM DUAL;
   * ================================================================ */
 "F_GET_RUN_NO_INFO" (p_pid    IN VARCHAR2,
                                              p_option IN VARCHAR2)
    RETURN VARCHAR2
IS
    lvs_return      VARCHAR2 (100);

    lvs_run_no      VARCHAR2 (100);
    lvs_comments    VARCHAR2 (100);
    lvs_marking_no  VARCHAR2 (100);
    lvs_lot_size    VARCHAR2 (100);

BEGIN

    BEGIN

        SELECT run_no,      -- run_no
               comments,    -- model.suffix,
               marking_no,   -- w/o
               lot_size     -- lot_qty
          INTO lvs_run_no,
               lvs_comments,
               lvs_marking_no,
               lvs_lot_size
          FROM ip_product_run_card
         WHERE run_no = (
                          select run_no
                            from ip_product_2d_barcode
                           where serial_no       = p_pid
                             and organization_id = 1
                        )
           AND organization_id = 1;

    EXCEPTION

        WHEN NO_DATA_FOUND THEN
             lvs_run_no      := '';
             lvs_comments    := '';
             lvs_marking_no  := '';
             lvs_lot_size    := '0';

    END;

    CASE p_option
         WHEN 'RUN NO'  THEN
              lvs_return := lvs_run_no;
         WHEN 'MODEL'   THEN
              lvs_return := lvs_comments;
         WHEN 'WO'      THEN
              lvs_return := lvs_marking_no;
         WHEN 'LOT SIZE' THEN
              lvs_return := lvs_lot_size;
         ELSE
              lvs_return := 'ERROR';
    END CASE;

    RETURN lvs_return;

EXCEPTION
    WHEN OTHERS THEN
        RETURN 'ERROR';

END;
