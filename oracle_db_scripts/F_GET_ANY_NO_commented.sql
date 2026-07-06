CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_ANY_NO
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
   *   P_NAME  (IN, VARCHAR2) - 명칭 관련 값
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (순수 연산 함수 또는 원본 소스 기준 명시 테이블 없음)
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 30회 / 반복문: 0회
   *   DML: SELECT 15회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_ANY_NO(...) FROM DUAL;
   * ================================================================ */
 "F_GET_ANY_NO" (p_name IN VARCHAR2, p_org IN NUMBER)
   RETURN VARCHAR2
IS
   lvs_return_value   VARCHAR2 (100);
BEGIN

  IF p_name = 'TRANSFER_INVOICE_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd') || SEQ_TRANSFER_INVOICE_SEQ.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;

  IF p_name = 'RECEIPT_LOT_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd') || SEQ_RECEIPT_LOT_NO.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;


  IF p_name = 'CUSTOMER_ORDER_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd') || SEQ_CUSTOMER_ORDER_NO.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;

   IF p_name = 'ORDER_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd') || seq_purchase_order_no.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;

   IF p_name = 'PRODUCT_SHIPPING_INVOICE_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd') || seq_product_shipping_seq.CURRVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;

   IF p_name = 'PRODUCT_SHIPPING_LOT_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd')
             || seq_product_shipping_lot_no.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;


  /* IF p_name = 'WQC_INSPECT_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd')
             || seq_wqc_inspect_no.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;*/

   IF p_name = 'LQC_INSPECT_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd')
             || seq_lqc_inspect_no.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;

   IF p_name = 'OQC_INSPECT_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd')
             || seq_qc_oqc_inspect_no.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;

   IF p_name = 'FQC_INSPECT_NO'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd')
             || seq_fqc_inspect_no.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;


   IF p_name = 'MFS'
   THEN
      SELECT SUBSTR(TO_CHAR (SYSDATE, 'yy'),1,2)||'TC-'
             || seq_mfs.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;

   IF p_name = 'MFS_MGT'
   THEN
      SELECT SUBSTR(TO_CHAR (SYSDATE, 'yy'),1,2)||'TM-'
             || seq_mfs.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;



   IF p_name = 'MATERIAL_SALE_ISSUE_INVOICE'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yymmdd')
             || SEQ_MAT_SALE_ISSUE.NEXTVAL
        INTO lvs_return_value
        FROM DUAL;
   END IF;

   IF p_name = 'PRODUCT_DATE'
   THEN
      SELECT TO_CHAR (SYSDATE, 'yyyymmdd')
        INTO lvs_return_value
        FROM DUAL;
   END IF;

   IF p_name = 'PRODUCT_DATE_LAST'
   THEN
      SELECT TO_CHAR (SYSDATE - 1, 'yyyymmdd')
        INTO lvs_return_value
        FROM DUAL;
   END IF;

   RETURN lvs_return_value;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
