CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_WQC_EXTRACT_QTY_BY_SMT
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
   *   P_RUN_NO  (IN, VARCHAR2) - 작업지시/런 번호
   *   P_WORKSTAGE_CODE  (IN, VARCHAR2) - 공정 코드
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_PRODUCT_WQC - 제품 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_WQC_EXTRACT_QTY_BY_SMT(...) FROM DUAL;
   * ================================================================ */
 "F_GET_WQC_EXTRACT_QTY_BY_SMT" (p_run_no           IN VARCHAR2,
/* Formatted on 2013-01-30 11:04:15 (QP5 v5.126) */
                                      p_workstage_code   IN VARCHAR2)
    RETURN NUMBER
IS
    lvl_qty   NUMBER;
BEGIN
                                           --smt
        SELECT   SUM (NVL (inspect_bad_qty, 0))
          INTO   lvl_qty
          FROM   iq_product_wqc
         WHERE       mfs = p_run_no
                 AND workstage_code = p_workstage_code
                 AND bad_reason_code = '9999';              --pyung ga je pum;


    RETURN NVL (lvl_qty, 0);
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN 0;
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;
