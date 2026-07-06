CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_MSL_WARNING_COUNT
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
   *   P_LINE_CODE  (IN, VARCHAR2) - 라인 코드
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 제품 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_MSL_WARNING_COUNT(...) FROM DUAL;
   * ================================================================ */
 "F_GET_MSL_WARNING_COUNT" (p_line_code IN VARCHAR2)
/* Formatted on 2015-04-24 ??? 11:18:26 (QP5 v5.126) */
    RETURN NUMBER
IS
    lvl_return   NUMBER;
BEGIN
    SELECT   COUNT ( * )
      INTO   lvl_return
      FROM   ib_product_plandata a, id_item b, im_item_receipt_barcode c
     WHERE   a.item_code = b.item_code
         AND a.item_code = c.item_code(+)
         AND a.lot_no = c.lot_no(+)
         AND TRUNC ( ( (SYSDATE - a.change_date) * 24 + NVL (c.msl_passed_time, 0)) / b.msl_max_time * 100, 2) > 95.2
         AND a.active_yn = 'Y'
         AND b.msl_level IS NOT NULL
         AND NVL (b.msl_max_time, 0) <> 0
         AND a.line_code = p_line_code;

    RETURN lvl_return;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN -1;
END;
